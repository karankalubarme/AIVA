import 'package:flutter/material.dart';

class EngineeringHubScreen extends StatelessWidget {
  const EngineeringHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : Colors.black87;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final iconBgColor =
    isDark ? const Color(0xFF333333) : const Color(0xFFE0F7FA);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Engineering Hub"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity, // ✅ FULL HEIGHT
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121212) : null,
          gradient: isDark
              ? null
              : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F7FA),
              Color(0xFFB2EBF2),
              Color(0xFF80DEEA),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight, // ✅ FILL SCREEN
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // 🔹 TOOLS
                        Text(
                          "Tools",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),

                        const SizedBox(height: 15),

                        // 🔹 GRID
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1,
                          shrinkWrap: true,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          children: [
                            _buildCard(
                                context,
                                Icons.calculate,
                                "Calculator",
                                '/calculator',
                                cardColor,
                                textColor,
                                iconBgColor,
                                isDark),
                            _buildCard(
                                context,
                                Icons.document_scanner,
                                "OCR Scanner",
                                '/ocr',
                                cardColor,
                                textColor,
                                iconBgColor,
                                isDark),
                            _buildCard(
                                context,
                                Icons.calendar_month,
                                "Study Planner",
                                '/planner',
                                cardColor,
                                textColor,
                                iconBgColor,
                                isDark),
                            _buildCard(
                                context,
                                Icons.alarm,
                                "Reminder",
                                '/reminder',
                                cardColor,
                                textColor,
                                iconBgColor,
                                isDark),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 🔹 STUDY MATERIAL
                        Text(
                          "Study Material",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),

                        const SizedBox(height: 15),

                        _buildBigButton(
                          context,
                          "Select Engineering Branch",
                          Icons.account_tree,
                          '/branch',
                          cardColor,
                          textColor,
                          iconBgColor,
                          isDark,
                        ),

                        const SizedBox(height: 20),

                        // ✅ THIS PUSHES CONTENT & REMOVES WHITE SPACE
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // 🔹 CARD
  Widget _buildCard(
      BuildContext context,
      IconData icon,
      String title,
      String route,
      Color cardColor,
      Color textColor,
      Color iconBgColor,
      bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon,
                  size: 30, color: const Color(0xFF00ACC1)),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor)),
          ],
        ),
      ),
    );
  }

  // 🔹 BIG BUTTON
  Widget _buildBigButton(
      BuildContext context,
      String title,
      IconData icon,
      String route,
      Color cardColor,
      Color textColor,
      Color iconBgColor,
      bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  size: 26, color: const Color(0xFF00ACC1)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16)
          ],
        ),
      ),
    );
  }
}