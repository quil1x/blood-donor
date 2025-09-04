import 'package:donor_dashboard/core/widgets/reward_card.dart';
import 'package:donor_dashboard/data/mock_data.dart';
import 'package:donor_dashboard/data/models/reward_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:donor_dashboard/features/auth/services/auth_service.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';

class RewardsStoreScreen extends StatefulWidget {
  final VoidCallback onUpdate;
  const RewardsStoreScreen({super.key, required this.onUpdate});

  @override
  State<RewardsStoreScreen> createState() => _RewardsStoreScreenState();
}

class _RewardsStoreScreenState extends State<RewardsStoreScreen> {
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      currentUser = AuthService().getCurrentUser();
    });
  }

  void _buyReward(RewardModel reward) {
    if (currentUser == null) return;

    if (currentUser!.totalPoints >= reward.cost) {
      setState(() {
        currentUser!.totalPoints -= reward.cost;
        currentUser!.save();
        widget.onUpdate();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Винагороду "${reward.title}" придбано!'),
          backgroundColor: AppColors.greenAccent,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Недостатньо балів для покупки!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Магазин винагород'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              side: BorderSide.none,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              avatar: Icon(CupertinoIcons.star_fill,
                  color: Theme.of(context).primaryColor),
              label: Text(
                '${currentUser!.totalPoints}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Змінено для кращого вигляду на мобільному
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.9,
        ),
        itemCount: mockRewards.length,
        itemBuilder: (context, index) {
          final reward = mockRewards[index];
          final canAfford = currentUser!.totalPoints >= reward.cost;
          return Opacity(
            opacity: canAfford ? 1.0 : 0.5,
            child: InkWell(
              onTap: canAfford ? () => _buyReward(reward) : null,
              borderRadius: BorderRadius.circular(12),
              child: RewardCard(reward: reward),
            ),
          );
        },
      ),
    );
  }
}
