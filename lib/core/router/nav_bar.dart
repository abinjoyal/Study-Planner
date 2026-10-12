import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyplanner/features/focus/presentation/pages/focus_page.dart';
import 'package:studyplanner/features/home/presentation/pages/home_page.dart';
import 'package:studyplanner/features/home/presentation/providers/home_provider.dart';
import 'package:studyplanner/features/planner/presentation/pages/planner_page.dart';
import 'package:studyplanner/features/profile/presentation/pages/profile_page.dart';
import 'package:studyplanner/features/progress/presentation/pages/progress_page.dart';

class MainNavBar extends ConsumerWidget {
  const MainNavBar({super.key});

  static const List<Widget> _pages = [
    HomePage(),
    PlannerPage(),
    FocusPage(),
    ProgressPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(
      homeNotifierProvider.select((state) => state.selectedNavIndex),
    );
    final notifier = ref.read(homeNotifierProvider.notifier);

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) => notifier.setNavIndex(index),
      ),
    );
  }
}

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItemData(
        label: 'Home',
        icon: Icons.home_filled,
        activeIcon: Icons.home_filled,
      ),
      _NavItemData(
        label: 'Planner',
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_month_rounded,
      ),
      _NavItemData(
        label: 'Focus',
        icon: Icons.timer_outlined,
        activeIcon: Icons.timer,
      ),
      _NavItemData(
        label: 'Progress',
        icon: Icons.bar_chart_rounded,
        activeIcon: Icons.bar_chart_rounded,
      ),
      _NavItemData(
        label: 'Profile',
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = selectedIndex == index;
              final item = items[index];
              return InkWell(
                onTap: () => onItemTapped(index),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        color: isSelected
                            ? const Color(0xFFF95700)
                            : const Color(0xFF94A3B8),
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFFF95700)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItemData({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
