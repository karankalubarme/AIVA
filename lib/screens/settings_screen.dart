import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme_manager.dart';

// ✅ Imported All Support Screens
import 'help_center_screen.dart';
import 'privacy_policy_screen.dart';
import 'about_aiva_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables
  bool _notificationsEnabled = true;
  String _selectedLanguage = "English";

  final List<String> _languages = [
    "English", "Hindi", "Spanish", "French",
    "German", "Chinese", "Japanese", "Russian"
  ];

  // --- 1. LOGOUT LOGIC ---
  void _handleLogout() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text("Log Out", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        content: Text("Are you sure you want to log out?", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  // --- 2. LANGUAGE SELECTION LOGIC ---
  void _showLanguageSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Language",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _languages.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey.withOpacity(0.2)),
                  itemBuilder: (context, index) {
                    final lang = _languages[index];
                    final isSelected = lang == _selectedLanguage;

                    return ListTile(
                      title: Text(
                        lang,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? const Color(0xFF26C6DA) : textColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Color(0xFF26C6DA))
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedLanguage = lang;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- 3. CHANGE PASSWORD LOGIC ---
  void _showChangePasswordDialog() {
    final TextEditingController currentPassController = TextEditingController();
    final TextEditingController newPassController = TextEditingController();
    final TextEditingController confirmPassController = TextEditingController();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: dialogBgColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Change Password",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 20),
                _buildAestheticTextField(currentPassController, "Current Password", isDark),
                const SizedBox(height: 15),
                _buildAestheticTextField(newPassController, "New Password", isDark),
                const SizedBox(height: 15),
                _buildAestheticTextField(confirmPassController, "Confirm New Password", isDark),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (currentPassController.text.isEmpty || newPassController.text.isEmpty || confirmPassController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all fields!"), backgroundColor: Colors.red));
                            return;
                          }

                          if (newPassController.text != confirmPassController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("New passwords do not match!"), backgroundColor: Colors.red));
                            return;
                          }

                          if (newPassController.text.length < 6) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password must be 6+ chars"), backgroundColor: Colors.red));
                            return;
                          }

                          try {
                            User? user = FirebaseAuth.instance.currentUser;
                            String email = user?.email ?? "";

                            AuthCredential credential = EmailAuthProvider.credential(
                              email: email,
                              password: currentPassController.text,
                            );

                            await user?.reauthenticateWithCredential(credential);
                            await user?.updatePassword(newPassController.text);

                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password Changed Successfully!"), backgroundColor: Colors.green));
                            }
                          } on FirebaseAuthException catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.message}"), backgroundColor: Colors.red));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF26C6DA),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Update", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Settings",
            style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? null
              : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFF5F5F5)],
          ),
          color: isDarkMode ? const Color(0xFF121212) : null,
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          children: [
            const Text("ACCOUNT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 10),

            _buildSettingsTile(
              context,
              icon: Icons.person_outline,
              title: "Edit Profile",
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.lock_outline,
              title: "Change Password",
              onTap: _showChangePasswordDialog,
            ),

            const SizedBox(height: 20),
            const Text("GENERAL", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 10),

            _buildSwitchTile(
              context,
              icon: Icons.notifications_none,
              title: "Notifications",
              value: _notificationsEnabled,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),

            _buildSwitchTile(
              context,
              icon: Icons.dark_mode_outlined,
              title: "Dark Mode",
              value: isDarkMode,
              onChanged: (val) {
                ThemeManager.toggleTheme(val);
              },
            ),

            _buildSettingsTile(
              context,
              icon: Icons.language,
              title: "Language",
              trailingText: _selectedLanguage,
              onTap: _showLanguageSelector,
            ),

            const SizedBox(height: 20),
            const Text("SUPPORT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 10),

            // ✅ Connected Help Center
            _buildSettingsTile(
                context,
                icon: Icons.help_outline,
                title: "Help Center",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpCenterScreen())
                  );
                }
            ),

            // ✅ Connected Privacy Policy
            _buildSettingsTile(
                context,
                icon: Icons.privacy_tip_outlined,
                title: "Privacy Policy",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen())
                  );
                }
            ),

            // ✅ Connected About AIVA
            _buildSettingsTile(
                context,
                icon: Icons.info_outline,
                title: "About AIVA",
                trailingText: "v1.0.0",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutAivaScreen())
                  );
                }
            ),

            const SizedBox(height: 30),
            Center(
              child: TextButton(
                onPressed: _handleLogout,
                child: const Text("Log Out", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildAestheticTextField(TextEditingController controller, String label, bool isDark) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF26C6DA)),
        ),
        filled: true,
        fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 5, offset: const Offset(0, 2)
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: isDark ? Colors.black : const Color(0xFFE0F7FA).withOpacity(0.5),
              shape: BoxShape.circle
          ),
          child: Icon(icon, color: const Color(0xFF26C6DA), size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black)),
        trailing: trailingText != null
            ? Row(mainAxisSize: MainAxisSize.min, children: [Text(trailingText, style: const TextStyle(color: Colors.grey)), const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)])
            : const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile(BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 5, offset: const Offset(0, 2)
          ),
        ],
      ),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: isDark ? Colors.black : const Color(0xFFE0F7FA).withOpacity(0.5),
              shape: BoxShape.circle
          ),
          child: Icon(icon, color: const Color(0xFF26C6DA), size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black)),
        value: value,
        activeColor: const Color(0xFF26C6DA),
        onChanged: onChanged,
      ),
    );
  }
}