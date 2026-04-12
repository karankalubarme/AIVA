import 'package:flutter/material.dart';

class AboutAivaScreen extends StatelessWidget {
  const AboutAivaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Adapt colors based on current theme (Dark/Light mode)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFE0F7FA);
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'About AIVA',
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
          // --- HEADER: LOGO & VERSION ---
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.memory, // Represents AI/Tech
                    size: 60,
                    color: Color(0xFF26C6DA), // AIVA Cyan
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "AIVA",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4.0,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Smart Voice Assistance",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF26C6DA),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Version 1.0.0",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: subTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // --- DESCRIPTION ---
          Container(
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
            child: Text(
              "AIVA is an intelligent, cross-platform voice assistant designed to make your daily tasks effortless. By combining advanced speech recognition with cutting-edge conversational AI, AIVA learns from your preferences to serve you better every day.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: subTextColor,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // --- TECH STACK / POWERED BY ---
          Text(
            "POWERED BY",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),

          _buildTechTile(context, Icons.auto_awesome, "Google Gemini Pro", "Advanced Conversational AI", isDark),
          _buildTechTile(context, Icons.flutter_dash, "Flutter", "Cross-Platform UI Framework", isDark),
          _buildTechTile(context, Icons.cloud_done_outlined, "Appwrite", "Secure Authentication & Database", isDark),

          const SizedBox(height: 30),

          // --- ACTION BUTTONS ---
          ElevatedButton(
            onPressed: () {
              // Flutter's built-in license page!
              showLicensePage(
                context: context,
                applicationName: "AIVA",
                applicationVersion: "1.0.0",
                applicationIcon: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.memory, color: Color(0xFF26C6DA), size: 40),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              foregroundColor: textColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "View Open Source Licenses",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 30),

          // --- COPYRIGHT FOOTER ---
          Center(
            child: Text(
              "© 2026 AIVA Systems. All rights reserved.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- HELPER WIDGET FOR TECH TILES ---
  Widget _buildTechTile(BuildContext context, IconData icon, String title, String subtitle, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.black : const Color(0xFFE0F7FA).withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF26C6DA), size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 12),
        ),
      ),
    );
  }
}