import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static const _baseFont = GoogleFonts.inter;

  // Оновлені стилі для світлої теми
  static final light = TextTheme(
    displayLarge: _baseFont(fontSize: 34, fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary, letterSpacing: -0.5),
    headlineMedium: _baseFont(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary),
    titleLarge: _baseFont(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary),
    bodyLarge: _baseFont(fontSize: 16, color: AppColors.lightTextPrimary),
    bodyMedium: _baseFont(fontSize: 14, color: AppColors.lightTextSecondary),
    labelLarge: _baseFont(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
  );

  // Стилі для темної теми
  static final dark = TextTheme(
    displayLarge: _baseFont(fontSize: 34, fontWeight: FontWeight.bold, color: AppColors.darkTextPrimary, letterSpacing: -0.5),
    headlineMedium: _baseFont(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkTextPrimary),
    titleLarge: _baseFont(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
    bodyLarge: _baseFont(fontSize: 16, color: AppColors.darkTextPrimary),
    bodyMedium: _baseFont(fontSize: 14, color: AppColors.darkTextSecondary),
    labelLarge: _baseFont(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkBackground),
  );
}