import 'package:flutter/material.dart';

class MicScreen extends StatefulWidget {
  final VoidCallback? onStop; // Callback to handle stopping the mic
  const MicScreen({super.key, this.onStop});

  @override
  State<MicScreen> createState() => _MicScreenState();
}

class _MicScreenState extends State<MicScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleStop() {
    if (widget.onStop != null) {
      widget.onStop!(); // Switch back to Home tab
    } else {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey[700];
    final logoColor = isDark ? Colors.white.withOpacity(0.8) : Colors.cyan.shade800.withOpacity(0.5);

    return Scaffold(
      extendBody: true, // Sync background with Dashboard
      backgroundColor: Colors.transparent, // Sync background with Dashboard
      body: GestureDetector(
        onTap: _handleStop,
        child: Container(
          width: double.infinity,
          height: double.infinity,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Hero(
                tag: 'app_logo',
                child: Image.asset(
                  'assets/images/logo1.png',
                  height: 60,
                  color: logoColor,
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  _buildRipple(scaleFactor: 3.0, opacity: 0.2, isDark: isDark),
                  _buildRipple(scaleFactor: 2.0, opacity: 0.4, isDark: isDark),
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
              Text(
                "Listening...",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Tap anywhere to stop",
                style: TextStyle(
                  fontSize: 16,
                  color: subTextColor,
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

  Widget _buildRipple({required double scaleFactor, required double opacity, required bool isDark}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double value = _controller.value;
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
