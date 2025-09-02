import 'package:donor_dashboard/features/blood_centers/screens/blood_centers_screen.dart';
import 'package:donor_dashboard/features/dashboard/screens/dashboard_screen.dart';
import 'package:donor_dashboard/features/profile/screens/profile_screen.dart';
import 'package:donor_dashboard/features/quests/screens/quests_screen.dart';
import 'package:donor_dashboard/features/rewards_store/screens/rewards_store_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const BloodCentersScreen(),
    const QuestsScreen(),
    const RewardsStoreScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const breakpoint = 600;

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
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Дашборд'),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.placemark), label: 'Центри'),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.flame), label: 'Квести'),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.gift), label: 'Бонуси'),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: 'Профіль'),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(icon: Icon(CupertinoIcons.home), label: Text('Дашборд')),
                NavigationRailDestination(icon: Icon(CupertinoIcons.placemark), label: Text('Центри')),
                NavigationRailDestination(icon: Icon(CupertinoIcons.flame), label: Text('Квести')),
                NavigationRailDestination(icon: Icon(CupertinoIcons.gift), label: Text('Бонуси')),
                NavigationRailDestination(icon: Icon(CupertinoIcons.person), label: Text('Профіль')),
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
  }
}