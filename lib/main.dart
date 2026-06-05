import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pizza_provider.dart';
import 'providers/order_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';

// Ye app ka entry point ha, yahan se program start hota ha
void main() {
  runApp(
    // MultiProvider hum isliye use karte hain taake app ka state (data) manage ho sake
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PizzaProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const PizzaHubApp(),
    ),
  );
}

class PizzaHubApp extends StatelessWidget {
  const PizzaHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PizzaHub',
      debugShowCheckedModeBanner: false, // Top right corner se 'debug' wala tag hatane ke liye
      theme: AppTheme.lightTheme, // Hamara custom theme
      home: const SplashScreen(), // Sab se pehle splash screen dikhegi
    );
  }
}
