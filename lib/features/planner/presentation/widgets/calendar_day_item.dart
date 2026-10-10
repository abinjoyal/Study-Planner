import 'package:flutter/material.dart';

class CalendarDayItem extends StatelessWidget {
  final String dayName;
  final int dayNumber;
  final bool isSelected;
  final VoidCallback onTap;

  const CalendarDayItem({
    super.key,
    required this.dayName,
    required this.dayNumber,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 44,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6E1F) : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(22),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF6E1F).withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF8E9BBD),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$dayNumber',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : const Color(0xFF1B1C4B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
