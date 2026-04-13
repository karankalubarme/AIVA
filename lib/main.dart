import 'package:flutter/material.dart';
import 'services/appwrite_auth_service.dart';
import 'package:appwrite/models.dart' as models;

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
import 'screens/calculator_screen.dart';
import 'screens/engineering_hub_screen.dart';

import 'screens/ocr_screen.dart';
import 'screens/study_planner_screen.dart';
import 'screens/reminder_screen.dart';
import 'screens/branch_screen.dart';
import 'screens/year_screen.dart';
import 'screens/subjects_screen.dart';
import 'screens/sub_resources_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          home: FutureBuilder<bool>(
            future: AppwriteAuthService().isLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              if (snapshot.hasData && snapshot.data == true) {
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
            '/engineeringHub': (context) => EngineeringHubScreen(),
            '/calculator': (context) => CalculatorScreen(),
            //'/coding': (context) => CodingAssistantScreen(),
            '/ocr': (context) => OCRScreen(),
            '/planner': (context) => StudyPlannerScreen(),
            '/reminder': (context) => ReminderScreen(),
            '/branch': (context) => BranchScreen(),
            '/year': (context) => YearScreen(),
            '/subjects': (context) => SubjectsScreen(),
            '/resources': (context) => ResourcesScreen(),
          },
        );
      },
    );
  }
}
