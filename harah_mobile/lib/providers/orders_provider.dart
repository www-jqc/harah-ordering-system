import 'dart:async';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/kitchen_service.dart';
import '../services/notification_service.dart';
import '../services/websocket_service.dart';

class OrdersProvider extends ChangeNotifier {
  final KitchenService _kitchenService = KitchenService();
  final NotificationService _notificationService = NotificationService();
  final WebSocketService _webSocketService = WebSocketService();
  
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _refreshTimer;
  Timer? _reconnectTimer;
  bool _initialLoad = true;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Initialize and connect
  Future<void> initialize() async {
    // Initialize notifications
    await _notificationService.initialize();
    
    // Connect to WebSocket for real-time updates
    await _connectWebSocket();
    
    // Start refresh timer (shorter interval for more responsive updates)
    _startRefreshTimer();
    
    // Load initial data
    await loadOrders();
    
    // Mark as initialized
    _initialLoad = false;
  }

  // Connect to WebSocket and set up event handlers
  Future<void> _connectWebSocket() async {
    await _webSocketService.connect();
    _webSocketService.setOnMessageCallback(_handleWebSocketMessage);
    
    // Set up reconnection strategy if connection fails
    if (!_webSocketService.isConnected()) {
      _scheduleReconnect();
    }
  }

  // Schedule a reconnection attempt
  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () async {
      print('Attempting to reconnect to WebSocket...');
      await _connectWebSocket();
    });
  }

  // Handle WebSocket messages
  void _handleWebSocketMessage(Map<String, dynamic> data) {
    if (data['type'] == 'order_update' || data['type'] == 'new_order') {
      // Show notification only if it's not the initial load
      if (!_initialLoad) {
        _notificationService.showNotification(
          data['type'] == 'new_order' ? 'New Order' : 'Order Update', 
          data['message'] ?? 'New order activity',
        );
      }
      
      // Refresh orders immediately
      loadOrders();
    }
  }

  // Start timer to refresh orders periodically
  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    // Reduced from 30 seconds to 5 seconds for more responsive updates
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      loadOrders();
    });
  }

  // Load orders from API
  Future<void> loadOrders() async {
    // Don't show loading indicator for background refreshes
    final bool showLoading = _orders.isEmpty;
    
    if (showLoading) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final orders = await _kitchenService.getKitchenOrders();
      
      // Check for new orders to show notifications
      if (!_initialLoad && orders.isNotEmpty && _orders.isNotEmpty) {
        final currentOrderIds = _orders.map((o) => o.orderId).toSet();
        final newOrders = orders.where((o) => !currentOrderIds.contains(o.orderId)).toList();
        
        if (newOrders.isNotEmpty) {
          // Show notification for new orders
          _notificationService.showNotification(
            'New Order', 
            'You have ${newOrders.length} new order(s) to prepare',
          );
        }
      }
      
      _orders = orders;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load orders: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mark order as preparing
  Future<bool> markOrderAsPreparing(int orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _kitchenService.markOrderAsPreparing(orderId);
      
      if (success) {
        // Find the order and update its status locally for immediate UI update
        final orderIndex = _orders.indexWhere((order) => order.orderId == orderId);
        if (orderIndex != -1) {
          _orders[orderIndex] = _orders[orderIndex].copyWith(status: 'PREPARING');
          notifyListeners();
        }
        
        // Then reload all orders to ensure consistency
        await loadOrders();
        return true;
      } else {
        _errorMessage = 'Failed to update order status';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mark order as ready
  Future<bool> markOrderAsReady(int orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _kitchenService.markOrderAsReady(orderId);
      
      if (success) {
        // Find the order and update its status locally for immediate UI update
        final orderIndex = _orders.indexWhere((order) => order.orderId == orderId);
        if (orderIndex != -1) {
          _orders[orderIndex] = _orders[orderIndex].copyWith(status: 'READY');
          notifyListeners();
        }
        
        // Then reload all orders to ensure consistency
        await loadOrders();
        return true;
      } else {
        _errorMessage = 'Failed to update order status';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clean up resources
  @override
  void dispose() {
    _refreshTimer?.cancel();
    _reconnectTimer?.cancel();
    _webSocketService.disconnect();
    super.dispose();
  }
} 