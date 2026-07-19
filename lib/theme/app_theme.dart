import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  // 🌞 LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2979FF),
      secondary: Color(0xFF00B8D4),
      tertiary: Color(0xFFFFC400),
      surface: Colors.white,
    ),

    scaffoldBackgroundColor: const Color(0xFFF8FAFD),

    textTheme: GoogleFonts.poppinsTextTheme(),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  // 🌙 DARK THEME
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFB9F6CA),
      secondary: Color(0xFF80D8FF),
      tertiary: Color(0xFFFFAB40),
      surface: Color(0xFF1E1E1E),
    ),

    scaffoldBackgroundColor: const Color(0xFF121212),

    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}