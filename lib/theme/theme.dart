import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    fontFamily: 'Open Sans Regular',

    // Global Color Scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1BBDB8), // ocean teal
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white.withOpacity(0.55), // glass effect
      elevation: 15,
      selectedIconTheme: const IconThemeData(
        size: 30,
        color: Color(0xFF0A9D9A), // teal highlight
      ),
      unselectedIconTheme: IconThemeData(
        size: 24,
        color: Colors.white.withOpacity(0.85),
      ),
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: Color(0xFF0A9D9A),
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: Colors.white.withOpacity(0.75),
      ),
      type: BottomNavigationBarType.fixed,
    ),

    // App Bar matches minimalist beach onboarding
  );
}
