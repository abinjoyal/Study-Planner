import 'package:flutter/material.dart';

class PlannerHeader extends StatelessWidget {
  final VoidCallback? onCalendarTap;
  final VoidCallback? onAddTap;
  final bool showAddButton;

  const PlannerHeader({
    super.key,
    this.onCalendarTap,
    this.onAddTap,
    this.showAddButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Study Planner',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1B1C4B),
            letterSpacing: -0.5,
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: onCalendarTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 44,
                height: 44,
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
                  size: 20,
                ),
              ),
            ),
            if (showAddButton) ...[
              const SizedBox(width: 10),
              InkWell(
                onTap: onAddTap,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6E1F),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6E1F).withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
