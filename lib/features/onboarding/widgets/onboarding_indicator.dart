import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) {
          final isActive = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            height: 8,
            width: isActive ? 22 : 8,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFF95700)
                  : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}
