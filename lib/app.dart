import 'package:donor_dashboard/core/navigation/main_navigation_shell.dart';
import 'package:donor_dashboard/core/theme/app_theme.dart';
import 'package:donor_dashboard/features/auth/screens/login_screen.dart';
import 'package:donor_dashboard/core/services/static_auth_service.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final StaticAuthService _authService = StaticAuthService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await _authService.init();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Donor Dashboard',
      theme: AppTheme.lightTheme,
      home: ListenableBuilder(
        listenable: _authService,
        builder: (context, child) {
          final currentUser = _authService.currentUser;
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
