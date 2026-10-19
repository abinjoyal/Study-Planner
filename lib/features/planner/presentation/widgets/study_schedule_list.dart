import 'package:flutter/material.dart';
import '../../domain/entities/study_session.dart';
import 'session_time_label.dart';
import 'study_session_card.dart';

class StudyScheduleList extends StatelessWidget {
  final List<StudySession> sessions;
  final ValueChanged<StudySession>? onEditSession;
  final ValueChanged<String>? onDeleteSession;

  const StudyScheduleList({
    super.key,
    required this.sessions,
    this.onEditSession,
    this.onDeleteSession,
  });

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                size: 32,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No study sessions scheduled for this day',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sessions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SessionTimeLabel(timeLabel: session.timeLabel),
            const SizedBox(width: 8),
            Expanded(
              child: StudySessionCard(
                session: session,
                onEdit: () => onEditSession?.call(session),
                onDelete: () => onDeleteSession?.call(session.id),
              ),
            ),
          ],
        );
      },
    );
  }
}
