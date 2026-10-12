import 'package:flutter/material.dart';
import '../../../../core/router/nav_bar.dart';

/// Legacy wrapper redirecting to the centralized [CustomNavBar] in `core/router/nav_bar.dart`.
class HomeBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const HomeBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return CustomNavBar(
      selectedIndex: selectedIndex,
      onItemTapped: onItemTapped,
    );
  }
}
