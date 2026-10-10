import 'package:flutter/material.dart';

class ProgressHeader extends StatelessWidget {
  final VoidCallback? onCalendarTap;

  const ProgressHeader({
    super.key,
    this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'My Progress',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1B1C4B),
            letterSpacing: -0.5,
          ),
        ),
        InkWell(
          onTap: onCalendarTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Color(0xFF1B1C4B),
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}
