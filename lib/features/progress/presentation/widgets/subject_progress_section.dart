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
