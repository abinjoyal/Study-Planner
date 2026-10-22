import 'package:flutter/material.dart';
import '../../domain/entities/subject_progress.dart';
import 'subject_progress_card.dart';

class SubjectProgressSection extends StatelessWidget {
  final List<SubjectProgress> subjects;
  final VoidCallback? onSeeAllTap;
  final ValueChanged<SubjectProgress>? onSubjectTap;

  const SubjectProgressSection({
    super.key,
    required this.subjects,
    this.onSeeAllTap,
    this.onSubjectTap,
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
              'Subject Progress',
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
        if (subjects.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: const Center(
              child: Text(
                'No subject sessions yet.\nAdd a session in Planner to track your progress!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subjects.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = subjects[index];
              return SubjectProgressCard(
                subject: item,
                onTap: () => onSubjectTap?.call(item),
              );
            },
          ),
      ],
    );
  }
}
