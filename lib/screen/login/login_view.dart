import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milktrack/screen/home/dashborad.dart';

// Login Screen
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // 👇 हर TextField के लिए अलग Controller
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 👇 Logo/Image
              SizedBox(
                height: 110,
                width: 100,
                child: Image.asset("assets/images/img.png"),
              ),
              const SizedBox(height: 5),

              // 👇 Welcome Text
              const Text(
                "Welcome back you’ve",
                style: TextStyle(fontSize: 16, color: Color(0xFF000000)),
              ),
              const Text(
                "been missed!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 50),
              // 👉 Mobile Field
              TextField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Mobile",
                  prefixIcon: const Icon(
                    Icons.mobile_friendly,
                    color: Color(0xFF1F41BB),
                  ),
                  filled:
                      true, // 👈 TextField के अंदर background enable करने के लिए
                  fillColor: const Color(
                    0xFFF1F4FF,
                  ), // 👈 Light blue background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide.none, // 👈 optional, soft background look
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF1F41BB)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 👉 Password Field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF1F41BB)),
                  filled: true, // 👈 background enable
                  fillColor: const Color(
                    0xFFF1F4FF,
                  ), // 👈 light blue background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // 👈 optional, soft look
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF1F41BB)),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 👉 Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF1F41BB,
                    ), // 👈 main button color
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 7, // 👈 shadow depth
                    shadowColor: const Color(0xFFCBD6FF), // 👈 shadow color
                  ),
                  onPressed: () {
                    // Navigate to Home Screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeView()),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAccountScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Create new account",
                    style: TextStyle(color: Color(0xFF494949), fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _loginAdmin() async {
    // ✅ 1. Close keyboard
    FocusScope.of(context).unfocus();

    // ✅ 2. Wait for keyboard to fully close
    await Future.delayed(const Duration(milliseconds: 300));

    final phone = _mobileController.text.trim().replaceAll(' ', '');
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showMessage("Please fill all fields");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final query = await FirebaseFirestore.instance
          .collection('admin')
          .where('phone', isEqualTo: phone)
          .where('password', isEqualTo: password)
          .get();

      if (query.docs.isNotEmpty) {
        // ✅ 3. Optional delay before navigating
        await Future.delayed(const Duration(milliseconds: 100));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      } else {
        _showMessage("Invalid phone or password");
      }
    } catch (e) {
      _showMessage("Error: ${e.toString()}");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // white background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F41BB),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Create an account so you can explore\nall the existing jobs",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF000000)),
              ),
              const SizedBox(height: 50),

              // 👉 Mobile Field
              TextField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Mobile",
                  prefixIcon: const Icon(
                    Icons.mobile_friendly,
                    color: Color(0xFF1F41BB),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF1F4FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF1F41BB)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 👉 Password Field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF1F41BB)),
                  filled: true,
                  fillColor: const Color(0xFFF1F4FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF1F41BB)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 👉 Confirm Password Field
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF1F41BB)),
                  filled: true,
                  fillColor: const Color(0xFFF1F4FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF1F41BB)),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 👉 Signup Button with shadow
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF1F41BB,
                    ), // main button color
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 7, // 👈 shadow depth
                    shadowColor: const Color(0xFFCBD6FF), // 👈 shadow color
                  ),
                  onPressed: () {
                    // TODO: Signup logic
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
