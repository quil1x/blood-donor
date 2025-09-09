import 'package:donor_dashboard/core/widgets/challenge_card.dart';
import 'package:donor_dashboard/core/widgets/stat_card.dart';
import 'package:donor_dashboard/data/models/quest_model.dart'; // Імпортуємо модель квестів
import 'package:donor_dashboard/data/mock_data.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:donor_dashboard/features/auth/services/local_auth_service.dart';

// Перетворюємо на StatefulWidget для завантаження даних
class DashboardScreen extends StatefulWidget {
  final VoidCallback onUpdate;
  const DashboardScreen({super.key, required this.onUpdate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final LocalAuthService _authService = LocalAuthService();
  late Future<List<QuestModel>> _questsFuture;

  @override
  void initState() {
    super.initState();
    // Завантажуємо квести при першому запуску екрану
    _questsFuture = Future.value(MockData.quests);
  }

  // Метод для оновлення даних при "потягуванні"
  Future<void> _refreshData() async {
    setState(() {
      _questsFuture = Future.value(MockData.quests);
    });
    // Ця функція оновить дані користувача (на випадок, якщо вони змінились)
    widget.onUpdate();
  }

  @override
  void didUpdateWidget(DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Оновлюємо дані коли змінюється onUpdate callback
    if (oldWidget.onUpdate != widget.onUpdate) {
      setState(() {
        _questsFuture = Future.value(MockData.quests);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // ValueListenableBuilder слухає зміни користувача (напр., оновлення балів)
      body: ListenableBuilder(
        listenable: _authService,
        builder: (context, child) {
          final currentUser = _authService.currentUser;
          if (currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }
          
          debugPrint("📊 Дашборд: Оновлення даних - балів: ${currentUser.totalPoints}, квестів: ${currentUser.completedQuests.length}");
          debugPrint("📊 Дашборд: ID користувача: ${currentUser.id}");
          debugPrint("📊 Дашборд: Час оновлення: ${DateTime.now()}");

          // FutureBuilder завантажує квести
          return FutureBuilder<List<QuestModel>>(
            future: _questsFuture,
            builder: (context, snapshot) {
              // Фільтруємо активні квести, коли дані завантажені
              final activeQuests = (snapshot.data ?? [])
                  .where((quest) =>
                      !currentUser.completedQuests.containsKey(quest.id))
                  .toList();

              return RefreshIndicator(
                onRefresh: _refreshData,
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
                            child: Icon(Icons.person,
                                size: 30, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Усі картки статистики тепер показують реальні дані
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
                    // Показуємо завантажувач, поки квести не завантажились
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const Center(child: CircularProgressIndicator())
                    // Показуємо повідомлення, якщо активних квестів немає
                    else if (activeQuests.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Усі квести виконано! 🥳",
                              style: TextStyle(
                                  color: AppColors.lightTextSecondary)),
                        ),
                      )
                    // Відображаємо перші 3 активні квести
                    else
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
          );
        },
      ),
    );
  }
}
