import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Оновлена світла тема
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.blueAccent, // Основний колір - синій
    textTheme: AppTextStyles.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.blueAccent,
      secondary: AppColors.pinkAccent,
      surface: AppColors.lightBackground,
      onSurface: AppColors.lightCard,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: AppTextStyles.light.headlineMedium,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.blueAccent,
      unselectedItemColor: AppColors.lightTextSecondary,
      backgroundColor: AppColors.lightCard,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: AppColors.lightBackground,
      indicatorColor: Colors.transparent,
      selectedIconTheme: IconThemeData(color: AppColors.blueAccent),
      unselectedIconTheme: IconThemeData(color: AppColors.lightTextSecondary),
      selectedLabelTextStyle: TextStyle(color: AppColors.blueAccent),
      unselectedLabelTextStyle: TextStyle(color: AppColors.lightTextSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blueAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: AppTextStyles.light.labelLarge,
      ),
    ),
  );

}