import 'package:flutter/material.dart';
import '../../domain/entities/study_session.dart';
import 'subject_icon.dart';

class StudySessionCard extends StatelessWidget {
  final StudySession session;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onToggleComplete;

  const StudySessionCard({
    super.key,
    required this.session,
    this.onEdit,
    this.onDelete,
    this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    final style = SubjectIconHelper.getStyle(session.subjectType);

    return Container(
      decoration: BoxDecoration(
        color: style.cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: style.leftAccentColor.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left Accent Strip
              Container(
                width: 5,
                color: style.leftAccentColor,
              ),
              const SizedBox(width: 12),

              // Subject Icon
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: SubjectIcon(
                  subjectType: session.subjectType,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),

              // Title & Subtitle
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        session.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E1B4B),
                          decoration: session.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (session.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          session.subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                            decoration: session.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Menu & Duration
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Color(0xFF94A3B8),
                      size: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit?.call();
                      } else if (value == 'delete') {
                        onDelete?.call();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    session.duration,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
