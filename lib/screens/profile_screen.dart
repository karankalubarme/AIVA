import 'package:flutter/material.dart';
import '../services/appwrite_auth_service.dart';
import 'package:appwrite/models.dart' as models;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  models.User? _currentUser;
  bool _isLoading = true;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authService = AppwriteAuthService();
    final user = await authService.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
        _isLoading = false;
        if (user != null && user.prefs.data.containsKey('profile_id')) {
          _profileImageUrl = authService.getProfileImageUrl(user.prefs.data['profile_id']);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🌙 1. DETECT DARK MODE
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🌙 2. DEFINE ADAPTIVE COLORS
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey[700];
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final iconColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 🌙 3. ADAPTIVE BACKGROUND
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121212) : null, // Solid Dark
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
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: iconColor), // ✅ Adaptive
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor, // ✅ Adaptive
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40), // Balance the row
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Avatar
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: isDark ? const Color(0xFF333333) : Colors.white,
                            width: 4
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white, // ✅ Adaptive
                      ),
                      child: ClipOval(
                        child: _profileImageUrl != null
                            ? Image.network(
                                _profileImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.person, size: 60, color: Colors.grey),
                              )
                            : const Icon(Icons.person, size: 60, color: Colors.grey),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white : Colors.black87, // ✅ Inverted for visibility
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                          Icons.camera_alt,
                          color: isDark ? Colors.black : Colors.white,
                          size: 20
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // User Info
                Text(
                  _currentUser?.name ?? "Guest User",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: textColor, // ✅ Adaptive
                  ),
                ),
                Text(
                  _currentUser?.email ?? "no-email@example.com",
                  style: TextStyle(
                    fontSize: 16,
                    color: subTextColor, // ✅ Adaptive
                  ),
                ),

                const SizedBox(height: 40),

                // Options List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      _buildProfileOption(
                        icon: Icons.edit,
                        text: "Edit Profile",
                        isDark: isDark,
                        cardColor: cardColor,
                        textColor: textColor,
                        onTap: () async {
                          final result = await Navigator.pushNamed(context, '/edit-profile');
                          if (result == true) {
                            _loadUserData();
                          }
                        },
                      ),
                      const SizedBox(height: 15),

                      _buildProfileOption(
                        icon: Icons.settings,
                        text: "Settings",
                        isDark: isDark,
                        cardColor: cardColor,
                        textColor: textColor,
                        onTap: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),

                      const SizedBox(height: 15),
                      _buildProfileOption(
                        icon: Icons.help_outline,
                        text: "Help & Support",
                        isDark: isDark,
                        cardColor: cardColor,
                        textColor: textColor,
                        onTap: () {},
                      ),
                      const SizedBox(height: 40),

                      // Log Out Button
                      GestureDetector(
                        onTap: () async {
                          await AppwriteAuthService().signOut();
                          if (mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: cardColor, // ✅ Adaptive
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withOpacity(0.3)
                                    : Colors.red.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Log Out",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widget for Options ---
  Widget _buildProfileOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required bool isDark,
    required Color cardColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: cardColor, // ✅ Adaptive Background
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor), // ✅ Adaptive Icon
            const SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: textColor, // ✅ Adaptive Text
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}