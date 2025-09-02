import 'package:donor_dashboard/data/models/reward_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RewardCard extends StatelessWidget {
  final RewardModel reward;

  const RewardCard({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(reward.icon, size: 48, color: theme.primaryColor),
            const SizedBox(height: 16),
            
            Text(
              reward.title,
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            Text(
              reward.description,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const Spacer(),
            
            Chip(
              avatar: Icon(CupertinoIcons.star_fill, size: 16, color: theme.primaryColor),
              label: Text(
                '${reward.cost} XP',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              backgroundColor: theme.primaryColor.withOpacity(0.1),
              side: BorderSide.none,
            ),
          ],
        ),
      ),
    );
  }
}