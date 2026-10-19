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
  final List<StudySessionModel> _mockSessions = [];

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
    final now = DateTime.now();
    final centerDate = DateTime(now.year, now.month, now.day);
    final firstDay = centerDate.subtract(const Duration(days: 3));
    return List.generate(7, (i) {
      final date = firstDay.add(Duration(days: i));
      return PlannerDayModel.fromDate(
        date,
        isSelected:
            date.year == startDate.year &&
            date.month == startDate.month &&
            date.day == startDate.day,
      );
    });
  }
}
