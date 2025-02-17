import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washa_mobile/auth/auth_service.dart';
import 'package:washa_mobile/data/style.dart';
import 'package:washa_mobile/views/widgets/header.dart';

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
            Header(
              "Register",
              fontSize: 40,
              color: Style.primary,
            ),
            Header(
              "Create new Washa account",
              fontWeight: FontWeight.normal,
              color: Style.secondaryText,
            ),
          ],
        ),
        const SizedBox(height: 40),

        // Username input
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: "Username",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: EdgeInsets.all(18),
          ),
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 15),

        // Email input
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: EdgeInsets.all(18),
          ),
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 15),
        // Password input
        TextField(
          controller: _pwController,
          decoration: InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: EdgeInsets.all(18),
          ),
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 20),

        // Register button
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
              shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
            ),
            onPressed: register,
            child: Text("Register", style: GoogleFonts.lexend(fontSize: 16)),
          ),
        ),

        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Header(
              "Already have an account?",
              fontSize: 15,
              color: Style.secondaryText,
              fontWeight: FontWeight.w500,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Header(
                "Login",
                color: Style.primary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
