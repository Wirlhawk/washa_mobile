import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washa_mobile/data/style.dart';

class AppbarTitle extends StatelessWidget {
  final String text;
  final double? fontSize;
  const AppbarTitle(this.text, {super.key, this.fontSize = 20});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        color: Style.primary,
      ),
    );
  }
}
