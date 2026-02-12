import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ✅ Theme Manager
import 'theme_manager.dart';

// --- Screens ---
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/profile_screen.dart';
import 'mic_screen.dart'; // Ensure this path matches your project structure
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const AivaApp());
}

class AivaApp extends StatelessWidget {
  const AivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to Theme changes in real-time
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'AIVA Assistant',
          debugShowCheckedModeBanner: false,

          // Apply the current theme mode
          themeMode: currentMode,

          // ☀️ LIGHT THEME
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primaryColor: const Color(0xFF26C6DA),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
          ),

          // 🌙 DARK THEME
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF26C6DA),
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
            ),
          ),

          // Persistent Login Logic
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              if (snapshot.hasData) {
                return const DashboardScreen();
              }
              return const LoginScreen();
            },
          ),

          // App Navigation Routes
          routes: {
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/chat': (context) => const ChatScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/mic': (context) => const MicScreen(),
            '/history': (context) => const HistoryScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}