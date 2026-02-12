import 'package:flutter/material.dart';

class MicScreen extends StatefulWidget {
  const MicScreen({super.key});

  @override
  State<MicScreen> createState() => _MicScreenState();
}

class _MicScreenState extends State<MicScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Animation for the "Breathing" Ripple Effect
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Runs forever
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _stopListening() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // 🌙 1. DETECT DARK MODE
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🌙 2. DEFINE ADAPTIVE COLORS
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey[700];

    // Logo Tint: Dark Cyan for Light Mode, White/Light Cyan for Dark Mode
    final logoColor = isDark ? Colors.white.withOpacity(0.8) : Colors.cyan.shade800.withOpacity(0.5);

    return Scaffold(
      body: GestureDetector(
        onTap: _stopListening,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          // 🌙 3. ADAPTIVE BACKGROUND
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF121212) : null, // Solid Dark for Dark Mode
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // 🌙 4. ADAPTIVE LOGO
              Hero(
                tag: 'app_logo',
                child: Image.asset(
                  'assets/images/logo1.png',
                  height: 60,
                  color: logoColor, // ✅ Adaptive Tint
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),

              const Spacer(),

              // Animated Microphone
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Ripple Ring 1
                  _buildRipple(scaleFactor: 3.0, opacity: 0.2, isDark: isDark),
                  // Inner Ripple Ring 2
                  _buildRipple(scaleFactor: 2.0, opacity: 0.4, isDark: isDark),

                  // The Main Mic Button
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          // Glowing effect in dark mode
                          color: const Color(0xFF00ACC1).withOpacity(isDark ? 0.6 : 0.4),
                          blurRadius: isDark ? 30 : 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.mic,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // 🌙 5. ADAPTIVE TEXT
              Text(
                "Listening...",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor, // ✅ Adaptive
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Tap anywhere to stop",
                style: TextStyle(
                  fontSize: 16,
                  color: subTextColor, // ✅ Adaptive
                ),
              ),

              const Spacer(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper to build animated ripples ---
  Widget _buildRipple({required double scaleFactor, required double opacity, required bool isDark}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double value = _controller.value;

        // 🌙 Ripple Color: Brighter in Dark Mode for a "Neon" look
        final rippleColor = isDark ? const Color(0xFF80DEEA) : const Color(0xFF26C6DA);

        return Transform.scale(
          scale: 1.0 + (scaleFactor - 1.0) * value,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: rippleColor.withOpacity(opacity * (1 - value)),
                width: 2,
              ),
              color: rippleColor.withOpacity(opacity * 0.5 * (1 - value)),
            ),
          ),
        );
      },
    );
  }
}