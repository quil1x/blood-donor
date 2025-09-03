import 'package:donor_dashboard/features/auth/screens/login_screen.dart';
import 'package:donor_dashboard/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser? _currentUser;

  @override
  void initState() {
    super.initState();
    // Отримуємо поточного користувача при завантаженні екрану
    _currentUser = AuthService().getCurrentUser();
  }

  // Функція виходу з акаунту
  Future<void> _logout() async {
    await AuthService().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Якщо користувача з якоїсь причини не знайдено, показуємо заглушку
    if (_currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text("Помилка: не вдалося завантажити профіль користувача."),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Профіль', style: TextStyle(color: AppColors.lightTextPrimary)),
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.lightTextSecondary),
            onPressed: _logout,
            tooltip: 'Вийти',
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Блок з інформацією про користувача
          _buildProfileHeader(),
          const SizedBox(height: 24),
          // Інші секції вашого профілю...
          _buildInfoCard(
            title: "Моя активність",
            items: {
              "Допомогли людям": "12",
              "Рівень": "3",
              "Досягнення": "5"
            }
          ),
          const SizedBox(height: 16),
           _buildInfoCard(
            title: "Налаштування",
            items: {}
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.greenAccent,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 16),
          // ВИКОРИСТОВУЄМО РЕАЛЬНІ ДАНІ
          Text(
            _currentUser!.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _currentUser!.email,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Map<String, String> items}) {
     return Card(
      elevation: 0,
      color: AppColors.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary)),
             const Divider(height: 24),
             if (items.isNotEmpty)
              ...items.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 16)),
                    Text(entry.value, style: const TextStyle(color: AppColors.lightTextPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              )).toList()
            else 
              const Center(child: Text("Тут поки що нічого немає", style: TextStyle(color: AppColors.lightTextSecondary))),
          ],
        ),
      ),
     );
  }
}