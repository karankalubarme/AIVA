import 'package:flutter/material.dart';
import '../../services/auth_service.dart'; // Ensure this path is correct

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers (Simplified - only what is needed)
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isLoading = false; // To show the loading spinner

  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks
    _usernameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  // --- SIGN UP LOGIC ---
  Future<void> _handleSignUp() async {
    // 1. Validate inputs
    String email = _emailController.text.trim();
    String password = _passController.text.trim();
    String username = _usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }

    // 2. Start Loading
    setState(() {
      _isLoading = true;
    });

    // 3. Call Firebase Service
    // We pass 'username' as the 'name' to be saved in Firebase
    String? result = await AuthService().signUpUser(
      email: email,
      password: password,
      name: username,
    );

    // 4. Stop Loading
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    // 5. Handle Result
    if (result == null && mounted) {
      // SUCCESS: Navigate to Dashboard
      // .pushAndRemoveUntil removes the back button so user can't go back to signup
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    } else if (mounted) {
      // FAILURE: Show Error Message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ?? "An unknown error occurred"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 1. Light Blue Gradient Background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  // 2. Logo & App Name
                  Image.asset(
                    'assets/images/logo1.png',
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "AIVA",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 3. "CREATE ACCOUNT" Title
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
                    ).createShader(bounds),
                    child: const Text(
                      "CREATE ACCOUNT",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- FORM FIELDS ---

                  // 4. Username
                  _buildTextField(
                    controller: _usernameController,
                    icon: Icons.person_outline,
                    hintText: "Username",
                  ),
                  const SizedBox(height: 20),

                  // 5. Email Address
                  _buildTextField(
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    hintText: "Email Address",
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // 6. Password
                  _buildTextField(
                    controller: _passController,
                    icon: Icons.lock_outline,
                    hintText: "Password",
                    isPassword: true,
                  ),

                  const SizedBox(height: 40),

                  // 7. SIGN UP BUTTON
                  GestureDetector(
                    onTap: _isLoading ? null : _handleSignUp, // Disable tap while loading
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF26C6DA), // Cyan
                            Color(0xFF29B6F6), // Blue
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        // Show Spinner if loading, otherwise show Text
                        child: _isLoading
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          "SIGN UP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 8. Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Go back to Login
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Color(0xFF0097A7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widget for Text Fields ---
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: inputType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF26C6DA)),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}