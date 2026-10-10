import '../models/planner_day_model.dart';
import '../models/study_session_model.dart';
import '../../domain/entities/study_session.dart';

abstract class PlannerRemoteDataSource {
  Future<List<StudySessionModel>> getStudySessions(DateTime date);
  Future<void> addStudySession(StudySessionModel session);
  Future<void> updateStudySession(StudySessionModel session);
  Future<void> deleteStudySession(String sessionId);
  Future<List<PlannerDayModel>> getWeeklySchedule(DateTime startDate);
}

class PlannerRemoteDataSourceImpl implements PlannerRemoteDataSource {
  final List<StudySessionModel> _mockSessions = [
    StudySessionModel(
      id: '1',
      title: 'Maths',
      subtitle: 'Chapter 4 - Exercises',
      timeLabel: '08:00',
      duration: '1h',
      subjectType: SubjectType.maths,
      date: DateTime.now(),
    ),
    StudySessionModel(
      id: '2',
      title: 'Physics',
      subtitle: 'Watch lecture',
      timeLabel: '10:00',
      duration: '1h',
      subjectType: SubjectType.physics,
      date: DateTime.now(),
    ),
    StudySessionModel(
      id: '3',
      title: 'Break',
      subtitle: 'Rest and relax',
      timeLabel: '12:00',
      duration: '30m',
      subjectType: SubjectType.breakTime,
      date: DateTime.now(),
    ),
    StudySessionModel(
      id: '4',
      title: 'Chemistry',
      subtitle: 'Make short notes',
      timeLabel: '01:00',
      duration: '1h',
      subjectType: SubjectType.chemistry,
      date: DateTime.now(),
    ),
    StudySessionModel(
      id: '5',
      title: 'English',
      subtitle: 'Practice questions',
      timeLabel: '03:00',
      duration: '1h',
      subjectType: SubjectType.english,
      date: DateTime.now(),
    ),
    StudySessionModel(
      id: '6',
      title: 'Revision',
      subtitle: 'Revise today\'s topics',
      timeLabel: '05:00',
      duration: '1h',
      subjectType: SubjectType.revision,
      date: DateTime.now(),
    ),
  ];

  @override
  Future<List<StudySessionModel>> getStudySessions(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockSessions);
  }

  @override
  Future<void> addStudySession(StudySessionModel session) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockSessions.add(session);
  }

  @override
  Future<void> updateStudySession(StudySessionModel session) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _mockSessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      _mockSessions[index] = session;
    }
  }

  @override
  Future<void> deleteStudySession(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockSessions.removeWhere((s) => s.id == sessionId);
  }

  @override
  Future<List<PlannerDayModel>> getWeeklySchedule(DateTime startDate) async {
    await Future.delayed(const Duration(milliseconds: 150));
    // Generate 7 days (Mon-Sun around date)
    final monday = startDate.subtract(Duration(days: startDate.weekday - 1));
    return List.generate(7, (i) {
      final date = monday.add(Duration(days: i));
      return PlannerDayModel.fromDate(
        date,
        isSelected: date.year == startDate.year &&
            date.month == startDate.month &&
            date.day == startDate.day,
      );
    });
  }
}
