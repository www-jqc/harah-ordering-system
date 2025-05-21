import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/kitchen/kitchen_screen.dart';
import 'screens/waiter/waiter_screen.dart';
import 'screens/server_config_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/tables_provider.dart';
import 'providers/config_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConfigProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => TablesProvider()),
      ],
      child: MaterialApp(
        title: 'Harah Mobile',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'Poppins',
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/kitchen': (context) => const KitchenScreen(),
          '/waiter': (context) => const WaiterScreen(),
          '/server_config': (context) => const ServerConfigScreen(),
        },
      ),
    );
  }
}
