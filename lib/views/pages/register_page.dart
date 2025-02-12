import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washa_mobile/auth/auth_service.dart';
import 'package:washa_mobile/data/style.dart';
import 'package:washa_mobile/views/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _authService = AuthService();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();

  void register() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _pwController.text;

    try {
      await _authService.signUpwithEmailPassword(username, email, password);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Register Success, Go To Login Page")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e ")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _buildRegisterForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header title
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Register",
              style: GoogleFonts.lexend(
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              "Buat akun AnonFess anda",
              style: GoogleFonts.lexend(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Style.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Username input
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: "Username",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),

        // Email input
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 15),

        // Password input
        TextField(
          controller: _pwController,
          decoration: InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),

        // Register button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: register,
            child: Text("Register", style: GoogleFonts.lexend(fontSize: 16)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sudah punya akun? ", style: GoogleFonts.lexend()),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                "Login",
                style: GoogleFonts.lexend(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
