// lib/features/quests/screens/quests_screen.dart

import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/core/widgets/challenge_card.dart';
import 'package:donor_dashboard/data/models/quest_model.dart';
import 'package:donor_dashboard/core/services/static_auth_service.dart';
import 'package:donor_dashboard/data/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';

class QuestsScreen extends StatefulWidget {
  final VoidCallback onUpdate;
  const QuestsScreen({super.key, required this.onUpdate});

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  final StaticAuthService _authService = StaticAuthService();
  late Future<List<QuestModel>> _questsFuture;
  final List<String> manualQuests = [
    "invite_friend",
    "share_achievement",
    "read_article"
  ];

  @override
  void initState() {
    super.initState();
    _questsFuture = Future.value(MockData.quests);
  }

  Future<void> _handleCompleteQuest(QuestModel quest, AppUser currentUser) async {
    if (!currentUser.completedQuests.containsKey(quest.id)) {
      debugPrint("🎯 Виконуємо квест: ${quest.title} (+${quest.rewardPoints} XP)");
      
      currentUser.completedQuests[quest.id] = DateTime.now();
      currentUser.totalPoints += quest.rewardPoints;
      
      debugPrint("📊 Нові дані: балів: ${currentUser.totalPoints}, квестів: ${currentUser.completedQuests.length}");
      
      // Чекаємо на оновлення профілю
      final success = await _authService.updateUserProfile(currentUser);
      if (success) {
        widget.onUpdate();
        // Оновлюємо стан екрану, щоб квест зник зі списку
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Квест "${quest.title}" виконано! +${quest.rewardPoints} XP'),
            backgroundColor: AppColors.greenAccent,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Помилка оновлення профілю'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      debugPrint("⚠️ Квест ${quest.title} вже виконано");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Усі квести')),
      body: ListenableBuilder(
        listenable: _authService,
        builder: (context, child) {
          final currentUser = _authService.currentUser;
          if (currentUser == null) {
            return const Center(child: Text("Помилка завантаження даних."));
          }
          return FutureBuilder<List<QuestModel>>(
            future: _questsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Квести не знайдено."));
              }
              final allQuests = snapshot.data!;
              final activeQuests = allQuests
                  .where((quest) => !currentUser.completedQuests.containsKey(quest.id))
                  .toList();
              final completedQuests = allQuests
                  .where((quest) => currentUser.completedQuests.containsKey(quest.id))
                  .toList();

              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _questsFuture = Future.value(MockData.quests);
                  });
                  widget.onUpdate();
                },
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Активні квести
                    if (activeQuests.isNotEmpty) ...[
                      const Text(
                        'Активні квести',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...activeQuests.map((quest) {
                        final canCompleteManually = manualQuests.contains(quest.id);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ChallengeCard(
                            quest: quest,
                            isCompleted: false,
                            onComplete: canCompleteManually
                                ? () => _handleCompleteQuest(quest, currentUser)
                                : null,
                          ),
                        );
                      }),
                    ],
                    
                    // Виконані квести
                    if (completedQuests.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Виконані квести',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...completedQuests.map((quest) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ChallengeCard(
                            quest: quest,
                            isCompleted: true,
                            onComplete: null,
                          ),
                        );
                      }),
                    ],
                    
                    // Повідомлення якщо немає квестів
                    if (activeQuests.isEmpty && completedQuests.isEmpty)
                      const Center(
                        child: Text(
                          "Квести не знайдено.",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
