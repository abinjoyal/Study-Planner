import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
  static const _historyKey = 'focus_sessions_history';
  static const _settingsKey = 'focus_timer_settings';

  @override
  Future<void> saveSession(FocusSessionModel session) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getHistory();
    list.insert(0, session);
    final jsonList = list.map((s) => s.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  @override
  Future<List<FocusSessionModel>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded
          .map((item) => FocusSessionModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getTodayStats() async {
    final history = await getHistory();
    final now = DateTime.now();
    final todaySessions = history.where((s) {
      return s.startTime.year == now.year &&
          s.startTime.month == now.month &&
          s.startTime.day == now.day &&
          s.mode == FocusMode.focus;
    }).toList();

    int totalSeconds =
        todaySessions.fold(0, (sum, s) => sum + s.duration.inSeconds);
    int totalMinutes = totalSeconds ~/ 60;
    int hours = totalMinutes ~/ 60;
    int remainingMins = totalMinutes % 60;

    String totalFocusFormatted =
        hours > 0 ? '${hours}h ${remainingMins}m' : '${remainingMins}m';

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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _settingsKey,
      jsonEncode({
        'focusMinutes': focusMinutes,
        'shortBreakMinutes': shortBreakMinutes,
        'longBreakMinutes': longBreakMinutes,
      }),
    );
  }

  @override
  Future<Map<String, int>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        return {
          'focusMinutes': decoded['focusMinutes'] as int? ?? 25,
          'shortBreakMinutes': decoded['shortBreakMinutes'] as int? ?? 5,
          'longBreakMinutes': decoded['longBreakMinutes'] as int? ?? 15,
        };
      } catch (_) {}
    }
    return {
      'focusMinutes': 25,
      'shortBreakMinutes': 5,
      'longBreakMinutes': 15,
    };
  }
}
