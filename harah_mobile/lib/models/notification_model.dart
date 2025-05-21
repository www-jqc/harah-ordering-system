import 'package:intl/intl.dart';

class NotificationModel {
  final int notificationId;
  final int? orderId;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.notificationId,
    this.orderId,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: int.parse(json['notification_id'].toString()),
      orderId: json['order_id'] != null ? int.parse(json['order_id'].toString()) : null,
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      isRead: json['is_read'] == '1' || json['is_read'] == 1 || json['is_read'] == true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
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

  // Returns color based on notification type for UI display
  String getTypeColor() {
    switch (type) {
      case 'ORDER_READY':
        return '0xFF4CAF50'; // Green
      case 'TABLE_STATUS':
        return '0xFF2196F3'; // Blue
      case 'PAYMENT':
        return '0xFFF44336'; // Red
      default:
        return '0xFF9E9E9E'; // Grey
    }
  }

  // Returns an icon based on notification type for UI display
  String getTypeIcon() {
    switch (type) {
      case 'ORDER_READY':
        return 'restaurant';
      case 'TABLE_STATUS':
        return 'table_bar';
      case 'PAYMENT':
        return 'payments';
      default:
        return 'notifications';
    }
  }
} 