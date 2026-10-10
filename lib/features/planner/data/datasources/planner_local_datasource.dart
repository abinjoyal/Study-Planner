import '../models/study_session_model.dart';

abstract class PlannerLocalDataSource {
  Future<List<StudySessionModel>> getCachedSessions();
  Future<void> cacheSessions(List<StudySessionModel> sessions);
}

class PlannerLocalDataSourceImpl implements PlannerLocalDataSource {
  final List<StudySessionModel> _cached = [];

  @override
  Future<List<StudySessionModel>> getCachedSessions() async {
    return List.from(_cached);
  }

  @override
  Future<void> cacheSessions(List<StudySessionModel> sessions) async {
    _cached.clear();
    _cached.addAll(sessions);
  }
}
