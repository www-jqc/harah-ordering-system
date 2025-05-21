import 'dart:async';
import 'package:flutter/material.dart';
import '../models/table_model.dart';
import '../services/waiter_service.dart';
import '../services/notification_service.dart';
import '../services/websocket_service.dart';

class TablesProvider extends ChangeNotifier {
  final WaiterService _waiterService = WaiterService();
  final NotificationService _notificationService = NotificationService();
  final WebSocketService _webSocketService = WebSocketService();
  
  List<TableModel> _tables = [];
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _refreshTimer;

  List<TableModel> get tables => _tables;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Initialize and connect
  Future<void> initialize() async {
    // Initialize notifications
    await _notificationService.initialize();
    
    // Connect to WebSocket for real-time updates
    await _webSocketService.connect();
    _webSocketService.setOnMessageCallback(_handleWebSocketMessage);
    
    // Start refresh timer
    _startRefreshTimer();
    
    // Load initial data
    await loadTables();
  }

  // Handle WebSocket messages
  void _handleWebSocketMessage(Map<String, dynamic> data) {
    if (data['type'] == 'table_status' || data['type'] == 'order_ready') {
      // Show notification
      _notificationService.showNotification(
        'Table Update', 
        data['message'] ?? 'Table status has changed',
      );
      
      // Refresh tables
      loadTables();
    }
  }

  // Start timer to refresh tables periodically
  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      loadTables();
    });
  }

  // Load tables from API
  Future<void> loadTables() async {
    _isLoading = true;
    notifyListeners();

    try {
      final tables = await _waiterService.getTables();
      _tables = tables;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load tables: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update table status
  Future<bool> updateTableStatus(int tableId, String status) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _waiterService.updateTableStatus(tableId, status);
      
      if (success) {
        await loadTables();
        return true;
      } else {
        _errorMessage = 'Failed to update table status';
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

  // Mark order as served
  Future<bool> markOrderAsServed(int orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _waiterService.markOrderAsServed(orderId);
      
      if (success) {
        await loadTables();
        return true;
      } else {
        _errorMessage = 'Failed to mark order as served';
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

  // Get available tables
  List<TableModel> getAvailableTables() {
    return _tables.where((table) => table.status == 'AVAILABLE').toList();
  }

  // Get occupied tables
  List<TableModel> getOccupiedTables() {
    return _tables.where((table) => table.status == 'OCCUPIED').toList();
  }

  // Get tables with orders ready to serve
  List<TableModel> getReadyTables() {
    return _tables.where((table) => table.status == 'READY').toList();
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
    _webSocketService.disconnect();
    super.dispose();
  }
} 