import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class ConfigProvider with ChangeNotifier {
  String _serverIp = 'localhost';
  bool _isConfigured = false;
  
  // Getters
  String get serverIp => _serverIp;
  bool get isConfigured => _isConfigured;
  
  // Base URLs computed from server IP
  String get baseUrl => 'http://$_serverIp/sus';
  String get wsUrl => 'ws://$_serverIp:8080';
  
  // Initialize
  Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    _serverIp = prefs.getString('server_ip') ?? 'localhost';
    _isConfigured = prefs.getBool('is_configured') ?? false;
    
    // Update Constants with the loaded server IP
    Constants.updateBaseUrls(_serverIp);
    
    notifyListeners();
  }
  
  // Save server IP
  Future<void> saveServerIp(String ip) async {
    _serverIp = ip;
    _isConfigured = true;
    
    // Update Constants with new server IP
    Constants.updateBaseUrls(ip);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_ip', ip);
    await prefs.setBool('is_configured', true);
    
    notifyListeners();
  }
  
  // Reset configuration
  Future<void> resetConfig() async {
    _serverIp = 'localhost';
    _isConfigured = false;
    
    // Update Constants with default server IP
    Constants.updateBaseUrls('localhost');
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('server_ip');
    await prefs.setBool('is_configured', false);
    
    notifyListeners();
  }
} 