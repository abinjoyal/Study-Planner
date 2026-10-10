import 'package:flutter/material.dart';

import 'focus_stats_card.dart';

class TodayFocusSection extends StatelessWidget {
  final String totalFocusFormatted;
  final int sessionCount;
  final VoidCallback? onSeeAllTap;

  const TodayFocusSection({
    super.key,
    required this.totalFocusFormatted,
    required this.sessionCount,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today's Focus",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B1C4B),
              ),
            ),
            GestureDetector(
              onTap: onSeeAllTap,
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: FocusStatsCard(
                icon: Icons.gps_fixed_rounded,
                iconColor: const Color(0xFF2563EB),
                iconBgColor: const Color(0xFFEFF6FF),
                value: totalFocusFormatted,
                label: 'Total Focus',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: FocusStatsCard(
                icon: Icons.local_fire_department_rounded,
                iconColor: const Color(0xFFEA580C),
                iconBgColor: const Color(0xFFFFF7ED),
                value: '$sessionCount',
                label: 'Sessions',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
