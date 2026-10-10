import 'package:flutter/material.dart';
import '../../domain/entities/subject_progress.dart';
import 'progress_bar.dart';

class SubjectProgressCard extends StatelessWidget {
  final SubjectProgress subject;
  final VoidCallback? onTap;

  const SubjectProgressCard({
    super.key,
    required this.subject,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: subject.themeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _getSubjectIcon(subject.subjectName),
                    color: subject.themeColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.subjectName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1B1C4B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${subject.completedTasks}/${subject.totalTasks} tasks • ${subject.studyTimeFormatted}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8E9BBD),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${subject.completionPercentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: subject.themeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ProgressBar(
              percentage: subject.completionPercentage,
              fillColor: subject.themeColor,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSubjectIcon(String name) {
    switch (name.toLowerCase()) {
      case 'maths':
      case 'math':
        return Icons.menu_book_rounded;
      case 'physics':
        return Icons.hub_rounded;
      case 'chemistry':
        return Icons.science_rounded;
      case 'english':
        return Icons.auto_stories_rounded;
      default:
        return Icons.school_rounded;
    }
  }
}
