import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🌙 1. DETECT DARK MODE
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🌙 2. DEFINE ADAPTIVE COLORS
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey[600];
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final iconColor = isDark ? Colors.white : Colors.black54;

    // Dummy Data for History
    final List<Map<String, dynamic>> historyItems = [
      {
        "title": "Flutter Project Ideas",
        "date": "Today, 10:30 AM",
        "type": "chat",
      },
      {
        "title": "Weather in Pune",
        "date": "Yesterday",
        "type": "voice",
      },
      {
        "title": "Recipe for Pasta",
        "date": "Feb 8",
        "type": "chat",
      },
      {
        "title": "Explain Quantum Physics",
        "date": "Feb 5",
        "type": "voice",
      },
      {
        "title": "Email Draft for Boss",
        "date": "Jan 28",
        "type": "chat",
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "History",
          style: TextStyle(
            color: textColor, // ✅ Adaptive
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: iconColor), // ✅ Adaptive
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 🌙 3. ADAPTIVE BACKGROUND
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
          child: Column(
            children: [
              const SizedBox(height: 10),

              // 🌙 4. ADAPTIVE SEARCH BAR
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white.withOpacity(0.9), // ✅ Adaptive
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  style: TextStyle(color: textColor), // ✅ Typing Color
                  decoration: InputDecoration(
                    hintText: "Search history...",
                    hintStyle: TextStyle(color: isDark ? Colors.grey : Colors.black54),
                    border: InputBorder.none,
                    icon: const Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // History List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: historyItems.length,
                  itemBuilder: (context, index) {
                    final item = historyItems[index];
                    return _buildHistoryCard(
                      title: item['title'],
                      date: item['date'],
                      type: item['type'],
                      isDark: isDark,          // Pass Theme State
                      cardColor: cardColor,    // Pass Colors
                      textColor: textColor,
                      subTextColor: subTextColor!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widget for History Cards ---
  Widget _buildHistoryCard({
    required String title,
    required String date,
    required String type,
    required bool isDark,
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    bool isVoice = type == 'voice';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: cardColor, // ✅ Adaptive Background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            // ✅ Adaptive Icon Background (Darker in Dark Mode)
            color: isVoice
                ? (isDark ? Colors.blue.withOpacity(0.2) : const Color(0xFFE1F5FE))
                : (isDark ? const Color(0xFF26C6DA).withOpacity(0.2) : const Color(0xFFE0F2F1)),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isVoice ? Icons.mic : Icons.chat_bubble_outline,
            color: isVoice ? Colors.blue : const Color(0xFF26C6DA),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textColor, // ✅ Adaptive Text
          ),
        ),
        subtitle: Text(
          date,
          style: TextStyle(color: subTextColor, fontSize: 13), // ✅ Adaptive Subtext
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // Navigate to chat detail
        },
      ),
    );
  }
}