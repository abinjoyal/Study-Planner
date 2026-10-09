import 'package:flutter/material.dart';

import '../../domain/entities/study_task.dart';
import 'task_item_card.dart';

class TodayTasksSection extends StatelessWidget {
  final List<StudyTask> tasks;
  final Function(String taskId) onToggleTask;
  final VoidCallback? onSeeAllTap;

  const TodayTasksSection({
    super.key,
    required this.tasks,
    required this.onToggleTask,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row: Today's Tasks & See All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today's Tasks",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            TextButton(
              onPressed: onSeeAllTap ?? () {},
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // List of Task Cards
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskItemCard(
              task: task,
              onToggleStatus: () => onToggleTask(task.id),
            );
          },
        ),
      ],
    );
  }
}
