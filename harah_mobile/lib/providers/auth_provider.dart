import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  // Check authentication status on app startup
  Future<void> checkAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isLoggedIn = await _authService.isLoggedIn();
      
      if (isLoggedIn) {
        _currentUser = await _authService.getCurrentUser();
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
        _currentUser = null;
      }
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to check authentication status';
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(username, password);
      
      if (result['success']) {
        _currentUser = result['user'];
        _isAuthenticated = true;
        _errorMessage = null;
        return true;
      } else {
        _errorMessage = result['message'];
        _isAuthenticated = false;
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred during login';
      _isAuthenticated = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _currentUser = null;
      _isAuthenticated = false;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to logout';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear any error messages
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 