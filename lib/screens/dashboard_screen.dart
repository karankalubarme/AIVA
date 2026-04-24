import 'package:flutter/material.dart';
import '../services/appwrite_auth_service.dart';
import 'engineering_hub_screen.dart';
import 'chat/chat_screen.dart'; // Assuming these exist based on context
import 'profile_screen.dart';
import 'history_screen.dart';
import 'mic_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String _userName = "User";
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authService = AppwriteAuthService();
    final user = await authService.getCurrentUser();
    if (user != null) {
      setState(() {
        _userName = user.name;
        if (user.prefs.data.containsKey('profile_id')) {
          _profileImageUrl = authService.getProfileImageUrl(user.prefs.data['profile_id']);
        }
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Using IndexedStack to maintain state and avoid navigation stack bugs
    return Scaffold(
      extendBody: true, // Allows content to flow behind the bottom nav bar
      backgroundColor: Colors.transparent, 
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeHome(context, isDark),
          MicScreen(onStop: () => _onItemTapped(0)), // Pass callback to switch back
          const HistoryScreen(),
          const ProfileScreen(),
        ],
      ),
      // ✅ Automatically hide nav bar when Mic tab is active (index 1)
      bottomNavigationBar: _selectedIndex == 1 ? null : _buildBottomNav(isDark),
    );
  }

  Widget _buildHomeHome(BuildContext context, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121212) : Colors.white,
        gradient: isDark
            ? null
            : const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFE0F7FA),
                  Colors.white,
                  Color(0xFFF5F9FA),
                ],
              ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(textColor, subTextColor),
              const SizedBox(height: 30),
              _buildHeroCard(context),
              const SizedBox(height: 40),
              Text(
                "Quick Actions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 20),
              _buildActionCard(
                icon: Icons.engineering,
                title: "Engineering Tools",
                subtitle: "Tools & Study Material",
                color: const Color(0xFFE0F7FA),
                iconColor: const Color(0xFF00ACC1),
                onTap: () => Navigator.pushNamed(context, '/engineeringHub'),
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                icon: Icons.chat_bubble,
                title: "Chat with AIVA",
                subtitle: "Start a new conversation",
                color: const Color(0xFFE0F2F1),
                iconColor: const Color(0xFF00897B),
                onTap: () => Navigator.pushNamed(context, '/chat'),
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                icon: Icons.settings,
                title: "Settings",
                subtitle: "Preferences & Security",
                color: const Color(0xFFE8EAF6),
                iconColor: const Color(0xFF3F51B5),
                onTap: () => Navigator.pushNamed(context, '/settings'),
                isDark: isDark,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor, Color? subTextColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello,", style: TextStyle(fontSize: 16, color: subTextColor)),
            Text(_userName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
          ],
        ),
        GestureDetector(
          onTap: () async {
            final result = await Navigator.pushNamed(context, '/profile');
            if (result == true) _loadUserData();
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7FA),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              backgroundImage: _profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null,
              child: _profileImageUrl == null 
                ? const Icon(Icons.person_outline, color: Color(0xFF00ACC1), size: 28)
                : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00ACC1), Color(0xFF007191)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "How can I help\nyou today?",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/chat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF00ACC1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("Ask AIVA", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? color.withOpacity(0.1) : color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      height: 65, // Balanced height for perfect centering
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30), // Increased bottom margin to float higher
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home_rounded, isDark),
          _buildNavItem(1, Icons.mic_none_rounded, isDark),
          _buildNavItem(2, Icons.history_rounded, isDark),
          _buildNavItem(3, Icons.person_outline_rounded, isDark),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, bool isDark) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Center(
          child: Icon(
            icon,
            size: 28,
            color: isSelected ? const Color(0xFF00ACC1) : Colors.grey[400],
          ),
        ),
      ),
    );
  }
}
