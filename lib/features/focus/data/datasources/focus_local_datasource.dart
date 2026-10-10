import '../../domain/entities/focus_session.dart';
import '../models/focus_session_model.dart';

abstract class FocusLocalDataSource {
  Future<void> saveSession(FocusSessionModel session);
  Future<List<FocusSessionModel>> getHistory();
  Future<Map<String, dynamic>> getTodayStats();
  Future<void> saveSettings({
    required int focusMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
  });
  Future<Map<String, int>> getSettings();
}

class FocusLocalDataSourceImpl implements FocusLocalDataSource {
  final List<FocusSessionModel> _history = [
    FocusSessionModel(
      id: '1',
      mode: FocusMode.focus,
      duration: const Duration(minutes: 25),
      startTime: DateTime.now().subtract(const Duration(hours: 3)),
      endTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 35)),
    ),
    FocusSessionModel(
      id: '2',
      mode: FocusMode.focus,
      duration: const Duration(minutes: 25),
      startTime: DateTime.now().subtract(const Duration(hours: 2)),
      endTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 35)),
    ),
    FocusSessionModel(
      id: '3',
      mode: FocusMode.focus,
      duration: const Duration(minutes: 25),
      startTime: DateTime.now().subtract(const Duration(hours: 1)),
      endTime: DateTime.now().subtract(const Duration(minutes: 35)),
    ),
    FocusSessionModel(
      id: '4',
      mode: FocusMode.focus,
      duration: const Duration(minutes: 25),
      startTime: DateTime.now().subtract(const Duration(minutes: 30)),
      endTime: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  int _focusMinutes = 25;
  int _shortBreakMinutes = 5;
  int _longBreakMinutes = 15;

  @override
  Future<void> saveSession(FocusSessionModel session) async {
    _history.insert(0, session);
  }

  @override
  Future<List<FocusSessionModel>> getHistory() async {
    return List.from(_history);
  }

  @override
  Future<Map<String, dynamic>> getTodayStats() async {
    final now = DateTime.now();
    final todaySessions = _history.where((s) {
      return s.startTime.year == now.year &&
          s.startTime.month == now.month &&
          s.startTime.day == now.day &&
          s.mode == FocusMode.focus;
    }).toList();

    int totalSeconds = todaySessions.fold(0, (sum, s) => sum + s.duration.inSeconds);
    int totalMinutes = totalSeconds ~/ 60;
    int hours = totalMinutes ~/ 60;
    int remainingMins = totalMinutes % 60;

    String totalFocusFormatted = hours > 0 ? '${hours}h ${remainingMins}m' : '${remainingMins}m';

    return {
      'totalFocusFormatted': totalFocusFormatted,
      'totalFocusMinutes': totalMinutes,
      'sessionCount': todaySessions.length,
    };
  }

  @override
  Future<void> saveSettings({
    required int focusMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
  }) async {
    _focusMinutes = focusMinutes;
    _shortBreakMinutes = shortBreakMinutes;
    _longBreakMinutes = longBreakMinutes;
  }

  @override
  Future<Map<String, int>> getSettings() async {
    return {
      'focusMinutes': _focusMinutes,
      'shortBreakMinutes': _shortBreakMinutes,
      'longBreakMinutes': _longBreakMinutes,
    };
  }
}
