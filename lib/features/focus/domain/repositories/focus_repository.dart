import '../entities/focus_session.dart';

abstract class FocusRepository {
  Future<void> saveFocusSession(FocusSession session);
  Future<List<FocusSession>> getFocusHistory();
  Future<Map<String, dynamic>> getTodayFocusStats();
  Future<void> updateFocusSettings({
    required int focusMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
  });
}
