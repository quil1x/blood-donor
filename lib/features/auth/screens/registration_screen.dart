import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/app_user_model.dart';
import 'package:donor_dashboard/core/navigation/main_navigation_shell.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final userBox = Hive.box<AppUser>('users');
      final email = _emailController.text;

      if (userBox.containsKey(email)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.redAccent, content: Text('Користувач з таким email вже існує')));
        return;
      }
      final newUser = AppUser(name: _nameController.text, email: email, password: _passwordController.text);
      await userBox.put(email, newUser);
      
      // АВТОМАТИЧНО ЛОГІНИМО КОРИСТУВАЧА ПІСЛЯ РЕЄСТРАЦІЇ
      await AuthService().login(email);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainNavigationShell()),
        (route) => false,
      );
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
                  const Text('Create Account', textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightTextPrimary, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Sign up to get started', textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 16)),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: AppColors.lightTextPrimary),
                    decoration: _buildInputDecoration(hint: 'Full Name', icon: Icons.person_outline),
                    validator: (value) => (value == null || value.isEmpty) ? 'Введіть ваше ім\'я' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: AppColors.lightTextPrimary),
                    decoration: _buildInputDecoration(hint: 'Email', icon: Icons.email_outlined),
                    validator: (value) => (value == null || !value.contains('@')) ? 'Введіть коректний email' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.lightTextPrimary),
                    decoration: _buildInputDecoration(hint: 'Password', icon: Icons.lock_outline),
                    validator: (value) => (value == null || value.length < 6) ? 'Пароль має містити мінімум 6 символів' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.lightTextPrimary),
                    decoration: _buildInputDecoration(hint: 'Confirm Password', icon: Icons.lock_outline),
                    validator: (value) => (value != _passwordController.text) ? 'Паролі не співпадають' : null,
                  ),
                  const SizedBox(height: 40),
                  _buildSignUpButton(),
                  const SizedBox(height: 32),
                  _buildSignInLink(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hint, required IconData icon}) => InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.lightTextSecondary),
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
        filled: true,
        fillColor: AppColors.lightCard,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightBorder)),
      );

  Widget _buildSignUpButton() => ElevatedButton(
        onPressed: _registerUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenAccent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      );

  Widget _buildSignInLink(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("Already have an account?", style: TextStyle(color: AppColors.lightTextSecondary)),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Sign in', style: TextStyle(color: AppColors.greenAccent, fontWeight: FontWeight.bold)),
        ),
      ]);
}