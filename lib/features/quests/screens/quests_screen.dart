import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/core/widgets/challenge_card.dart';
import 'package:donor_dashboard/data/mock_data.dart';
import 'package:flutter/material.dart';

class QuestsScreen extends StatefulWidget {
  const QuestsScreen({super.key});

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  void _handleCompleteQuest(quest) {
    setState(() {
      completeQuestAndUpdatePoints(quest);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Квест "${quest.title}" виконано! +${quest.rewardPoints} XP'),
        backgroundColor: AppColors.greenAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedQuests = List.of(mockQuests)
      ..sort((a, b) => a.progress.compareTo(b.progress));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Усі квести'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sortedQuests.length,
        itemBuilder: (context, index) {
          final quest = sortedQuests[index];
          return ChallengeCard(
            quest: quest,
            onComplete: () => _handleCompleteQuest(quest),
          );
        },
      ),
    );
  }
}