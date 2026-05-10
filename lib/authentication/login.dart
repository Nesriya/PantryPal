import 'package:flutter/material.dart';
import '../screens/home.dart';
import 'signup.dart';
import '../user_data.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _handleLogin(BuildContext context, String email, String password) {
    final cleanEmail = email.trim().toLowerCase();

    bool canLogin = UserDatabase.registeredUsers.any(
      (user) => user['email'] == cleanEmail && user['password'] == password,
    );

    if (canLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid credentials or account does not exist."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    const Color primaryGreen = Color(0xFF2D6A4F);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/p1.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          // 🔥 moved whole layout slightly up
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🟢 LOGO
                  Icon(Icons.eco_rounded, color: primaryGreen, size: 60),
                  const SizedBox(height: 10),
                  const Text(
                    "PantryPal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // EMAIL
                  SizedBox(
                    width: 280,
                    child: _buildTextField(
                      Icons.email_outlined,
                      "Email",
                      controller: emailController,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // PASSWORD
                  SizedBox(
                    width: 280,
                    child: _buildTextField(
                      Icons.lock_outline,
                      "Password",
                      isPassword: true,
                      controller: passwordController,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // LOGIN BUTTON
                  SizedBox(
                    width: 220,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => _handleLogin(
                        context,
                        emailController.text,
                        passwordController.text,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    ),
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    String hint, {
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }
}