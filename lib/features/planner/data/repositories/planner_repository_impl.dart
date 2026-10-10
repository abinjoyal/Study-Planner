import '../datasources/planner_local_datasource.dart';
import '../datasources/planner_remote_datasource.dart';
import '../models/study_session_model.dart';
import '../../domain/entities/planner_day.dart';
import '../../domain/entities/study_session.dart';
import '../../domain/repositories/planner_repository.dart';

class PlannerRepositoryImpl implements PlannerRepository {
  final PlannerRemoteDataSource remoteDataSource;
  final PlannerLocalDataSource localDataSource;

  PlannerRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<StudySession>> getStudySessions(DateTime date) async {
    try {
      final remoteSessions = await remoteDataSource.getStudySessions(date);
      await localDataSource.cacheSessions(remoteSessions);
      return remoteSessions;
    } catch (_) {
      final cached = await localDataSource.getCachedSessions();
      return cached;
    }
  }

  @override
  Future<void> addStudySession(StudySession session) async {
    final model = StudySessionModel.fromEntity(session);
    await remoteDataSource.addStudySession(model);
  }

  @override
  Future<void> updateStudySession(StudySession session) async {
    final model = StudySessionModel.fromEntity(session);
    await remoteDataSource.updateStudySession(model);
  }

  @override
  Future<void> deleteStudySession(String sessionId) async {
    await remoteDataSource.deleteStudySession(sessionId);
  }

  @override
  Future<List<PlannerDay>> getWeeklySchedule(DateTime startDate) async {
    return await remoteDataSource.getWeeklySchedule(startDate);
  }
}
