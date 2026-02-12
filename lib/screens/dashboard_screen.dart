import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; // For Bottom Navigation

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigation Logic for Bottom Bar
    switch (index) {
      case 0:
      // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, '/mic');
        break;
      case 2:
        Navigator.pushNamed(context, '/history');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🌙 1. CHECK FOR DARK MODE
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🌙 2. DEFINE ADAPTIVE COLORS
    final textColor = isDark ? Colors.white : Colors.black87;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final iconBgColor = isDark ? const Color(0xFF333333) : const Color(0xFFE0F7FA);

    return Scaffold(
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 🌙 3. ADAPTIVE BACKGROUND (Gradient for Light, Solid Dark for Dark)
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121212) : null,
          gradient: isDark
              ? null
              : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F7FA), // Very Light Cyan
              Color(0xFFB2EBF2), // Light Cyan
              Color(0xFF80DEEA), // Cyan
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo
                Image.asset(
                  'assets/images/logo1.png',
                  height: 80,
                ),
                const SizedBox(height: 10),
                Text(
                  "AIVA",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: textColor, // ✅ Adaptive Text Color
                  ),
                ),

                const SizedBox(height: 40),

                // Welcome Text
                const Text(
                  "Welcome, User!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF26C6DA), // Keep Cyan branding
                  ),
                ),

                const SizedBox(height: 50),

                // 🌙 4. UPDATED BUTTONS (Pass colors)
                _buildDashboardButton(
                  icon: Icons.chat_bubble_outline,
                  text: "Chat with AIVA",
                  cardColor: cardColor,
                  textColor: textColor,
                  iconBgColor: iconBgColor,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pushNamed(context, '/chat');
                  },
                ),

                const SizedBox(height: 25),

                _buildDashboardButton(
                  icon: Icons.settings_outlined,
                  text: "Settings",
                  cardColor: cardColor,
                  textColor: textColor,
                  iconBgColor: iconBgColor,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),

      // 🌙 5. ADAPTIVE BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor, // ✅ Adaptive Background
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: cardColor, // ✅ Adaptive Background
            selectedItemColor: const Color(0xFF26C6DA),
            unselectedItemColor: isDark ? Colors.grey : Colors.grey.withOpacity(0.5),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.mic_none, size: 30), label: 'Voice'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: 'History'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widget for Dashboard Buttons ---
  Widget _buildDashboardButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color cardColor,
    required Color textColor,
    required Color iconBgColor,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: cardColor, // ✅ Adaptive Card Color
          borderRadius: BorderRadius.circular(20),
          // Add border for Dark Mode visibility
          border: Border.all(
              color: isDark ? const Color(0xFF333333) : Colors.white,
              width: 2
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : const Color(0xFF26C6DA).withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor, // ✅ Adaptive Icon Background
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF00ACC1), size: 28),
            ),
            const SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor, // ✅ Adaptive Text Color
              ),
            ),
          ],
        ),
      ),
    );
  }
}