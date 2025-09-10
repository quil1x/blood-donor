import 'package:donor_dashboard/features/auth/screens/login_screen.dart';
import 'package:donor_dashboard/core/services/static_auth_service.dart';
import 'package:donor_dashboard/core/services/blood_center_service.dart';
import 'package:donor_dashboard/core/widgets/book_visit_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:donor_dashboard/core/theme/app_colors.dart';
import 'package:donor_dashboard/data/models/app_user_model.dart';
import 'package:donor_dashboard/data/models/blood_center_model.dart';
import 'package:donor_dashboard/data/mock_data.dart';
import 'package:donor_dashboard/core/widgets/profile_stat_card.dart';
import 'package:donor_dashboard/core/widgets/profile_accent_card.dart';
import 'package:donor_dashboard/core/widgets/profile_action_section.dart';
import 'package:donor_dashboard/core/widgets/profile_quest_card.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onUpdate;
  final Function(int)? onTabChanged;

  const ProfileScreen({super.key, required this.onUpdate, this.onTabChanged});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StaticAuthService _authService = StaticAuthService();
  final BloodCenterService _bloodCenterService = BloodCenterService();
  List<BloodCenterModel> _bloodCenters = [];

  @override
  void initState() {
    super.initState();
    _loadBloodCenters();
  }

  Future<void> _loadBloodCenters() async {
    await _bloodCenterService.init();
    setState(() {
      // Показуємо більше центрів крові
      _bloodCenters = _bloodCenterService.bloodCenters.take(6).toList();
    });
  }

  @override
  void didUpdateWidget(ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Оновлюємо стан коли змінюється onUpdate callback
    if (oldWidget.onUpdate != widget.onUpdate) {
      setState(() {});
    }
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
        backgroundColor: Colors.white,
        title: const Text(
          'Інформація для входу',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Щоб зайти на іншому пристрої, використовуйте:',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: ${currentUser.email}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Пароль: ${currentUser.password}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Примітка: Ці дані зберігаються локально. Для повноцінної синхронізації між пристроями потрібен сервер.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Зрозуміло',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
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
        title: const Text(
          'Профіль',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.lightTextPrimary,
          ),
        ),
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
          
          return _buildNewProfileDesign(context, currentUser);
        },
      ),
    );
  }

  Widget _buildNewProfileDesign(BuildContext context, AppUser user) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Профільний заголовок
          _buildProfileHeader(user),
          
          // Картки статистики
          _buildStatsSection(user, isDesktop),
          
          // Секція центрів крові
          _buildBloodCentersSection(),
          
          // Секція квестів
          _buildQuestsSection(user),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(AppUser user) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.blueAccent,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Донор крові',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(AppUser user, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 20,
        vertical: isDesktop ? 20 : 0,
      ),
      child: isDesktop 
        ? Row(
            children: [
              Expanded(
                child: ProfileStatCard(
                  title: 'Загалом балів',
                  value: user.totalPoints.toString(),
                  subtitle: 'XP набрано',
                  icon: CupertinoIcons.star_fill,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ProfileAccentCard(
                  title: 'Донації',
                  value: user.totalDonations.toString(),
                  subtitle: 'Врятовано ${user.livesSaved} життів',
                  icon: CupertinoIcons.drop_fill,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ProfileStatCard(
                  title: 'Рівень',
                  value: '${(user.totalPoints / 1000).floor() + 1}',
                  subtitle: 'Донор',
                  icon: CupertinoIcons.person_fill,
                ),
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: ProfileStatCard(
                  title: 'Загалом балів',
                  value: user.totalPoints.toString(),
                  subtitle: 'XP набрано',
                  icon: CupertinoIcons.star_fill,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ProfileAccentCard(
                  title: 'Донації',
                  value: user.totalDonations.toString(),
                  subtitle: 'Врятовано ${user.livesSaved} життів',
                  icon: CupertinoIcons.drop_fill,
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildBloodCentersSection() {
    return ProfileActionSection(
      title: 'Центри крові',
      actionText: 'Всі',
      onAction: () {
        // Перемикаємо на вкладку центів крові (індекс 1)
        if (widget.onTabChanged != null) {
          widget.onTabChanged!(1);
        }
      },
      children: _bloodCenters.map((center) => 
        ProfileQuestCard(
          title: center.name,
          description: center.address,
          icon: CupertinoIcons.placemark_fill,
          isCompleted: false,
          onTap: () => _bookVisit(center),
        ),
      ).toList(),
    );
  }

  void _bookVisit(BloodCenterModel center) {
    showDialog(
      context: context,
      builder: (context) => BookVisitDialog(
        bloodCenter: center,
        onBooked: () {
          // Оновлюємо дані після успішного запису
          widget.onUpdate();
        },
      ),
    );
  }


  Widget _buildQuestsSection(AppUser user) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    
    final activeQuests = mockQuests
        .where((quest) => !user.completedQuests.containsKey(quest.id))
        .take(isDesktop ? 6 : 4)
        .toList();
    
    final completedQuests = mockQuests
        .where((quest) => user.completedQuests.containsKey(quest.id))
        .take(isDesktop ? 6 : 4)
        .toList();

    return Column(
      children: [
        ProfileActionSection(
          title: 'Активні квести',
          actionText: 'Всі',
          onAction: () {
            // Перемикаємо на вкладку квестів (індекс 2)
            if (widget.onTabChanged != null) {
              widget.onTabChanged!(2);
            }
          },
          children: activeQuests.map((quest) => 
            ProfileQuestCard(
              title: quest.title,
              description: quest.description,
              icon: quest.icon,
              isCompleted: false,
              onTap: () {
                // Виконати квест
              },
            ),
          ).toList(),
        ),
        if (completedQuests.isNotEmpty)
          ProfileActionSection(
            title: 'Виконані квести',
            children: completedQuests.map((quest) => 
              ProfileQuestCard(
                title: quest.title,
                description: quest.description,
                icon: quest.icon,
                isCompleted: true,
              ),
            ).toList(),
          ),
      ],
    );
  }
}