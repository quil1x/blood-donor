import 'package:donor_dashboard/core/navigation/main_navigation_shell.dart';
import 'package:donor_dashboard/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DonorDashboardApp extends StatelessWidget {
  const DonorDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donor Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const MainNavigationShell(),
    );
  }
}