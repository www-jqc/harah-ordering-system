import 'package:intl/intl.dart';
import 'dart:convert';

class OrderItem {
  final int orderItemId;
  final int productId;
  final String productName;
  final String? productCode;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  OrderItem({
    required this.orderItemId,
    required this.productId,
    required this.productName,
    this.productCode,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderItemId: int.parse(json['order_item_id'].toString()),
      productId: int.parse(json['product_id'].toString()),
      productName: json['product_name'] ?? '',
      productCode: json['product_code'],
      quantity: int.parse(json['quantity'].toString()),
      unitPrice: double.parse(json['unit_price'].toString()),
      subtotal: double.parse(json['subtotal'].toString()),
    );
  }
}

class Order {
  final int orderId;
  final int? tableId;
  final String tableNumber;
  final String orderType;
  final String status;
  final double totalAmount;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.orderId,
    this.tableId,
    required this.tableNumber,
    required this.orderType,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.items,
  });

  // Create a copy with modified properties
  Order copyWith({
    int? orderId,
    int? tableId,
    String? tableNumber,
    String? orderType,
    String? status,
    double? totalAmount,
    DateTime? createdAt,
    List<OrderItem>? items,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      tableId: tableId ?? this.tableId,
      tableNumber: tableNumber ?? this.tableNumber,
      orderType: orderType ?? this.orderType,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem> orderItems = [];
    
    // Debug output
    print('Order items data type: ${json['items']?.runtimeType}');
    if (json['items'] != null) {
      print('Items content: ${json['items'].toString().substring(0, min(50, json['items'].toString().length))}...');
    }
    
    // Handle different formats of items
    if (json['items'] != null) {
      try {
        if (json['items'] is String) {
          // Try to parse the items if it's a JSON string
          final decoded = jsonDecode(json['items']);
          if (decoded is List) {
            orderItems = decoded
                .map((item) => OrderItem.fromJson(item))
                .toList();
          }
        } else if (json['items'] is List) {
          // Direct list of items
          orderItems = (json['items'] as List)
              .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      } catch (e) {
        print('Error parsing order items: $e');
      }
    }

    return Order(
      orderId: int.parse(json['order_id'].toString()),
      tableId: json['table_id'] != null ? int.parse(json['table_id'].toString()) : null,
      tableNumber: json['table_number'] ?? 'N/A',
      orderType: json['order_type'] ?? '',
      status: json['status'] ?? '',
      totalAmount: double.parse(json['total_amount'].toString()),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      items: orderItems,
    );
  }

  String getFormattedTime() {
    final DateFormat formatter = DateFormat('h:mm a');
    return formatter.format(createdAt);
  }

  String getFormattedDate() {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(createdAt);
  }
  
  // Helper method for string length
  static int min(int a, int b) {
    return a < b ? a : b;
  }
} 