import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/orders_provider.dart';
import '../../models/order.dart';
import '../../services/notification_service.dart';
import '../../models/notification_model.dart';
import 'order_details_screen.dart';

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  int _notificationCount = 0;
  late NotificationService _notificationService;
  late Stream<NotificationModel> _notificationStream;

  @override
  void initState() {
    super.initState();
    // Initialize orders provider when screen loads
    Future.microtask(() {
      Provider.of<OrdersProvider>(context, listen: false).initialize();
    });
    
    // Setup notification service
    _notificationService = NotificationService();
    _notificationService.initialize().then((_) {
      // Connect to websocket with role
      _notificationService.connectWebSocket('KITCHEN');
      
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
    final notifications = await _notificationService.getNotifications('KITCHEN');
    setState(() {
      _notificationCount = notifications.where((n) => !n.isRead).length;
    });
  }

  void _showNotifications() async {
    final notifications = await _notificationService.getNotifications('KITCHEN');
    
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
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    // Group orders by status
    final pendingOrders = ordersProvider.orders
        .where((order) => order.status == 'PAID')
        .toList();
    
    final preparingOrders = ordersProvider.orders
        .where((order) => order.status == 'PREPARING')
        .toList();
    
    final readyOrders = ordersProvider.orders
        .where((order) => order.status == 'READY')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Orders'),
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
            onPressed: () => ordersProvider.loadOrders(),
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
      body: ordersProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ordersProvider.orders.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No orders at the moment',
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
                            text: 'New (${pendingOrders.length})',
                            icon: const Icon(Icons.receipt),
                          ),
                          Tab(
                            text: 'Preparing (${preparingOrders.length})',
                            icon: const Icon(Icons.restaurant),
                          ),
                          Tab(
                            text: 'Ready (${readyOrders.length})',
                            icon: const Icon(Icons.check_circle),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // New Orders Tab
                            _buildOrdersList(context, pendingOrders, 'PAID'),
                            // Preparing Orders Tab
                            _buildOrdersList(context, preparingOrders, 'PREPARING'),
                            // Ready Orders Tab
                            _buildOrdersList(context, readyOrders, 'READY'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildOrdersList(BuildContext context, List<Order> orders, String status) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status == 'PAID' ? Icons.receipt_long : 
              status == 'PREPARING' ? Icons.restaurant : 
              Icons.check_circle,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              status == 'PAID' ? 'No new orders' : 
              status == 'PREPARING' ? 'No orders in preparation' : 
              'No orders ready to serve',
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
      onRefresh: () => ordersProvider.loadOrders(),
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Row(
                children: [
                  Text(
                    'Order #${order.orderId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: order.orderType == 'DINE_IN' ? Colors.blue[100] : Colors.green[100],
                    ),
                    child: Text(
                      order.orderType == 'DINE_IN' ? 'Dine In' : 'Takeout',
                      style: TextStyle(
                        fontSize: 12,
                        color: order.orderType == 'DINE_IN' ? Colors.blue[800] : Colors.green[800],
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (order.tableNumber != 'N/A') 
                    Text('Table: ${order.tableNumber}'),
                  Text('Time: ${order.getFormattedTime()}'),
                  Text('${order.items.length} items'),
                ],
              ),
              trailing: _buildActionButton(context, order, status),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(order: order),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, Order order, String status) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    
    if (status == 'PAID') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          ordersProvider.markOrderAsPreparing(order.orderId);
        },
        child: const Text('Start'),
      );
    } else if (status == 'PREPARING') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          ordersProvider.markOrderAsReady(order.orderId);
        },
        child: const Text('Ready'),
      );
    } else {
      return const Icon(Icons.check_circle, color: Colors.green);
    }
  }
} 