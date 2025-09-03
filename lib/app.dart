import 'package:donor_dashboard/core/theme/app_theme.dart';
import 'package:donor_dashboard/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Donor Dashboard',
      theme: AppTheme.lightTheme,
      // Встановлюємо LoginScreen як головний екран
      home: const LoginScreen(),
    );
  }
}