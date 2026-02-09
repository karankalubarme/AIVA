import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // Optional: Add a timer if you want it to auto-navigate
    // Timer(const Duration(seconds: 4), () {
    //   if (mounted) Navigator.pushReplacementNamed(context, '/login');
    // });
  }

  @override
  Widget build(BuildContext context) {
    // Height and width of the screen
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 1. Soft Light Blue Gradient Background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE0F7FA), // Very light cyan (Top)
              Color(0xFFE1F5FE), // Very light blue
              Color(0xFFB3E5FC), // Light blue (Bottom)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // 2. The Logo (Brain + AIVA)
              // Ensure your file is at 'assets/Images/logo.png'
              Image.asset(
                'assets/images/logo1.png',
                height: 180, // Adjust height based on your logo's actual size
                fit: BoxFit.contain,
              ),

              const Spacer(flex: 1),

              // 3. "WELCOME TO" Text
              Text(
                "WELCOME TO",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2.0,
                  color: Colors.cyan[800]?.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 5),

              // 4. "VIRTUAL" (Big Gradient Text)
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF26C6DA), // Cyan
                    Color(0xFF4DD0E1), // Light Cyan
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: const Text(
                  "VIRTUAL",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900, // Extra Bold
                    color: Colors.white, // Required for ShaderMask
                    letterSpacing: 1.5,
                    height: 1.0,
                  ),
                ),
              ),

              // 5. "REALITY" (Medium Text)
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF26C6DA),
                    Color(0xFF80DEEA),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: const Text(
                  "REALITY",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 4.0,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // 6. "GET STARTED" Button
              GestureDetector(
                onTap: () {
                  // Navigate to Login Page
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Container(
                  width: size.width * 0.5, // 50% of screen width
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    // Button Gradient
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4DD0E1), // Cyan
                        Color(0xFF29B6F6), // Light Blue
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "GET STARTED",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}