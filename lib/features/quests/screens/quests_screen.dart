import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/core/widgets/challenge_card.dart';
import 'package:donor_dashboard/data/mock_data.dart';
import 'package:donor_dashboard/data/models/quest_model.dart';
import 'package:donor_dashboard/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';

class QuestsScreen extends StatefulWidget {
  final VoidCallback onUpdate;
  const QuestsScreen({super.key, required this.onUpdate});

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  final AuthService _authService = AuthService();
  final List<String> manualQuests = [
    "invite_friend",
    "share_achievement",
    "read_article"
  ];

  void _handleCompleteQuest(QuestModel quest, AppUser currentUser) {
    if (!currentUser.completedQuests.containsKey(quest.id)) {
      currentUser.completedQuests[quest.id] = DateTime.now();
      currentUser.totalPoints += quest.rewardPoints;
      _authService.updateUser(currentUser);
      widget.onUpdate();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Квест "${quest.title}" виконано! +${quest.rewardPoints} XP'),
          backgroundColor: AppColors.greenAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Усі квести'),
      ),
      body: ValueListenableBuilder<AppUser?>(
        valueListenable: _authService.currentUserNotifier,
        builder: (context, currentUser, child) {
          if (currentUser == null) {
            return const Center(child: Text("Помилка завантаження даних."));
          }

          final sortedQuests = List.of(mockQuests)
            ..sort((a, b) {
              final aCompleted = currentUser.completedQuests.containsKey(a.id);
              final bCompleted = currentUser.completedQuests.containsKey(b.id);
              if (aCompleted && !bCompleted) return 1;
              if (!aCompleted && bCompleted) return -1;
              return 0;
            });

          return RefreshIndicator(
            onRefresh: () async {
              await _authService.init();
              widget.onUpdate();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: sortedQuests.length,
              itemBuilder: (context, index) {
                final quest = sortedQuests[index];
                final isCompleted =
                    currentUser.completedQuests.containsKey(quest.id);
                final bool canCompleteManually =
                    manualQuests.contains(quest.id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ChallengeCard(
                    quest: quest,
                    isCompleted: isCompleted,
                    onComplete: (isCompleted || !canCompleteManually)
                        ? null
                        : () => _handleCompleteQuest(quest, currentUser),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
