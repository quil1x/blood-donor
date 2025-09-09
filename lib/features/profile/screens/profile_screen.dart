import 'package:donor_dashboard/features/auth/screens/login_screen.dart';
import 'package:donor_dashboard/core/services/static_auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:donor_dashboard/data/mock_data.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onUpdate;
  const ProfileScreen({super.key, required this.onUpdate});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final StaticAuthService _authService = StaticAuthService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didUpdateWidget(ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Оновлюємо стан коли змінюється onUpdate callback
    if (oldWidget.onUpdate != widget.onUpdate) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    _authService.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showLoginInfo(BuildContext context) {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Інформація для входу'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Щоб зайти на іншому пристрої, використовуйте:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${currentUser.email}'),
                  const SizedBox(height: 8),
                  Text('Пароль: ${currentUser.password}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Примітка: Ці дані зберігаються локально. Для повноцінної синхронізації між пристроями потрібен сервер.',
              style: TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Зрозуміло'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.lightBackground,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline,
                color: AppColors.lightTextSecondary),
            onPressed: () => _showLoginInfo(context),
            tooltip: 'Інформація для входу',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: AppColors.lightTextSecondary),
            onPressed: _logout,
            tooltip: 'Налаштування / Вийти',
          )
        ],
      ),
      body: ListenableBuilder(
        listenable: _authService,
        builder: (context, child) {
          final currentUser = _authService.currentUser;
          if (currentUser == null) {
            return const Center(child: Text("Користувача не знайдено."));
          }
          
          debugPrint("👤 Профіль: Оновлення даних - балів: ${currentUser.totalPoints}, квестів: ${currentUser.completedQuests.length}");
          debugPrint("👤 Профіль: ID користувача: ${currentUser.id}");
          debugPrint("👤 Профіль: Час оновлення: ${DateTime.now()}");
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: _buildProfileHeader(currentUser),
                )
              ];
            },
            body: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.greenAccent,
                  unselectedLabelColor: AppColors.lightTextSecondary,
                  indicatorColor: AppColors.greenAccent,
                  tabs: const [
                    Tab(text: 'СТАТИСТИКА'),
                    Tab(text: 'ДОСЯГНЕННЯ'),
                    Tab(text: 'АКТИВНІСТЬ'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildStatsTab(currentUser),
                      _buildAchievementsTab(currentUser),
                      _buildActivityTab(currentUser),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(AppUser user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.greenAccent,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(user.name,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightTextPrimary)),
          const SizedBox(height: 4),
          Text(user.email,
              style: const TextStyle(
                  fontSize: 16, color: AppColors.lightTextSecondary)),
        ],
      ),
    );
  }

  Widget _buildStatsTab(AppUser user) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          children: [
            Expanded(
                child: _buildStatCard("Донації", user.totalDonations.toString(),
                    CupertinoIcons.drop_fill, Colors.red.shade400)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildStatCard("Бали", user.totalPoints.toString(),
                    CupertinoIcons.star_fill, Colors.amber)),
          ],
        ),
        const SizedBox(height: 24),
        _buildSectionHeader("Сильні сторони"),
        _buildTopicCard(
            "Допомога іншим",
            "${user.livesSaved} врятованих життів",
            CupertinoIcons.heart_fill,
            AppColors.pinkAccent,
            1.0),
        _buildTopicCard("Регулярність", "Рівень 2", CupertinoIcons.calendar,
            AppColors.blueAccent, 0.6),
        const SizedBox(height: 24),
        _buildSectionHeader("Над чим працювати"),
        _buildTopicCard("Соціальна активність", "Запросіть друзів",
            CupertinoIcons.person_2_fill, AppColors.lightTextSecondary, 0.3),
      ],
    );
  }

  Widget _buildAchievementsTab(AppUser user) {
    int level = (user.totalPoints / 1000).floor() + 1;
    double progressToNextLevel = (user.totalPoints % 1000) / 1000.0;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildLevelCard(level, progressToNextLevel),
        const SizedBox(height: 24),
        _buildSectionHeader("МЕДАЛІ (${user.completedQuests.length})"),
        ...mockQuests
            .where((q) => user.completedQuests.containsKey(q.id))
            .map((quest) {
          return _buildAchievementTile(
              quest.icon,
              quest.title,
              "Виконано: ${DateFormat.yMMMd().format(user.completedQuests[quest.id]!)}",
              true);
        }),
        ...mockQuests
            .where((q) => !user.completedQuests.containsKey(q.id))
            .map((quest) {
          return _buildAchievementTile(
              quest.icon, quest.title, quest.description, false);
        }),
      ],
    );
  }

  Widget _buildActivityTab(AppUser user) {
    if (user.completedQuests.isEmpty) {
      return const Center(
          child: Text("Тут буде ваша історія досягнень.",
              style: TextStyle(color: AppColors.lightTextSecondary)));
    }
    var sortedQuests = user.completedQuests.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      itemCount: sortedQuests.length,
      itemBuilder: (context, index) {
        final questEntry = sortedQuests[index];
        final quest = mockQuests.firstWhere((q) => q.id == questEntry.key);
        return _buildActivityTile(
            quest.icon,
            "Квест виконано: ${quest.title}",
            "Отримано ${quest.rewardPoints} XP",
            DateFormat.yMMMd().format(questEntry.value));
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.lightTextSecondary, fontSize: 16)),
          Icon(icon, color: color)
        ]),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.lightTextPrimary)),
      ]),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title,
          style: const TextStyle(
              color: AppColors.lightTextSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 14)),
    );
  }

  Widget _buildTopicCard(String title, String subtitle, IconData icon,
      Color color, double progress) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(children: [
              CircleAvatar(
                  backgroundColor: color.withAlpha(25),
                  child: Icon(icon, color: color)), // ВИПРАВЛЕНО
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightTextPrimary)),
                    Text(subtitle,
                        style: const TextStyle(
                            color: AppColors.lightTextSecondary)),
                  ])),
            ]),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.lightBackground,
                  color: color),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(int level, double progress) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Рівень $level",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("${(progress * 1000).toInt()}/1000 балів до наступного рівня",
                style: const TextStyle(color: AppColors.lightTextSecondary)),
          ]),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.lightBackground,
                color: AppColors.greenAccent),
          ),
        ]),
      ),
    );
  }

  Widget _buildAchievementTile(
      IconData icon, String title, String subtitle, bool isCompleted) {
    return Opacity(
      opacity: isCompleted ? 1.0 : 0.5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCompleted
              ? AppColors.greenAccent.withAlpha(25)
              : AppColors.lightTextSecondary.withAlpha(25), // ВИПРАВЛЕНО
          child: Icon(icon,
              color: isCompleted
                  ? AppColors.greenAccent
                  : AppColors.lightTextSecondary),
        ),
        title: Text(title,
            style: TextStyle(
                fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                color: AppColors.lightTextPrimary)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AppColors.lightTextSecondary)),
      ),
    );
  }

  Widget _buildActivityTile(
      IconData icon, String title, String subtitle, String date) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: AppColors.greenAccent.withAlpha(25),
            child: Icon(icon, color: AppColors.greenAccent)), // ВИПРАВЛЕНО
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.lightTextPrimary)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AppColors.lightTextSecondary)),
        trailing: Text(date,
            style: const TextStyle(
                color: AppColors.lightTextSecondary, fontSize: 12)),
      ),
    );
  }
}
