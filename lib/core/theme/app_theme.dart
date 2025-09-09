import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Оновлена світла тема
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.greenAccent, // Основний колір - зелений
    textTheme: AppTextStyles.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.greenAccent,
      secondary: AppColors.pinkAccent,
      surface: AppColors.lightBackground,
      onSurface: AppColors.lightCard,
    ),
    cardTheme: CardTheme(
      color: AppColors.lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.lightBorder, width: 1),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: AppTextStyles.light.headlineMedium,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.greenAccent,
      unselectedItemColor: AppColors.lightTextSecondary,
      backgroundColor: AppColors.lightCard,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: AppColors.lightBackground,
      indicatorColor: Colors.transparent,
      selectedIconTheme: IconThemeData(color: AppColors.greenAccent),
      unselectedIconTheme: IconThemeData(color: AppColors.lightTextSecondary),
      selectedLabelTextStyle: TextStyle(color: AppColors.greenAccent),
      unselectedLabelTextStyle: TextStyle(color: AppColors.lightTextSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.greenAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: AppTextStyles.light.labelLarge,
      ),
    ),
  );

  // Темна тема
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.blueAccent, // Основний колір - синій
    textTheme: AppTextStyles.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.blueAccent,
      secondary: AppColors.greenAccent,
      surface: AppColors.darkBackground,
      onSurface: AppColors.darkCard,
    ),
    cardTheme: CardTheme(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.darkBorder, width: 1),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.blueAccent,
      unselectedItemColor: AppColors.darkTextSecondary,
      backgroundColor: AppColors.darkBackground,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.blueAccent,
      foregroundColor: AppColors.darkBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      textStyle: AppTextStyles.dark.labelLarge,
    )),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: AppColors.darkBackground,
      indicatorColor: Colors.transparent,
      selectedIconTheme: IconThemeData(color: AppColors.blueAccent),
      unselectedIconTheme: IconThemeData(color: AppColors.darkTextSecondary),
      selectedLabelTextStyle: TextStyle(color: AppColors.blueAccent),
      unselectedLabelTextStyle: TextStyle(color: AppColors.darkTextSecondary),
    ),
  );
}