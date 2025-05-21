class Constants {
  // Static endpoints base
  static String baseUrl = 'http://localhost/sus';
  static String wsUrl = 'ws://localhost:8080';
  
  // Update base URLs
  static void updateBaseUrls(String serverIp) {
    baseUrl = 'http://$serverIp/sus';
    wsUrl = 'ws://$serverIp:8080';
  }
  
  // API Endpoints (dynamic based on baseUrl)
  static String get loginEndpoint => '$baseUrl/api/login.php';
  static String get getKitchenOrdersEndpoint => '$baseUrl/api/get_kitchen_orders.php';
  static String get updateOrderStatusEndpoint => '$baseUrl/api/update_order_status.php';
  static String get getTablesEndpoint => '$baseUrl/api/get_tables.php';
  static String get updateTableStatusEndpoint => '$baseUrl/api/update_table_status.php';
  static String get getNotificationsEndpoint => '$baseUrl/api/get_notifications.php';

  // Shared Preferences Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String roleKey = 'role';
  static const String usernameKey = 'username';
  
  // Roles
  static const String roleKitchen = 'KITCHEN';
  static const String roleWaiter = 'WAITER';
} 