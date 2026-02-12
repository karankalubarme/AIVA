import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aiva/services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Initialize the Gemini Service
  final GeminiService _geminiService = GeminiService();

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'message': 'Hello! I am AIVA. How can I help you today?',
    },
  ];

  bool _isTyping = false;

  void _sendMessage() async {
    final String userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'isUser': true, 'message': userMessage});
      _isTyping = true;
      _messageController.clear();
    });

    _scrollToBottom();

    // Get Response from Gemini AI
    String? aiResponse = await _geminiService.sendMessage(userMessage);

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add({
          'isUser': false,
          'message': aiResponse ?? "Sorry, I am having trouble connecting.",
        });
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🌙 1. DETECT DARK MODE
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Define adaptive colors
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconColor = isDark ? Colors.white70 : Colors.black54;
    final inputBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      body: Container(
        // 🌙 2. ADAPTIVE BACKGROUND
        // Use Gradient for Light Mode, Solid Dark Grey for Dark Mode
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121212) : null,
          gradient: isDark
              ? null
              : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2), Color(0xFF80DEEA)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: iconColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "AIVA Chat",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor // ✅ Adaptive Text
                      ),
                    ),
                  ],
                ),
              ),

              // Chat List
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length && _isTyping) {
                      return const _TypingIndicator();
                    }
                    final msg = _messages[index];
                    return _ChatBubble(
                      message: msg['message'],
                      isUser: msg['isUser'],
                    );
                  },
                ),
              ),

              // Input Area
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: inputBgColor, // ✅ Adaptive Input Background
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), // Darker shadow in dark mode
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: textColor), // ✅ User typing color
                        decoration: InputDecoration(
                          hintText: "Ask me anything...",
                          hintStyle: TextStyle(color: isDark ? Colors.grey : Colors.black54),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF26C6DA),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white, size: 20),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- HELPER WIDGETS ---

class _ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const _ChatBubble({required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    // 🌙 Check Theme inside the bubble
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // AI Bubble Color: White (Light) vs Dark Grey (Dark)
    // User Bubble Color: Always Cyan (looks good in both)
    final bubbleColor = isUser
        ? const Color(0xFF26C6DA)
        : (isDark ? const Color(0xFF1E1E1E) : Colors.white);

    // Text Color: White (User) vs Adaptive (AI)
    final textColor = isUser
        ? Colors.white
        : (isDark ? Colors.white : Colors.black87);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: bubbleColor, // ✅ Adaptive Color
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(
            color: textColor, // ✅ Adaptive Text
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white, // ✅ Adaptive
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          "AIVA is thinking...",
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}