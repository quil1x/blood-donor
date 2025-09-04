// lib/features/rewards_store/screens/rewards_store_screen.dart

import 'package:donor_dashboard/core/widgets/reward_card.dart';
import 'package:donor_dashboard/data/mock_data.dart';
import 'package:donor_dashboard/features/auth/services/auth_service.dart';
import 'package:donor_dashboard/features/auth/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';

class RewardsStoreScreen extends StatefulWidget {
  final VoidCallback onUpdate;
  const RewardsStoreScreen({super.key, required this.onUpdate});

  @override
  State<RewardsStoreScreen> createState() => _RewardsStoreScreenState();
}

class _RewardsStoreScreenState extends State<RewardsStoreScreen> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  void _handlePurchase(int cost, AppUser currentUser) {
    if (currentUser.totalPoints >= cost) {
      currentUser.totalPoints -= cost;
      _databaseService.updateUserProfile(currentUser);
      widget.onUpdate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Покупка успішна!'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Недостатньо балів!'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Магазин бонусів')),
      body: ValueListenableBuilder<AppUser?>(
        valueListenable: _authService.currentUserNotifier,
        builder: (context, currentUser, child) {
          if (currentUser == null) {
            return const Center(child: Text("Помилка завантаження даних."));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: mockRewards.length,
            itemBuilder: (context, index) {
              final reward = mockRewards[index];
              return RewardCard(
                reward: reward,
                userPoints: currentUser.totalPoints,
                onPurchase: () => _handlePurchase(reward.cost, currentUser),
              );
            },
          );
        },
      ),
    );
  }
}
