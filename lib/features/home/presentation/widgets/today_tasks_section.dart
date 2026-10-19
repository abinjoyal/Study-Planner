import 'package:flutter/material.dart';

import '../../domain/entities/study_task.dart';
import 'task_item_card.dart';

class TodayTasksSection extends StatelessWidget {
  final List<StudyTask> tasks;
  final Function(String taskId) onToggleTask;
  final VoidCallback? onAddTask;
  final VoidCallback? onSeeAllTap;

  const TodayTasksSection({
    super.key,
    required this.tasks,
    required this.onToggleTask,
    this.onAddTask,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row: Today's Tasks & Actions
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
            Row(
              children: [
                if (onAddTask != null)
                  TextButton.icon(
                    onPressed: onAddTask,
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 18,
                      color: Color(0xFFF95700),
                    ),
                    label: const Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF95700),
                      ),
                    ),
                  ),
                if (tasks.isNotEmpty)
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
          ],
        ),
        const SizedBox(height: 8),

        // List of Task Cards or Empty State
        if (tasks.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    color: Color(0xFFF95700),
                    size: 26,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'No Tasks for Today',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  onAddTask != null
                      ? 'Tap "+ Add" to add your first study task!'
                      : 'No tasks scheduled for this day',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
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
