import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tables_provider.dart';
import '../../models/table_model.dart';
import '../../services/notification_service.dart';
import '../../models/notification_model.dart';
import 'table_details_screen.dart';

class WaiterScreen extends StatefulWidget {
  const WaiterScreen({super.key});

  @override
  State<WaiterScreen> createState() => _WaiterScreenState();
}

class _WaiterScreenState extends State<WaiterScreen> {
  int _notificationCount = 0;
  late NotificationService _notificationService;
  late Stream<NotificationModel> _notificationStream;

  @override
  void initState() {
    super.initState();
    // Initialize tables provider when screen loads
    Future.microtask(() {
      Provider.of<TablesProvider>(context, listen: false).initialize();
    });

    // Setup notification service
    _notificationService = NotificationService();
    _notificationService.initialize().then((_) {
      // Connect to websocket with role
      _notificationService.connectWebSocket('WAITER');
      
      // Listen to notification stream
      _notificationStream = _notificationService.notificationStream;
      _notificationStream.listen((notification) {
        // Update notification count
        if (!notification.isRead) {
          setState(() {
            _notificationCount++;
          });
        }
      });
      
      // Initial notification count
      _loadNotificationCount();
    });
  }

  @override
  void dispose() {
    _notificationService.dispose();
    super.dispose();
  }

  Future<void> _loadNotificationCount() async {
    final notifications = await _notificationService.getNotifications('WAITER');
    setState(() {
      _notificationCount = notifications.where((n) => !n.isRead).length;
    });
  }

  void _showNotifications() async {
    final notifications = await _notificationService.getNotifications('WAITER');
    
    // Show notification dialog
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: SizedBox(
          width: double.maxFinite,
          child: notifications.isEmpty
              ? const Center(child: Text('No notifications'))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      title: Text(notification.message),
                      subtitle: Text(notification.getFormattedTime()),
                      leading: Icon(
                        Icons.notifications,
                        color: notification.isRead ? Colors.grey : Theme.of(context).primaryColor,
                      ),
                      onTap: () async {
                        // Mark as read
                        await _notificationService.markAsRead(notification.notificationId);
                        // Refresh notification count
                        _loadNotificationCount();
                        // Close dialog
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablesProvider = Provider.of<TablesProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Management'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // Notification Icon with Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: _showNotifications,
              ),
              if (_notificationCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _notificationCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => tablesProvider.loadTables(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        authProvider.logout();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: tablesProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : tablesProvider.tables.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.table_bar, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No tables available',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Theme.of(context).primaryColor,
                        tabs: [
                          Tab(
                            text: 'Available (${tablesProvider.getAvailableTables().length})',
                            icon: const Icon(Icons.check_circle),
                          ),
                          Tab(
                            text: 'Occupied (${tablesProvider.getOccupiedTables().length})',
                            icon: const Icon(Icons.people),
                          ),
                          Tab(
                            text: 'Ready (${tablesProvider.getReadyTables().length})',
                            icon: const Icon(Icons.restaurant),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // Available Tables Tab
                            _buildTablesGrid(context, tablesProvider.getAvailableTables(), 'AVAILABLE'),
                            // Occupied Tables Tab
                            _buildTablesGrid(context, tablesProvider.getOccupiedTables(), 'OCCUPIED'),
                            // Ready Tables Tab
                            _buildTablesGrid(context, tablesProvider.getReadyTables(), 'READY'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildTablesGrid(BuildContext context, List<TableModel> tables, String status) {
    if (tables.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status == 'AVAILABLE' ? Icons.check_circle : 
              status == 'OCCUPIED' ? Icons.people : 
              Icons.restaurant,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              status == 'AVAILABLE' ? 'No available tables' : 
              status == 'OCCUPIED' ? 'No occupied tables' : 
              'No tables ready to serve',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () => Provider.of<TablesProvider>(context, listen: false).loadTables(),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: tables.length,
        itemBuilder: (context, index) {
          final table = tables[index];
          return _buildTableCard(context, table);
        },
      ),
    );
  }

  Widget _buildTableCard(BuildContext context, TableModel table) {
    final Color statusColor = Color(int.parse(table.getStatusColor()));
    
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TableDetailsScreen(table: table),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: statusColor,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_bar,
              size: 48,
              color: statusColor,
            ),
            const SizedBox(height: 12),
            Text(
              'Table ${table.tableNumber}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                table.getFormattedStatus(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (table.status == 'OCCUPIED' && table.activeOrders != null && table.activeOrders!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${table.activeOrders!.length} Order(s)',
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 