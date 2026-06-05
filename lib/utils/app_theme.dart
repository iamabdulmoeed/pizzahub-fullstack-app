import 'package:flutter/material.dart';

// Ye hamari app ki color palette hai, premium feel ke liye humne deep colors use kiye hain
class AppColors {
  static const Color primaryRed = Color(0xFFE31837); // Vibrant Pizza Red
  static const Color accentRed = Color(0xFFB91C1C);  // Darker shade for gradients
  static const Color surfaceWhite = Color(0xFFF9FAFB);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF111827);   // Dark Slate
  static const Color textSecondary = Color(0xFF6B7280); // Grey text
  static const Color chipBackground = Color(0xFFF3F4F6);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true, // Modern Material 3 look
      primaryColor: AppColors.primaryRed,
      scaffoldBackgroundColor: AppColors.backgroundWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryRed,
        primary: AppColors.primaryRed,
        surface: AppColors.surfaceWhite,
      ),
      
      // AppBar styling
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundWhite,
        foregroundColor: AppColors.textMain,
        elevation: 0,
        centerTitle: false, // Left aligned title looks more modern
        titleTextStyle: TextStyle(
          color: AppColors.textMain,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Buttons styling
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Input fields styling
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.chipBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
      
      // Typography
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.textMain,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textMain,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.textMain,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textMain,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
    );
  }
}
