import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ Required for launching email

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  // --- EMAIL LAUNCH LOGIC ---
  Future<void> _launchEmailSupport(BuildContext context) async {
    // Customize your support email and default subject here
    const String supportEmail = 'support@aiva-app.com';
    const String subject = 'AIVA Support Request';
    const String body = 'Hello AIVA Support Team,\n\nI need help with...';

    // Encode the URL to handle spaces and special characters properly
    final String query = [
      'subject=${Uri.encodeComponent(subject)}',
      'body=${Uri.encodeComponent(body)}',
    ].join('&');

    final Uri emailUri = Uri.parse('mailto:$supportEmail?$query');

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'Could not launch email app.';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No email app found. Please email support@aiva-app.com directly."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

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
          'Help Center',
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
          _buildFaqCard(
            context,
            'How do I use Voice Activation?',
            'Tap the microphone icon on the dashboard and speak clearly. AIVA will automatically transcribe and process your request.',
          ),
          _buildFaqCard(
            context,
            'How do I change my password?',
            'Go to Settings > Change Password. You will need to enter your current password to set a new one.',
          ),
          _buildFaqCard(
            context,
            'Is my data private?',
            'Yes. We use Firebase Authentication and secure databases to ensure your conversation history remains completely private.',
          ),

          const SizedBox(height: 32),

          // --- CONTACT SUPPORT BUTTON ---
          ElevatedButton.icon(
            onPressed: () => _launchEmailSupport(context),
            icon: const Icon(Icons.email_outlined),
            label: const Text(
              "Contact Support",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF26C6DA), // AIVA Cyan
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 4,
              shadowColor: const Color(0xFF26C6DA).withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              "Average response time: 24 hours",
              style: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- FAQ CARD WIDGET ---
  Widget _buildFaqCard(BuildContext context, String question, String answer) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        // This removes the default divider lines in ExpansionTile
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: const Color(0xFF26C6DA),
          collapsedIconColor: isDark ? Colors.grey[400] : Colors.grey[600],
          title: Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Text(
                answer,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}