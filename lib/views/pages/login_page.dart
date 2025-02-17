import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washa_mobile/auth/auth_service.dart';
import 'package:washa_mobile/data/style.dart';
import 'package:washa_mobile/views/pages/register_page.dart';
import 'package:washa_mobile/views/widgets/header.dart';

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
      backgroundColor: Colors.white,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              "Login",
              fontSize: 40,
              color: Style.primary,
            ),
            Header(
              "Login to your Washa account",
              fontWeight: FontWeight.normal,
              color: Style.secondaryText,
            ),
          ],
        ),

        const SizedBox(height: 40),

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
          obscureText: true,
        ),

        const SizedBox(height: 20),

        // Login button
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
              shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
            ),
            onPressed: login,
            child: Text("Login", style: GoogleFonts.lexend(fontSize: 16)),
          ),
        ),

        // SizedBox(
        //   width: double.infinity,
        //   child: ElevatedButton(
        //     onPressed: login,
        //     child: Text("Login", style: GoogleFonts.lexend(fontSize: 16)),
        //   ),
        // ),

        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Header(
              "Don't have an account? ",
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
                "Register",
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
