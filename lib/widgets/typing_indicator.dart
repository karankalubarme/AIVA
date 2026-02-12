import 'dart:math'; // Required for sine wave math
import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final Color dotColor;
  final Color backgroundColor;

  const TypingIndicator({
    super.key,
    this.dotColor = const Color(0xFF26C6DA), // Your App's Cyan Color
    this.backgroundColor = Colors.white,     // Bubble Background
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 1. Setup the animation loop
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Speed of the wave
    )..repeat(); // Run forever
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 2. Styling: Matches your other chat bubbles
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(0), // Sharp corner for "incoming" look
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) => _buildDot(index)),
      ),
    );
  }

  Widget _buildDot(int index) {
    // 3. The Animation Logic
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Stagger the animation: 0.0, 0.2, 0.4 delay for each dot
        double delay = index * 0.2;
        double value = (_controller.value + delay) % 1.0;

        // Use Sine wave for smooth bouncing (up and down)
        // Multiplied by 5 to determine how high it jumps
        double offset = sin(value * 2 * pi) * 5;

        return Transform.translate(
          offset: Offset(0, offset), // Moves the dot vertically
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3), // Space between dots
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: widget.dotColor,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}