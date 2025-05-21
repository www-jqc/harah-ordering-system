import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/table_model.dart';
import '../models/order.dart';

class WaiterService {
  // Get all tables
  Future<List<TableModel>> getTables() async {
    try {
      final response = await http.get(
        Uri.parse(Constants.getTablesEndpoint),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true && data['tables'] != null) {
          final List<dynamic> tablesList = data['tables'];
          return tablesList.map((json) => TableModel.fromJson(json)).toList();
        }
        
        return [];
      } else {
        print('Failed to load tables. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error getting tables: $e');
      return [];
    }
  }

  // Get orders for a specific table
  Future<List<Order>> getTableOrders(int tableId) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/api/get_table_orders.php?table_id=$tableId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true && data['orders'] != null) {
          final List<dynamic> ordersList = data['orders'];
          return ordersList.map((json) => Order.fromJson(json)).toList();
        }
        
        return [];
      } else {
        print('Failed to load table orders. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error getting table orders: $e');
      return [];
    }
  }

  // Update table status
  Future<bool> updateTableStatus(int tableId, String status) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.updateTableStatusEndpoint),
        body: {
          'table_id': tableId.toString(),
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      } else {
        print('Failed to update table status. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating table status: $e');
      return false;
    }
  }

  // Mark order as served
  Future<bool> markOrderAsServed(int orderId) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.updateOrderStatusEndpoint),
        body: {
          'order_id': orderId.toString(),
          'status': 'SERVED',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      } else {
        print('Failed to mark order as served. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error marking order as served: $e');
      return false;
    }
  }
} 