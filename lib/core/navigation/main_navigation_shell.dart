import 'package:donor_dashboard/features/blood_centers/screens/blood_centers_screen.dart';
import 'package:donor_dashboard/features/dashboard/screens/dashboard_screen.dart';
import 'package:donor_dashboard/features/profile/screens/profile_screen.dart';
import 'package:donor_dashboard/features/quests/screens/quests_screen.dart';
import 'package:donor_dashboard/features/rewards_store/screens/rewards_store_screen.dart';
import 'package:donor_dashboard/features/auth/services/local_auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;
  final LocalAuthService _authService = LocalAuthService();

  // Створюємо список віджетів всередині initState, щоб передати реальний метод.
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // Цей метод буде викликатися з дочірніх екранів для оновлення стану
    void refreshData() {
      setState(() {
        // Пустий setState змусить цей віджет і всі дочірні екрани
        // завантажити свіжі дані з сервісів (наприклад, AuthService).
      });
    }

    // ✅ ОСНОВНЕ ВИПРАВЛЕННЯ:
    // Тепер `onUpdate` передається до ВСІХ екранів, які його потребують.
    _screens = [
      DashboardScreen(onUpdate: refreshData),
      BloodCentersScreen(onUpdate: refreshData), // <-- Додано
      QuestsScreen(onUpdate: refreshData),
      RewardsStoreScreen(onUpdate: refreshData), // <-- Додано
      ProfileScreen(onUpdate: refreshData),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const breakpoint = 600;

    return ListenableBuilder(
      listenable: _authService,
      builder: (context, child) {
        // Код для мобільних пристроїв
        if (width < breakpoint) {
          return Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home), label: 'Дашборд'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.placemark), label: 'Центри'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.flame), label: 'Квести'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.gift), label: 'Бонуси'),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.person), label: 'Профіль'),
              ],
            ),
          );
        }
        // Код для планшетів та вебу
        else {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemTapped,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                        icon: Icon(CupertinoIcons.home), label: Text('Дашборд')),
                    NavigationRailDestination(
                        icon: Icon(CupertinoIcons.placemark),
                        label: Text('Центри')),
                    NavigationRailDestination(
                        icon: Icon(CupertinoIcons.flame), label: Text('Квести')),
                    NavigationRailDestination(
                        icon: Icon(CupertinoIcons.gift), label: Text('Бонуси')),
                    NavigationRailDestination(
                        icon: Icon(CupertinoIcons.person), label: Text('Профіль')),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _screens,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
