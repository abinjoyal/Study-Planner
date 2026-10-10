import '../entities/planner_day.dart';
import '../entities/study_session.dart';

abstract class PlannerRepository {
  Future<List<StudySession>> getStudySessions(DateTime date);
  Future<void> addStudySession(StudySession session);
  Future<void> updateStudySession(StudySession session);
  Future<void> deleteStudySession(String sessionId);
  Future<List<PlannerDay>> getWeeklySchedule(DateTime startDate);
}
