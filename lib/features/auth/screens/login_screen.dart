import 'package:donor_dashboard/core/navigation/main_navigation_shell.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/features/auth/screens/registration_screen.dart';
import 'package:donor_dashboard/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/app_user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      final userBox = Hive.box<AppUser>('users');
      final email = _emailController.text;
      final password = _passwordController.text;
      final user = userBox.get(email);

      if (user != null && user.password == password) {
        await AuthService().login(email);

        if (mounted) {
          // ВИПРАВЛЕНО
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const MainNavigationShell()),
          );
        }
      } else {
        if (mounted) {
          // ВИПРАВЛЕНО
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text('Неправильний email або пароль'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Welcome Back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.lightTextPrimary,
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Sign in to your account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.lightTextSecondary, fontSize: 16)),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: AppColors.lightTextPrimary),
                    decoration: _buildInputDecoration(
                        hint: 'Email', icon: Icons.person_outline),
                    validator: (value) =>
                        (value == null || !value.contains('@'))
                            ? 'Введіть коректний email'
                            : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.lightTextPrimary),
                    decoration: _buildInputDecoration(
                        hint: 'Password', icon: Icons.lock_outline),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Введіть пароль'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  _buildLoginButton(),
                  const SizedBox(height: 32),
                  _buildSignUpLink(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
          {required String hint, required IconData icon}) =>
      InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.lightTextSecondary),
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
        filled: true,
        fillColor: AppColors.lightCard,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightBorder)),
      );

  Widget _buildLoginButton() => ElevatedButton(
        onPressed: _loginUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenAccent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Login',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      );

  Widget _buildSignUpLink(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("Don't have an account?",
            style: TextStyle(color: AppColors.lightTextSecondary)),
        TextButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const RegistrationScreen())),
          child: const Text('Sign up',
              style: TextStyle(
                  color: AppColors.greenAccent, fontWeight: FontWeight.bold)),
        ),
      ]);
}
