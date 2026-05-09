import 'package:flutter/material.dart';
import 'dart:ui';

import 'authentication/login.dart'; 
import 'authentication/signup.dart';
//main
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Georgia'),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
 
  bool _showTip = false; 
  int _tipIndex = 0;

  final List<String> _tips = [
    "Keep onions away from potatoes to prevent sprouting!",
    "Store flour in the freezer to keep it fresh for years.",
    "Put an apple with your potatoes to keep them from budding.",
    "Honey never expires! No need to toss it out.",
  ];

  void _handleHandClick() {
    setState(() {
      if (!_showTip) {
        _showTip = true; 
      } else {
        _tipIndex = (_tipIndex + 1) % _tips.length; 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2D6A4F);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/p2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  
                  Icon(Icons.eco_rounded, color: primaryGreen, size: 50),
                  const SizedBox(height: 10),
                  const Text(
                    "PantryPal",
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: primaryGreen,
                      letterSpacing: 2,
                    ),
                  ),
                  const Text(
                    "ELEVATE YOUR KITCHEN",
                    style: TextStyle(
                      fontSize: 10, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.black54, 
                      letterSpacing: 5,
                    ),
                  ),

                  const Spacer(flex: 1), 

                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        _buildFeatureRow(Icons.timer_outlined, "Track Expiration Dates"),
                        const SizedBox(height: 12),
                        _buildFeatureRow(Icons.receipt_long_outlined, "Smart Recipe Discovery"),
                        const SizedBox(height: 12),
                        _buildFeatureRow(Icons.analytics_outlined, "Reduce Food Waste"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40), 

                  // --- BUTTONS & HAND AREA (NUDGED RIGHT) ---
                  Padding(
                    padding: const EdgeInsets.only(left: 90), 
                    child: Stack(
                      clipBehavior: Clip.none, 
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [
                            _buildPillButton(
                              label: "LOG IN",
                              isPrimary: true,
                              color: primaryGreen,
                              // Navigates to Login page
                              onPressed: () => Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const Login())
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildPillButton(
                              label: "SIGN UP",
                              isPrimary: false,
                              color: primaryGreen,
                              // Navigates to Signup page
                              onPressed: () => Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const Signup())
                              ),
                            ),
                            const SizedBox(width: 15),
                            
                            GestureDetector(
                              onTap: _handleHandClick,
                              child: _buildBouncingHand(primaryGreen),
                            ),
                          ],
                        ),

                        
                        if (_showTip)
                          Positioned(
                            bottom: 55, 
                            left: 285, 
                            child: _buildMessageBubble(_tips[_tipIndex], primaryGreen),
                          ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2), 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBouncingHand(Color color) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: -10),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutSine,
      builder: (context, double offset, child) {
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      onEnd: () => setState(() {}),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.touch_app, color: color, size: 28),
          const Text(
            "Click for tips",
            style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String tip, Color color) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double val, child) {
        return Opacity(
          opacity: val,
          child: Transform.scale(
            scale: val,
            alignment: Alignment.bottomLeft, 
            child: Container(
              constraints: const BoxConstraints(maxWidth: 140),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(2), 
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Text(
                tip,
                style: const TextStyle(fontSize: 9, color: Colors.black87, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF2D6A4F), size: 18),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildPillButton({
    required String label,
    required bool isPrimary,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 90,
      height: 38,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? color : Colors.white.withOpacity(0.4),
          foregroundColor: isPrimary ? Colors.white : color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: color, width: 1.2),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}