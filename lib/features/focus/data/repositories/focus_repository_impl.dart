import '../datasources/focus_local_datasource.dart';
import '../datasources/focus_remote_datasource.dart';
import '../models/focus_session_model.dart';
import '../../domain/entities/focus_session.dart';
import '../../domain/repositories/focus_repository.dart';

class FocusRepositoryImpl implements FocusRepository {
  final FocusLocalDataSource localDataSource;
  final FocusRemoteDataSource remoteDataSource;

  FocusRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<void> saveFocusSession(FocusSession session) async {
    final model = FocusSessionModel.fromEntity(session);
    await localDataSource.saveSession(model);
    try {
      await remoteDataSource.syncFocusSession(model);
    } catch (_) {}
  }

  @override
  Future<List<FocusSession>> getFocusHistory() async {
    return await localDataSource.getHistory();
  }

  @override
  Future<Map<String, dynamic>> getTodayFocusStats() async {
    return await localDataSource.getTodayStats();
  }

  @override
  Future<void> updateFocusSettings({
    required int focusMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
  }) async {
    await localDataSource.saveSettings(
      focusMinutes: focusMinutes,
      shortBreakMinutes: shortBreakMinutes,
      longBreakMinutes: longBreakMinutes,
    );
  }
}
