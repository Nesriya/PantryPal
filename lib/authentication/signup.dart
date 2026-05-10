import 'package:flutter/material.dart';
import '../user_data.dart';
import '../screens/addItem.dart';
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/p1.jpg', fit: BoxFit.cover)),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.5))),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                SizedBox(
                  width: 280,
                 child: _buildSignupField(
                  Icons.email_outlined,
                 "Email",
                    controller: emailController,
                 ),
                ),
                  const SizedBox(height: 15),
                 SizedBox(
  width: 280,
  child: _buildSignupField(
    Icons.lock_outline,
    "Password",
    isPassword: true,
    controller: passwordController,
  ),
),
                  const SizedBox(height: 40),
                 Align(
  alignment: Alignment.center,
  child: SizedBox(
    width: 210,
    height: 50,
    child: ElevatedButton(
                     onPressed: () {
  if (emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty) {

    final user = {
      "email": emailController.text.trim().toLowerCase(),
      "password": passwordController.text,
    };

    UserDatabase.registeredUsers.add(user);

    // ✅ set session email
   UserDatabase.registeredUsers.add({
  "email": emailController.text.trim().toLowerCase(),
  "password": passwordController.text,
});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account created!")),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddItem()),
    );
  }
},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 6, 94, 51),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                      ),
                      child: const Text("SIGN UP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
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

  Widget _buildSignupField(IconData icon, String hint, {bool isPassword = false, TextEditingController? controller}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white24)),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.white70),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }
}