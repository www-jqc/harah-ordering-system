import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants.dart';
import '../models/user.dart';

class AuthService {
  final storage = const FlutterSecureStorage();
  
  // Login user
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('Attempting to login to: ${Constants.loginEndpoint}');
      print('With username: $username and role: KITCHEN,WAITER');
      
      final response = await http.post(
        Uri.parse(Constants.loginEndpoint),
        body: {
          'username': username,
          'password': password,
          'role': 'KITCHEN,WAITER', // Only allow KITCHEN or WAITER roles
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      // Try to decode JSON response
      Map<String, dynamic> data;
      try {
        data = json.decode(response.body);
      } catch (e) {
        print('JSON decode error: $e');
        return {
          'success': false,
          'message': 'Invalid response format: ${response.body.substring(0, min(100, response.body.length))}'
        };
      }
      
      if (response.statusCode == 200 && data['success'] == true) {
        // Store user data in secure storage
        final user = User.fromJson(data['user']);
        await _saveUserData(user);
        
        return {
          'success': true,
          'user': user,
          'message': 'Login successful',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed. Please try again.'
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'An error occurred: $e'
      };
    }
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Clear stored user data
    await prefs.clear();
    await storage.deleteAll();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(Constants.userIdKey);
    final role = prefs.getString(Constants.roleKey);
    
    // Verify user has a role that's allowed in the app
    if (userId != null && role != null) {
      return role == Constants.roleKitchen || role == Constants.roleWaiter;
    }
    
    return false;
  }

  // Get current user role
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.roleKey);
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    
    final userId = prefs.getString(Constants.userIdKey);
    final username = prefs.getString(Constants.usernameKey);
    final role = prefs.getString(Constants.roleKey);
    
    if (userId != null && username != null && role != null) {
      // Get additional user data from secure storage
      final firstName = await storage.read(key: 'first_name') ?? '';
      final lastName = await storage.read(key: 'last_name') ?? '';
      final employeeId = await storage.read(key: 'employee_id') ?? '0';
      
      return User(
        userId: int.parse(userId),
        username: username,
        role: role,
        employeeId: int.parse(employeeId),
        firstName: firstName,
        lastName: lastName,
      );
    }
    
    return null;
  }

  // Save user data after successful login
  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save basic data in SharedPreferences
    await prefs.setString(Constants.userIdKey, user.userId.toString());
    await prefs.setString(Constants.usernameKey, user.username);
    await prefs.setString(Constants.roleKey, user.role);
    
    // Save sensitive data in secure storage
    await storage.write(key: 'employee_id', value: user.employeeId.toString());
    await storage.write(key: 'first_name', value: user.firstName);
    await storage.write(key: 'last_name', value: user.lastName);
  }
} 