import 'package:flutter/material.dart';
import 'package:studyplanner/features/home/presentation/widgets/home_bottom_navigation.dart';

/// Shared Bottom Navigation Wrapper for Profile screen
/// Reuses the app-wide [HomeBottomNavigation] without duplicating navigation logic.
class ProfileBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const ProfileBottomNavigation({
    super.key,
    this.selectedIndex = 4, // Profile tab is index 4
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return HomeBottomNavigation(
      selectedIndex: selectedIndex,
      onItemTapped: onItemTapped,
    );
  }
}
