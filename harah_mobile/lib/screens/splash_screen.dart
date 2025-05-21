import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/config_provider.dart';
import '../constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay to show splash screen for a moment
    Future.delayed(const Duration(seconds: 2), () {
      _checkConfiguration();
    });
  }

  Future<void> _checkConfiguration() async {
    // Check if server IP is configured
    final configProvider = Provider.of<ConfigProvider>(context, listen: false);
    await configProvider.loadConfig();
    
    if (!mounted) return;
    
    if (!configProvider.isConfigured) {
      // If not configured, redirect to server config screen
      Navigator.of(context).pushReplacementNamed('/server_config');
      return;
    }
    
    // Server is configured, now check authentication
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAuth();
    
    if (!mounted) return;
    
    if (authProvider.isAuthenticated) {
      final role = authProvider.currentUser?.role;
      if (role == Constants.roleKitchen) {
        Navigator.of(context).pushReplacementNamed('/kitchen');
      } else if (role == Constants.roleWaiter) {
        Navigator.of(context).pushReplacementNamed('/waiter');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Icon(
              Icons.restaurant,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            // App Name
            const Text(
              'HARAH',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Kitchen & Waiter App',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
} 