class TableModel {
  final int tableId;
  final String tableNumber;
  final String status;
  final String qrCode;
  final DateTime createdAt;
  final List<dynamic>? activeOrders;

  TableModel({
    required this.tableId,
    required this.tableNumber,
    required this.status,
    required this.qrCode,
    required this.createdAt,
    this.activeOrders,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      tableId: int.parse(json['table_id'].toString()),
      tableNumber: json['table_number'] ?? '',
      status: json['status'] ?? 'AVAILABLE',
      qrCode: json['qr_code'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      activeOrders: json['active_orders'],
    );
  }

  // Returns color based on status for UI display
  String getStatusColor() {
    switch (status) {
      case 'AVAILABLE':
        return '0xFF4CAF50'; // Green
      case 'OCCUPIED':
        return '0xFFF44336'; // Red
      case 'READY':
        return '0xFF2196F3'; // Blue
      case 'CLEANING':
        return '0xFFFF9800'; // Orange
      default:
        return '0xFF9E9E9E'; // Grey
    }
  }

  // Returns a human-readable status for display
  String getFormattedStatus() {
    switch (status) {
      case 'AVAILABLE':
        return 'Available';
      case 'OCCUPIED':
        return 'Occupied';
      case 'READY':
        return 'Order Ready';
      case 'CLEANING':
        return 'Cleaning';
      default:
        return status;
    }
  }
} 