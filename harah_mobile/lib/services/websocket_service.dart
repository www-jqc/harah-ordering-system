import 'dart:convert';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../constants.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  bool _isConnected = false;
  Function(Map<String, dynamic>)? _onMessageCallback;
  Timer? _reconnectTimer;
  bool _reconnecting = false;

  // Connect to WebSocket server
  Future<bool> connect() async {
    if (_isConnected || _reconnecting) {
      return _isConnected;
    }

    try {
      print('Connecting to WebSocket at ${Constants.wsUrl}');
      _reconnecting = true;
      
      _channel = WebSocketChannel.connect(Uri.parse(Constants.wsUrl));
      
      // Listen for incoming messages
      _channel!.stream.listen((message) {
        try {
          print('Received WebSocket message: $message');
          final data = json.decode(message);
          if (_onMessageCallback != null) {
            _onMessageCallback!(data);
          }
        } catch (e) {
          print('Error parsing WebSocket message: $e');
        }
      }, onDone: () {
        print('WebSocket connection closed');
        _isConnected = false;
        _scheduleReconnect();
      }, onError: (error) {
        print('WebSocket error: $error');
        _isConnected = false;
        _scheduleReconnect();
      });
      
      _isConnected = true;
      _reconnecting = false;
      
      // Send initial handshake message
      _sendHandshake();
      
      print('Successfully connected to WebSocket');
      return true;
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      _isConnected = false;
      _reconnecting = false;
      _scheduleReconnect();
      return false;
    }
  }

  // Schedule a reconnection attempt
  void _scheduleReconnect() {
    if (_reconnecting) {
      return; // Already reconnecting
    }

    print('Scheduling WebSocket reconnection');
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      connect(); // Try to reconnect
    });
  }

  // Send handshake message to identify this client
  void _sendHandshake() {
    if (_isConnected && _channel != null) {
      final handshake = {
        'type': 'handshake',
        'client': 'kitchen_mobile',
        'role': 'KITCHEN'
      };
      
      _channel!.sink.add(json.encode(handshake));
      print('Sent handshake message');
    }
  }

  // Disconnect from WebSocket server
  void disconnect() {
    print('Disconnecting from WebSocket');
    _reconnectTimer?.cancel();
    _reconnecting = false;
    
    if (_isConnected && _channel != null) {
      _channel!.sink.close(status.goingAway);
      _isConnected = false;
    }
  }

  // Send message to WebSocket server
  void sendMessage(Map<String, dynamic> data) {
    if (_isConnected && _channel != null) {
      print('Sending WebSocket message: ${json.encode(data)}');
      _channel!.sink.add(json.encode(data));
    } else {
      print('Cannot send message: WebSocket not connected');
      _scheduleReconnect();
    }
  }

  // Set callback for incoming messages
  void setOnMessageCallback(Function(Map<String, dynamic>) callback) {
    _onMessageCallback = callback;
  }

  // Check if connected to WebSocket server
  bool isConnected() {
    return _isConnected;
  }

  // Reconnect to WebSocket server
  Future<bool> reconnect() async {
    disconnect();
    return await connect();
  }
  
  // Dispose of resources
  void dispose() {
    disconnect();
    _reconnectTimer?.cancel();
  }
} 