import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Adapt colors based on current theme (Dark/Light mode)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFE0F7FA);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.privacy_tip_outlined,
                    size: 48,
                    color: Color(0xFF26C6DA),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "AIVA Privacy Policy",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Last Updated: February 2026",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Policy Sections
          _buildPolicySection(
            context,
            icon: Icons.mic_none,
            title: "1. Data We Collect",
            content: "We collect information you provide directly to us, including your account details (email, name) and voice inputs when you use the microphone. Voice data is temporarily processed to generate text for the AI.",
          ),
          _buildPolicySection(
            context,
            icon: Icons.analytics_outlined,
            title: "2. How We Use Your Data",
            content: "Your data is used to provide, maintain, and improve the AIVA service. Conversation history is saved securely to your account so you can access it across your devices.",
          ),
          _buildPolicySection(
            context,
            icon: Icons.api_rounded,
            title: "3. Third-Party Services",
            content: "AIVA utilizes Google's Gemini AI to process text and generate responses, and Appwrite for secure authentication and database storage. We do not sell your personal data to third parties.",
          ),
          _buildPolicySection(
            context,
            icon: Icons.security,
            title: "4. Data Security",
            content: "We implement enterprise-grade security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.",
          ),
          _buildPolicySection(
            context,
            icon: Icons.manage_accounts_outlined,
            title: "5. Your Rights",
            content: "You have the right to access, update, or delete your personal information. You can clear your conversation history or delete your account entirely at any time from the app settings.",
          ),

          const SizedBox(height: 30),
          Center(
            child: Text(
              "If you have any questions, please contact our support team via the Help Center.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[500] : Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- HELPER WIDGET FOR POLICY CARDS ---
  Widget _buildPolicySection(BuildContext context, {required IconData icon, required String title, required String content}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF26C6DA), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: subTextColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}