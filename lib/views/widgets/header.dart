import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  final String label;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  const Header(
    this.label, {
    super.key,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w600,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
