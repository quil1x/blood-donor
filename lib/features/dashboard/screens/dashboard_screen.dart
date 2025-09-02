import 'package:donor_dashboard/core/widgets/challenge_card.dart';
import 'package:donor_dashboard/core/widgets/stat_card.dart';
import 'package:donor_dashboard/data/mock_data.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = mockUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Вітаю,', style: theme.textTheme.bodyMedium),
            Text(user.name, style: theme.textTheme.headlineMedium),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              StatCard(
                title: 'Донацій',
                value: user.totalDonations.toString(),
                icon: CupertinoIcons.drop_fill,
                iconColor: Colors.red.shade400,
              ),
              StatCard(
                title: 'Врятовано життів',
                value: user.livesSaved.toString(),
                icon: CupertinoIcons.heart_fill,
                iconColor: AppColors.pinkAccent,
              ),
            ],
          ),
          const SizedBox(height: 16),
          StatCard(
            title: 'Загалом балів',
            value: user.totalPoints.toString(),
            icon: CupertinoIcons.star_fill,
            iconColor: Colors.amber,
          ),
          
          const SizedBox(height: 32),
          
          Text('Активні квести', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),
          ...mockQuests.where((q) => q.progress < 1.0).map((quest) => ChallengeCard(
            quest: quest,
            onComplete: null,
          )),
        ],
      ),
    );
  }
}