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

    // Navigation Logic
    if (index == 1) {
      // Mic/Chat Button
      Navigator.pushNamed(context, '/chat');
    } else if (index == 2) {
      // History Button (New)
      // You can add navigation to a history screen here later
      print("History tapped");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 1. Background Gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
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

                // 2. Logo & Branding
                Image.asset(
                  'assets/images/logo1.png',
                  height: 80,
                ),
                const SizedBox(height: 10),
                const Text(
                  "AIVA",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 40),

                // 3. Welcome Text
                const Text(
                  "Welcome, User!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF26C6DA),
                  ),
                ),

                const SizedBox(height: 50),

                // 4. Main Buttons
                _buildDashboardButton(
                  icon: Icons.chat_bubble_outline,
                  text: "Chat with AIVA",
                  onTap: () {
                    Navigator.pushNamed(context, '/chat');
                  },
                ),

                const SizedBox(height: 25),

                _buildDashboardButton(
                  icon: Icons.settings_outlined,
                  text: "Settings",
                  onTap: () {},
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),

      // 5. Updated Bottom Navigation Bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF26C6DA), // Active Color
            unselectedItemColor: Colors.grey.withOpacity(0.5), // Inactive Color
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed, // Important for 4 icons
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              // 0. Home
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Home'
              ),
              // 1. Chat (Mic)
              BottomNavigationBarItem(
                  icon: Icon(Icons.mic_none, size: 30),
                  label: 'Chat'
              ),
              // 2. History (New Icon Added Here)
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), // The History Clock Icon
                  label: 'History'
              ),
              // 3. Profile
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile'
              ),
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF26C6DA).withOpacity(0.15),
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
                color: const Color(0xFFE0F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF00ACC1), size: 28),
            ),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}