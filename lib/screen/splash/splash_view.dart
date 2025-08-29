import 'package:flutter/material.dart';
import 'package:milktrack/screen/login/login_view.dart' show LoginView;

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
      const Duration(seconds: 3),
    ); // Simulate loading time
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // top, center, bottom
          children: [
            const SizedBox(), // Top empty space

            // Center Logo
            Center(
              child: Image.asset(
                "assets/images/img.png",
                height: 280, // medium size
                width: 280,
                fit: BoxFit.contain,
              ),
            ),

            // Bottom Text
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: const [
                  Text(
                    "Developed by:",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Ramesh Sachala",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
