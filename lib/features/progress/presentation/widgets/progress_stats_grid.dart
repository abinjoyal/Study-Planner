import 'package:flutter/material.dart';
import '../../domain/entities/progress_summary.dart';
import 'progress_stat_card.dart';

class ProgressStatsGrid extends StatelessWidget {
  final ProgressSummary summary;

  const ProgressStatsGrid({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ProgressStatCard(
                icon: Icons.timer_outlined,
                iconColor: const Color(0xFF2563EB),
                iconBgColor: const Color(0xFFEFF6FF),
                title: 'Total Study',
                value: summary.totalStudyTimeFormatted,
                subtitle: 'Focus hours',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ProgressStatCard(
                icon: Icons.check_circle_outline_rounded,
                iconColor: const Color(0xFF10B981),
                iconBgColor: const Color(0xFFECFDF5),
                title: 'Tasks Done',
                value: '${summary.completedTasksCount}/${summary.totalTasksCount}',
                subtitle: 'Completed',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: ProgressStatCard(
                icon: Icons.pie_chart_outline_rounded,
                iconColor: const Color(0xFFA855F7),
                iconBgColor: const Color(0xFFF3E8FF),
                title: 'Completion Rate',
                value: '${summary.completionPercentage}%',
                subtitle: 'Efficiency',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ProgressStatCard(
                icon: Icons.speed_rounded,
                iconColor: const Color(0xFFFF6E1F),
                iconBgColor: const Color(0xFFFFF1F0),
                title: 'Daily Average',
                value: summary.dailyAverageFormatted,
                subtitle: 'Per day',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
