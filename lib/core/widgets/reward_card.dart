import 'package:donor_dashboard/data/models/reward_model.dart';
import 'package:flutter/material.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';

class RewardCard extends StatelessWidget {
  final RewardModel reward;
  final int userPoints; // <-- Додано
  final VoidCallback onPurchase; // <-- Додано

  const RewardCard({
    super.key,
    required this.reward,
    required this.userPoints, // <-- Додано
    required this.onPurchase, // <-- Додано
  });

  @override
  Widget build(BuildContext context) {
    final bool canAfford = userPoints >= reward.cost;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Icon(reward.icon,
                    size: 48, color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(reward.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(reward.description,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: canAfford ? onPurchase : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
                backgroundColor:
                    canAfford ? AppColors.blueAccent : Colors.grey,
              ),
              child: Text('${reward.cost} балів'),
            )
          ],
        ),
      ),
    );
  }
}
