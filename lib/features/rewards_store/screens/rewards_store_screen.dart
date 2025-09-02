import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/core/widgets/reward_card.dart';
import 'package:donor_dashboard/data/mock_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RewardsStoreScreen extends StatelessWidget {
  const RewardsStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                '${mockUser.totalPoints}',
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
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.9,
        ),
        itemCount: mockRewards.length,
        itemBuilder: (context, index) {
          return RewardCard(reward: mockRewards[index]);
        },
      ),
    );
  }
}