import 'package:flutter/material.dart';

// 1. Import all your screens
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const AivaApp());
}

class AivaApp extends StatelessWidget {
  const AivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIVA Assistant',
      debugShowCheckedModeBanner: false,

      // Global Theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: const Color(0xFF26C6DA), // Cyan
        scaffoldBackgroundColor: Colors.white,
      ),

      // 2. Define Navigation Routes
      initialRoute: '/',
      routes: {
        // Start app at Splash Screen
        '/': (context) => const SplashScreen(),

        // Auth Screens
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),

        // Home/Dashboard Screen
        '/dashboard': (context) => const DashboardScreen(),

        // Chat Screen (Placeholder for now - we will build this next!)
        '/chat': (context) => const Scaffold(
          backgroundColor: Color(0xFFE0F7FA),
          body: Center(
            child: Text(
              "Chat Screen Loading...",
              style: TextStyle(fontSize: 18, color: Color(0xFF00ACC1)),
            ),
          ),
        ),
      },
    );
  }
}