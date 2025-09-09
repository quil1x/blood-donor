import 'package:donor_dashboard/core/navigation/main_navigation_shell.dart';
import 'package:donor_dashboard/core/theme/app_theme.dart';
import 'package:donor_dashboard/features/auth/screens/login_screen.dart';
import 'package:donor_dashboard/features/auth/services/local_auth_service.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Отримуємо екземпляр LocalAuthService тут
    final LocalAuthService authService = LocalAuthService();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Donor Dashboard',
      theme: AppTheme.lightTheme,
      home: ListenableBuilder(
        listenable: authService,
        builder: (context, child) {
          final currentUser = authService.currentUser;
          if (currentUser != null) {
            return const MainNavigationShell();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
