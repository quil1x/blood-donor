import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/data/models/quest_model.dart';
import 'package:flutter/material.dart';

class ChallengeCard extends StatelessWidget {
  final QuestModel quest;
  final bool isCompleted;
  final VoidCallback? onComplete;

  const ChallengeCard({
    super.key,
    required this.quest,
    required this.isCompleted,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(quest.icon,
                    color: isCompleted
                        ? AppColors.blueAccent
                        : theme.primaryColor,
                    size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(quest.title, style: theme.textTheme.titleLarge),
                      Text(quest.description,
                          style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                Text(
                  '+${quest.rewardPoints} XP',
                  style: TextStyle(
                    color: isCompleted
                        ? AppColors.blueAccent
                        : theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: isCompleted ? 1.0 : 0.0,
                minHeight: 8,
                backgroundColor: theme.scaffoldBackgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted ? AppColors.blueAccent : theme.primaryColor,
                ),
              ),
            ),
            if (onComplete != null && !isCompleted) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: onComplete,
                  child: const Text('Зарахувати виконання'),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
