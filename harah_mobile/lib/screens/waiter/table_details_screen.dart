import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/table_model.dart';
import '../../models/order.dart';
import '../../providers/tables_provider.dart';
import '../../services/waiter_service.dart';

class TableDetailsScreen extends StatefulWidget {
  final TableModel table;

  const TableDetailsScreen({super.key, required this.table});

  @override
  State<TableDetailsScreen> createState() => _TableDetailsScreenState();
}

class _TableDetailsScreenState extends State<TableDetailsScreen> {
  List<Order> _tableOrders = [];
  bool _isLoading = false;
  final WaiterService _waiterService = WaiterService();

  @override
  void initState() {
    super.initState();
    _loadTableOrders();
  }

  Future<void> _loadTableOrders() async {
    if (widget.table.tableId == 0) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final orders = await _waiterService.getTableOrders(widget.table.tableId);
      setState(() {
        _tableOrders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error', 'Failed to load table orders: $e');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _changeTableStatus(String status) async {
    final tablesProvider = Provider.of<TablesProvider>(context, listen: false);
    
    final success = await tablesProvider.updateTableStatus(widget.table.tableId, status);
    
    if (!mounted) return;
    
    if (success) {
      Navigator.of(context).pop();
    } else {
      _showErrorDialog('Error', 'Failed to update table status. Please try again.');
    }
  }

  Future<void> _markOrderAsServed(int orderId) async {
    setState(() {
      _isLoading = true;
    });

    final tablesProvider = Provider.of<TablesProvider>(context, listen: false);
    final success = await tablesProvider.markOrderAsServed(orderId);
    
    if (!mounted) return;
    
    if (success) {
      await _loadTableOrders();
    } else {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error', 'Failed to mark order as served. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = Color(int.parse(widget.table.getStatusColor()));
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Table ${widget.table.tableNumber}'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTableOrders,
          ),
        ],
      ),
      body: Column(
        children: [
          // Table Info Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Table ${widget.table.tableNumber}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.table.getFormattedStatus(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Change to Available
                      if (widget.table.status != 'AVAILABLE')
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Available'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _changeTableStatus('AVAILABLE'),
                          ),
                        ),
                      const SizedBox(width: 8),
                      // Change to Cleaning
                      if (widget.table.status != 'CLEANING')
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.cleaning_services),
                            label: const Text('Cleaning'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _changeTableStatus('CLEANING'),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Table Orders Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.receipt_long),
                const SizedBox(width: 8),
                const Text(
                  'Active Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_tableOrders.length} Order(s)',
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Orders List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _tableOrders.isEmpty
                    ? const Center(
                        child: Text(
                          'No active orders for this table',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _tableOrders.length,
                        itemBuilder: (context, index) {
                          final order = _tableOrders[index];
                          return Card(
                            child: ListTile(
                              title: Text(
                                'Order #${order.orderId}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Status: ${order.status}'),
                                  Text('Items: ${order.items.length}'),
                                  Text('Time: ${order.getFormattedTime()}'),
                                ],
                              ),
                              trailing: order.status == 'READY'
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () => _markOrderAsServed(order.orderId),
                                      child: const Text('Served'),
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
} 