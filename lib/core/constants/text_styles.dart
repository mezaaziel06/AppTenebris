import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextStyle title = GoogleFonts.cinzelDecorative(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 2.0,
  );

  static final TextStyle subtitle = GoogleFonts.cinzelDecorative(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Colors.redAccent,
  );

  static final TextStyle body = GoogleFonts.cinzelDecorative(
    fontSize: 16,
    color: Colors.white70,
  );
}
