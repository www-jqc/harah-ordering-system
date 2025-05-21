import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/order.dart';

class KitchenService {
  // Get pending orders for kitchen
  Future<List<Order>> getKitchenOrders() async {
    try {
      print('Fetching kitchen orders from: ${Constants.getKitchenOrdersEndpoint}');
      
      final response = await http.get(
        Uri.parse(Constants.getKitchenOrdersEndpoint),
      );

      print('Response status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        // Debug the response body
        final responseBody = response.body;
        print('Response body length: ${responseBody.length}');
        print('Response body preview: ${responseBody.substring(0, responseBody.length > 100 ? 100 : responseBody.length)}...');
        
        final data = json.decode(responseBody);
        
        print('Decoded success flag: ${data['success']}');
        print('Orders count in response: ${data['orders']?.length ?? 'null'}');
        
        if (data['success'] == true && data['orders'] != null) {
          final List<dynamic> ordersList = data['orders'];
          
          // Debug the first order if available
          if (ordersList.isNotEmpty) {
            print('First order preview: ${json.encode(ordersList[0]).substring(0, 100)}...');
            
            // Check if first order has items
            if (ordersList[0]['items'] != null) {
              print('First order items type: ${ordersList[0]['items'].runtimeType}');
              print('First order items count: ${ordersList[0]['items'] is List ? ordersList[0]['items'].length : 'not a list'}');
            } else {
              print('First order items is null');
            }
          }
          
          final orders = ordersList.map((json) => Order.fromJson(json)).toList();
          print('Parsed ${orders.length} orders');
          
          // Debug items in the first parsed order
          if (orders.isNotEmpty) {
            print('First parsed order ID: ${orders[0].orderId}');
            print('First parsed order items count: ${orders[0].items.length}');
          }
          
          return orders;
        }
        
        print('Success flag was false or orders was null');
        return [];
      } else {
        print('Failed to load kitchen orders. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error getting kitchen orders: $e');
      return [];
    }
  }

  // Update order status to PREPARING
  Future<bool> markOrderAsPreparing(int orderId) async {
    return await _updateOrderStatus(orderId, 'PREPARING');
  }

  // Update order status to READY
  Future<bool> markOrderAsReady(int orderId) async {
    return await _updateOrderStatus(orderId, 'READY');
  }
  
  // Update order status to COMPLETED
  Future<bool> markOrderAsCompleted(int orderId) async {
    return await _updateOrderStatus(orderId, 'COMPLETED');
  }

  // Generic method to update order status
  Future<bool> _updateOrderStatus(int orderId, String status) async {
    try {
      print('Updating order #$orderId to status: $status');
      
      final response = await http.post(
        Uri.parse(Constants.updateOrderStatusEndpoint),
        body: {
          'order_id': orderId.toString(),
          'status': status,
        },
      );

      print('Update status code: ${response.statusCode}');
      print('Update response: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      } else {
        print('Failed to update order status. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }
} 