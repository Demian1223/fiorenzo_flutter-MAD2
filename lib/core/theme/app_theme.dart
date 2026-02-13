import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        background: AppColors.background,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.background,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary, // Black
        foregroundColor: Colors.white, // White text
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cormorantGaramond(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 2.0,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.cormorantGaramond(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        headlineMedium: GoogleFonts.cormorantGaramond(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.cormorantGaramond(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.cormorantGaramond(
          color: AppColors
              .textPrimary, // Changed to primary for better readability
          fontSize: 14,
        ),
        labelLarge: GoogleFonts.cormorantGaramond(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          textStyle: GoogleFonts.cormorantGaramond(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.cormorantGaramond(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.cormorantGaramond(fontSize: 12),
      ),
    );
  }
}
