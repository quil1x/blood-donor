import 'package:donor_dashboard/core/navigation/main_navigation_shell.dart';
import 'package:donor_dashboard/core/theme/app_theme.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:donor_dashboard/features/auth/screens/login_screen.dart';
import 'package:donor_dashboard/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Отримуємо екземпляр AuthService тут
    final AuthService authService = AuthService();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Donor Dashboard',
      theme: AppTheme.lightTheme,
      home: ValueListenableBuilder<AppUser?>(
        valueListenable: authService.currentUserNotifier,
        builder: (context, currentUser, child) {
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
