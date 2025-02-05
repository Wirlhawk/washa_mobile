import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washa_mobile/auth/auth_service.dart';
import 'package:washa_mobile/data/style.dart';
import 'package:washa_mobile/views/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();

  void login() async {
    final email = _emailController.text;
    final password = _pwController.text;

    try {
      await _authService.signInWithEmailPassword(email, password);
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
            child: _buildLoginForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        // Header title
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Login",
              style: GoogleFonts.lexend(
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              "Masuk ke akun AnonFess anda",
              style: GoogleFonts.lexend(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Style.muted,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),

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

        // Login button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: login,
            child: Text("Login", style: GoogleFonts.lexend(fontSize: 16)),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Belum punya akun? ", style: GoogleFonts.lexend()),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text(
                "Register",
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
