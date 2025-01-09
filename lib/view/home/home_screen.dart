import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../navigation/dashboard_screen.dart';
import '../navigation/drills/drills_screen.dart';
import '../navigation/leaderboard_screen.dart';
import '../navigation/profile_screen.dart';

// Provider for managing the selected navigation index
final navigationProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationProvider);

    final screens = [
      const DrillsScreen(),
      const DashboardScreen(),
      const LeaderboardScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          height: 65,
          backgroundColor: Colors.white,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            ref.read(navigationProvider.notifier).state = index;
          },
          animationDuration: Duration(milliseconds: 400),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            _buildNavDestination(
              icon: Icons.sports_soccer,
              label: 'Drills',
              isSelected: selectedIndex == 0,
            ),
            _buildNavDestination(
              icon: Icons.dashboard,
              label: 'Dashboard',
              isSelected: selectedIndex == 1,
            ),
            _buildNavDestination(
              icon: Icons.leaderboard,
              label: 'Leaderboard',
              isSelected: selectedIndex == 2,
            ),
            _buildNavDestination(
              icon: Icons.person,
              label: 'Profile',
              isSelected: selectedIndex == 3,
            ),
          ],
        ),
      ),
    );
  }

  NavigationDestination _buildNavDestination({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return NavigationDestination(
      icon: Icon(
        icon,
        color: isSelected ? primaryPurple : Colors.grey,
        size: 24,
      ),
      label: label,
      selectedIcon: Icon(
        icon,
        color: primaryPurple,
        size: 24,
      ),
    );
  }
}
