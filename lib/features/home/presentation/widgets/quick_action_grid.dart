import 'package:flutter/material.dart';
import 'quick_action_item.dart';

class QuickActionGrid extends StatelessWidget {
  final VoidCallback? onAddSubject;
  final VoidCallback? onCreatePlan;
  final VoidCallback? onFocusTimer;
  final VoidCallback? onViewSyllabus;

  const QuickActionGrid({
    super.key,
    this.onAddSubject,
    this.onCreatePlan,
    this.onFocusTimer,
    this.onViewSyllabus,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      QuickActionItemData(
        title: 'Add\nSubject',
        icon: Icons.menu_book_rounded,
        iconColor: const Color(0xFF2563EB),
        backgroundColor: const Color(0xFFEFF6FF),
        onTap: onAddSubject ?? () {},
      ),
      QuickActionItemData(
        title: 'Create\nPlan',
        icon: Icons.calendar_month_rounded,
        iconColor: const Color(0xFFF95700),
        backgroundColor: const Color(0xFFFFF7ED),
        onTap: onCreatePlan ?? () {},
      ),
      QuickActionItemData(
        title: 'Focus\nTimer',
        icon: Icons.timer_outlined,
        iconColor: const Color(0xFF10B981),
        backgroundColor: const Color(0xFFF0FDF4),
        onTap: onFocusTimer ?? () {},
      ),
      QuickActionItemData(
        title: 'View\nSyllabus',
        icon: Icons.description_outlined,
        iconColor: const Color(0xFF9333EA),
        backgroundColor: const Color(0xFFFAF5FF),
        onTap: onViewSyllabus ?? () {},
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return QuickActionItem(data: items[index]);
      },
    );
  }
}
