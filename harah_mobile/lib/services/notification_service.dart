import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/notification_model.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  Timer? _pollingTimer;
  final StreamController<NotificationModel> _notificationStreamController = 
      StreamController<NotificationModel>.broadcast();
  
  Stream<NotificationModel> get notificationStream => _notificationStreamController.stream;
  String _currentRole = '';
  int _lastNotificationId = 0;

  // Initialize notification service
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
        
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    // Initialize with callback for handling notification taps
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        print('Notification tapped: ${response.payload}');
      },
    );
    
    // Request permissions on iOS
    await _requestPermissions();
    
    // Load last notification ID from shared preferences
    await _loadLastNotificationId();
  }
  
  // Request notification permissions
  Future<void> _requestPermissions() async {
    // For iOS
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        
    // For Android 13+
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }
  
  // Connect to WebSocket for real-time notifications
  void connectWebSocket(String role) {
    _currentRole = role;
    
    try {
      final wsUrl = '${Constants.wsUrl}';
      _channel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
      
      _channel!.stream.listen(
        (message) {
          final data = json.decode(message);
          if (data['type'] == 'notification') {
            final notification = NotificationModel.fromJson(data['notification']);
            _lastNotificationId = notification.notificationId;
            _saveLastNotificationId();
            
            // Add to stream for UI updates
            _notificationStreamController.add(notification);
            
            // Show local notification
            showNotification(
              notification.type, 
              notification.message
            );
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
          _scheduleReconnect();
        },
        onDone: () {
          print('WebSocket connection closed');
          _scheduleReconnect();
        },
      );
    } catch (e) {
      print('Failed to connect to WebSocket: $e');
      _scheduleReconnect();
      
      // Fallback to polling if WebSocket fails
      _startPolling();
    }
  }
  
  // Fallback to polling if WebSocket is not available
  void _startPolling() {
    // Cancel existing timer if any
    _pollingTimer?.cancel();
    
    // Poll for new notifications every 10 seconds
    _pollingTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      final notifications = await getNotifications(_currentRole);
      if (notifications.isNotEmpty) {
        // Check for notifications newer than the last processed one
        final newNotifications = notifications
            .where((notification) => notification.notificationId > _lastNotificationId)
            .toList();
        
        if (newNotifications.isNotEmpty) {
          // Process new notifications
          for (var notification in newNotifications) {
            if (notification.notificationId > _lastNotificationId) {
              _lastNotificationId = notification.notificationId;
              
              // Add to stream for UI updates
              _notificationStreamController.add(notification);
              
              // Show local notification
              showNotification(
                notification.type, 
                notification.message
              );
            }
          }
          
          // Save last processed notification ID
          _saveLastNotificationId();
        }
      }
    });
  }
  
  void _scheduleReconnect() {
    // Cancel existing timer if any
    _reconnectTimer?.cancel();
    
    // Try to reconnect after 5 seconds
    _reconnectTimer = Timer(Duration(seconds: 5), () {
      connectWebSocket(_currentRole);
    });
  }
  
  Future<void> _loadLastNotificationId() async {
    final prefs = await SharedPreferences.getInstance();
    _lastNotificationId = prefs.getInt('last_notification_id') ?? 0;
  }
  
  Future<void> _saveLastNotificationId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_notification_id', _lastNotificationId);
  }
  
  void dispose() {
    _channel?.sink.close();
    _reconnectTimer?.cancel();
    _pollingTimer?.cancel();
    _notificationStreamController.close();
  }

  // Get all notifications
  Future<List<NotificationModel>> getNotifications(String role) async {
    try {
      final response = await http.get(
        Uri.parse(Constants.getNotificationsEndpoint),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true && data['notifications'] != null) {
          final List<dynamic> notificationsList = data['notifications'];
          return notificationsList
              .map((json) => NotificationModel.fromJson(json))
              .toList();
        }
        
        return [];
      } else {
        print('Failed to load notifications. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  // Show local notification
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'harah_channel_id',
      'Harah Notifications',
      channelDescription: 'Channel for Harah app notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      channelShowBadge: true,
      // Enable this for heads-up notifications
      fullScreenIntent: true,
    );
    
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
    
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond, // Use a unique ID for each notification
      title,
      body,
      notificationDetails,
      payload: 'notification_payload',
    );
  }

  // Mark notification as read
  Future<bool> markAsRead(int notificationId) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/mark_notification_read.php'),
        body: {
          'notification_id': notificationId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      } else {
        print('Failed to mark notification as read. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }
} 