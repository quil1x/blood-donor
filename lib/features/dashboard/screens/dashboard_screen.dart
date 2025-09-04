import 'package:donor_dashboard/core/widgets/challenge_card.dart';
import 'package:donor_dashboard/core/widgets/stat_card.dart';
import 'package:donor_dashboard/data/mock_data.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:donor_dashboard/features/auth/services/auth_service.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onUpdate;
  const DashboardScreen({super.key, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      body: ValueListenableBuilder<AppUser?>(
        valueListenable: authService.currentUserNotifier,
        builder: (context, currentUser, child) {
          if (currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final theme = Theme.of(context);
          final activeQuests = mockQuests
              .where(
                  (quest) => !currentUser.completedQuests.containsKey(quest.id))
              .toList();

          return RefreshIndicator(
            onRefresh: () async {
              await authService.init();
              onUpdate();
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Вітаю,', style: theme.textTheme.bodyMedium),
                          Text(currentUser.name,
                              style: theme.textTheme.headlineMedium),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.greenAccent,
                        child:
                            Icon(Icons.person, size: 30, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      StatCard(
                        title: 'Донацій',
                        value: currentUser.totalDonations.toString(),
                        icon: CupertinoIcons.drop_fill,
                        iconColor: Colors.red.shade400,
                      ),
                      StatCard(
                        title: 'Врятовано',
                        value: "${currentUser.livesSaved} життів",
                        icon: CupertinoIcons.heart_fill,
                        iconColor: AppColors.pinkAccent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: StatCard(
                    title: 'Загалом балів',
                    value: currentUser.totalPoints.toString(),
                    icon: CupertinoIcons.star_fill,
                    iconColor: Colors.amber,
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Активні квести',
                      style: theme.textTheme.headlineMedium),
                ),
                const SizedBox(height: 16),
                if (activeQuests.isEmpty)
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Усі квести виконано! 🥳",
                        style: TextStyle(color: AppColors.lightTextSecondary)),
                  )),
                ...activeQuests.take(3).map((quest) => Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: ChallengeCard(
                        quest: quest,
                        isCompleted: false,
                        onComplete: null,
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
