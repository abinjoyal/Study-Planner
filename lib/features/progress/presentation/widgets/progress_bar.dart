import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double percentage; // 0.0 to 100.0
  final Color fillColor;
  final double height;

  const ProgressBar({
    super.key,
    required this.percentage,
    required this.fillColor,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final clampedPct = (percentage / 100).clamp(0.0, 1.0);

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: fillColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              width: constraints.maxWidth * clampedPct,
              height: height,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          );
        },
      ),
    );
  }
}
