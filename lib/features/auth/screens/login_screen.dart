import 'package:donor_dashboard/core/navigation/main_navigation_shell.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/features/auth/screens/registration_screen.dart';
import 'package:donor_dashboard/core/services/static_auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final StaticAuthService _authService = StaticAuthService();
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final error = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        if (error == null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const MainNavigationShell()),
          );
        } else {
          setState(() {
            _errorMessage = error;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.lightBackground, Color(0xFFE2E8F0)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
                top: -100,
                left: -100,
                child: CircleShape(
                    color: AppColors.blueAccent.withOpacity(0.1), size: 300)),
            Positioned(
                bottom: -150,
                right: -150,
                child: CircleShape(
                    color: AppColors.pinkAccent.withOpacity(0.05), size: 400)),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildGlassCard(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('З поверненням!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightTextPrimary)),
                const SizedBox(height: 8),
                const Text('Увійдіть у свій акаунт донора',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.lightTextSecondary)),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  // >>> ПОЧАТОК ЗМІН <<<
                  style: const TextStyle(
                      color: Colors.black), // Текст вводу чорний
                  decoration: _inputDecoration(
                      'Електронна пошта', Icons.email_outlined),
                  // >>> КІНЕЦЬ ЗМІН <<<
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => (value == null || !value.contains('@'))
                      ? 'Введіть коректний email'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  // >>> ПОЧАТОК ЗМІН <<<
                  style: const TextStyle(
                      color: Colors.black), // Текст вводу чорний
                  decoration: _inputDecoration('Пароль', Icons.lock_outline),
                  // >>> КІНЕЦЬ ЗМІН <<<
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Введіть пароль'
                      : null,
                ),
                const SizedBox(height: 24),
                if (_errorMessage != null)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(_errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 14))),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('УВІЙТИ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RegistrationScreen())),
                  child: const Text('Немає акаунту? Створити',
                      style: TextStyle(color: AppColors.lightTextPrimary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      // >>> ПОЧАТОК ЗМІН (колір тексту підказки) <<<
      labelStyle: const TextStyle(color: AppColors.lightTextSecondary),
      hintStyle:
          TextStyle(color: AppColors.lightTextSecondary.withOpacity(0.7)),
      // >>> КІНЕЦЬ ЗМІН <<<
      prefixIcon: Icon(icon, color: AppColors.lightTextSecondary),
      filled: true,
      fillColor: AppColors.lightBackground.withOpacity(0.8),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}

class CircleShape extends StatelessWidget {
  final Color color;
  final double size;
  const CircleShape({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}
