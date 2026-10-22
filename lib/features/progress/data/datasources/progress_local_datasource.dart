import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyplanner/features/focus/data/datasources/focus_local_datasource.dart';
import 'package:studyplanner/features/focus/domain/entities/focus_session.dart';
import 'package:studyplanner/features/home/data/datasources/home_remote_datasource.dart';
import 'package:studyplanner/features/home/data/models/task_model.dart';
import 'package:studyplanner/features/planner/data/datasources/planner_remote_datasource.dart';
import 'package:studyplanner/features/planner/domain/entities/study_session.dart';
import '../../domain/repositories/progress_repository.dart';
import '../models/progress_summary_model.dart';
import '../models/study_streak_model.dart';
import '../models/subject_progress_model.dart';

abstract class ProgressLocalDataSource {
  Future<ProgressSummaryModel> getSummary(ProgressPeriod period, {DateTime? customDate});
  Future<List<SubjectProgressModel>> getSubjectProgress(ProgressPeriod period, {DateTime? customDate});
  Future<StudyStreakModel> getStreak();
  Future<double> getWeeklyGoalPercentage();
  Future<List<Map<String, dynamic>>> getProgressHistory({DateTime? weekStartDate});
}

class ProgressLocalDataSourceImpl implements ProgressLocalDataSource {
  final FocusLocalDataSource? focusLocalDataSource;
  final HomeRemoteDataSource? homeRemoteDataSource;
  final PlannerRemoteDataSource? plannerRemoteDataSource;

  ProgressLocalDataSourceImpl({
    this.focusLocalDataSource,
    this.homeRemoteDataSource,
    this.plannerRemoteDataSource,
  });

  @override
  Future<ProgressSummaryModel> getSummary(
    ProgressPeriod period, {
    DateTime? customDate,
  }) async {
    final focusSessions = await _getFocusSessions();
    final tasks = await _getTasks();
    final plannerSessions = await _getPlannerSessions();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 1. Filter focus sessions according to period or customDate
    final filteredSessions = focusSessions.where((s) {
      if (s.mode != FocusMode.focus || !s.isCompleted) return false;
      final sessionDate = DateTime(s.startTime.year, s.startTime.month, s.startTime.day);

      if (customDate != null) {
        final targetDate = DateTime(customDate.year, customDate.month, customDate.day);
        return sessionDate == targetDate;
      }

      switch (period) {
        case ProgressPeriod.thisWeek:
          final monday = today.subtract(Duration(days: now.weekday - 1));
          return !sessionDate.isBefore(monday);
        case ProgressPeriod.thisMonth:
          final startOfMonth = DateTime(now.year, now.month, 1);
          return !sessionDate.isBefore(startOfMonth);
        case ProgressPeriod.allTime:
          return true;
      }
    }).toList();

    // Calculate total study minutes from real sessions
    final totalStudyMinutes = filteredSessions.fold<int>(
      0,
      (int sum, FocusSession s) => sum + s.duration.inMinutes,
    );

    // 2. Real task counts
    final totalTasks = tasks.length + plannerSessions.length;
    final completedTasks = tasks.where((t) => t.isCompleted).length +
        plannerSessions.where((s) => s.isCompleted).length;

    final completionPercentage = totalTasks > 0
        ? ((completedTasks / totalTasks) * 100).clamp(0.0, 100.0)
        : 0.0;

    // 3. Real daily average calculation
    int daysCount;
    if (customDate != null) {
      daysCount = 1;
    } else {
      switch (period) {
        case ProgressPeriod.thisWeek:
          daysCount = now.weekday; // Elapsed days in the current week
          break;
        case ProgressPeriod.thisMonth:
          daysCount = now.day; // Elapsed days in the current month
          break;
        case ProgressPeriod.allTime:
          if (focusSessions.isNotEmpty) {
            final firstDate = focusSessions
                .map((s) => s.startTime)
                .reduce((a, b) => a.isBefore(b) ? a : b);
            daysCount = today.difference(DateTime(firstDate.year, firstDate.month, firstDate.day)).inDays + 1;
          } else {
            daysCount = 1;
          }
          break;
      }
    }
    if (daysCount < 1) daysCount = 1;

    final avgDailyMins = (totalStudyMinutes / daysCount).round();
    final avgHours = avgDailyMins ~/ 60;
    final avgMins = avgDailyMins % 60;
    final dailyAvgStr = avgHours > 0 ? '${avgHours}h ${avgMins}m' : '${avgMins}m';

    // 4. Weekly Goal %
    final weeklyGoalPercentage = await getWeeklyGoalPercentage();

    return ProgressSummaryModel(
      totalStudyMinutes: totalStudyMinutes,
      totalTasksCount: totalTasks,
      completedTasksCount: completedTasks,
      completionPercentage: double.parse(completionPercentage.toStringAsFixed(1)),
      weeklyGoalPercentage: double.parse(weeklyGoalPercentage.toStringAsFixed(1)),
      dailyAverageFormatted: dailyAvgStr,
    );
  }

  @override
  Future<List<SubjectProgressModel>> getSubjectProgress(
    ProgressPeriod period, {
    DateTime? customDate,
  }) async {
    final tasks = await _getTasks();
    final plannerSessions = await _getPlannerSessions();
    final focusSessions = await _getFocusSessions();

    // Build subject map dynamically based on user's active tasks and sessions
    final Map<String, _SubjectDataAccumulator> map = {};

    const palette = [
      Color(0xFF3B82F6),
      Color(0xFFA855F7),
      Color(0xFFF59E0B),
      Color(0xFF10B981),
      Color(0xFFEC4899),
      Color(0xFF06B6D4),
      Color(0xFF8B5CF6),
      Color(0xFFF97316),
    ];

    // Process planner sessions
    for (var session in plannerSessions) {
      final name = _mapSessionToSubject(session);
      if (name == 'Break') continue;
      final acc = map.putIfAbsent(
        name,
        () => _SubjectDataAccumulator(
          id: name,
          name: name,
          color: session.customColor ?? palette[map.length % palette.length],
        ),
      );
      acc.totalTasks++;
      if (session.isCompleted) {
        acc.completedTasks++;
      }
      acc.studyMinutes += _parseDurationString(session.duration);
    }

    // Process tasks
    for (var task in tasks) {
      final name = _mapTaskToSubject(task);
      final acc = map.putIfAbsent(
        name,
        () => _SubjectDataAccumulator(
          id: name,
          name: name,
          color: task.iconBackgroundColor,
        ),
      );
      acc.totalTasks++;
      if (task.isCompleted) {
        acc.completedTasks++;
      }
    }

    // Distribute focus session minutes proportionally to subjects with active study
    final totalFocusMinutes = focusSessions
        .where((s) => s.mode == FocusMode.focus && s.isCompleted)
        .fold<int>(0, (int sum, FocusSession s) => sum + s.duration.inMinutes);

    if (totalFocusMinutes > 0) {
      final activeSubjects = map.values.where((s) => s.totalTasks > 0).toList();
      if (activeSubjects.isNotEmpty) {
        final share = totalFocusMinutes ~/ activeSubjects.length;
        for (var sub in activeSubjects) {
          sub.studyMinutes += share;
        }
      }
    }

    return map.values.map((item) {
      return SubjectProgressModel(
        id: item.id,
        subjectName: item.name,
        completedTasks: item.completedTasks,
        totalTasks: item.totalTasks,
        studyMinutes: item.studyMinutes,
        themeColor: item.color,
      );
    }).toList();
  }

  @override
  Future<StudyStreakModel> getStreak() async {
    final focusSessions = await _getFocusSessions();
    final tasks = await _getTasks();
    final plannerSessions = await _getPlannerSessions();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final Set<String> activityDateKeys = {};

    for (var s in focusSessions) {
      if (s.mode == FocusMode.focus && s.isCompleted) {
        activityDateKeys.add(_dateKey(s.startTime));
      }
    }
    for (var t in tasks) {
      if (t.isCompleted) {
        activityDateKeys.add(_dateKey(today));
      }
    }
    for (var s in plannerSessions) {
      if (s.isCompleted) {
        activityDateKeys.add(_dateKey(s.date));
      }
    }

    final qualifyingDates = <DateTime>[];
    DateTime checkDate = today;

    if (!activityDateKeys.contains(_dateKey(checkDate))) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    while (activityDateKeys.contains(_dateKey(checkDate))) {
      qualifyingDates.add(checkDate);
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    final currentStreak = qualifyingDates.length;

    // Read stored longest streak
    final prefs = await SharedPreferences.getInstance();
    int longest = prefs.getInt('pref_longest_streak') ?? currentStreak;
    if (currentStreak > longest) {
      longest = currentStreak;
      await prefs.setInt('pref_longest_streak', longest);
    }

    return StudyStreakModel(
      currentStreakDays: currentStreak,
      longestStreakDays: longest,
      qualifyingDates: qualifyingDates,
    );
  }

  @override
  Future<double> getWeeklyGoalPercentage() async {
    final prefs = await SharedPreferences.getInstance();
    final weeklyGoalHours = prefs.getInt('pref_weekly_goal_hours') ?? 15;
    final targetMinutes = weeklyGoalHours * 60;
    if (targetMinutes <= 0) return 0.0;

    final focusSessions = await _getFocusSessions();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: now.weekday - 1));

    final weeklyMinutes = focusSessions.where((s) {
      if (s.mode != FocusMode.focus || !s.isCompleted) return false;
      final sessionDate = DateTime(s.startTime.year, s.startTime.month, s.startTime.day);
      return !sessionDate.isBefore(monday);
    }).fold<int>(0, (int sum, FocusSession s) => sum + s.duration.inMinutes);

    return ((weeklyMinutes / targetMinutes) * 100).clamp(0.0, 100.0);
  }

  @override
  Future<List<Map<String, dynamic>>> getProgressHistory({
    DateTime? weekStartDate,
  }) async {
    final focusSessions = await _getFocusSessions();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final monday = weekStartDate != null
        ? DateTime(weekStartDate.year, weekStartDate.month, weekStartDate.day)
        : today.subtract(Duration(days: now.weekday - 1));

    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final List<Map<String, dynamic>> history = [];

    for (int i = 0; i < 7; i++) {
      final targetDate = monday.add(Duration(days: i));
      final dateKey = _dateKey(targetDate);

      final dayMinutes = focusSessions.where((s) {
        if (s.mode != FocusMode.focus || !s.isCompleted) return false;
        return _dateKey(s.startTime) == dateKey;
      }).fold<int>(0, (int sum, FocusSession s) => sum + s.duration.inMinutes);

      history.add({
        'day': dayLabels[i],
        'date': '${targetDate.day}/${targetDate.month}',
        'minutes': dayMinutes,
        'isToday': _dateKey(today) == dateKey,
      });
    }

    return history;
  }

  // --- Helper Methods ---

  Future<List<FocusSession>> _getFocusSessions() async {
    if (focusLocalDataSource == null) return [];
    try {
      return await focusLocalDataSource!.getHistory();
    } catch (_) {
      return [];
    }
  }

  Future<List<TaskModel>> _getTasks() async {
    if (homeRemoteDataSource == null) return [];
    try {
      return await homeRemoteDataSource!.fetchTodayTasks();
    } catch (_) {
      return [];
    }
  }

  Future<List<StudySession>> _getPlannerSessions() async {
    if (plannerRemoteDataSource == null) return [];
    try {
      return await plannerRemoteDataSource!.getStudySessions(DateTime.now());
    } catch (_) {
      return [];
    }
  }

  String _dateKey(DateTime dt) => '${dt.year}-${dt.month}-${dt.day}';

  String _mapTaskToSubject(TaskModel task) {
    final colorVal = task.iconBackgroundColor.toARGB32();
    if (colorVal == const Color(0xFF3B82F6).toARGB32() || task.iconSymbol == 'Σ') {
      return 'Maths';
    }
    if (colorVal == const Color(0xFFA855F7).toARGB32() || task.iconSymbol == '⚛') {
      return 'Physics';
    }
    if (colorVal == const Color(0xFF10B981).toARGB32() || task.iconSymbol == '📖') {
      return 'English';
    }
    if (colorVal == const Color(0xFFF59E0B).toARGB32() || task.iconSymbol == '🧪') {
      return 'Chemistry';
    }
    final lower = task.title.toLowerCase();
    if (lower.contains('math')) return 'Maths';
    if (lower.contains('physic')) return 'Physics';
    if (lower.contains('chem')) return 'Chemistry';
    if (lower.contains('eng')) return 'English';
    return 'General';
  }

  String _mapSessionToSubject(StudySession session) {
    if (session.subjectType == SubjectType.breakTime) {
      return 'Break';
    }
    if (session.title.trim().isNotEmpty) {
      return session.title.trim();
    }
    switch (session.subjectType) {
      case SubjectType.maths:
        return 'Maths';
      case SubjectType.physics:
        return 'Physics';
      case SubjectType.chemistry:
        return 'Chemistry';
      case SubjectType.english:
        return 'English';
      case SubjectType.revision:
        return 'Revision';
      case SubjectType.custom:
      default:
        return 'General';
    }
  }

  int _parseDurationString(String duration) {
    final d = duration.trim().toLowerCase();
    if (d.contains('h')) {
      final parts = d.split('h');
      final hours = int.tryParse(parts[0].trim()) ?? 0;
      final mins = parts.length > 1 && parts[1].contains('m')
          ? int.tryParse(parts[1].replaceAll('m', '').trim()) ?? 0
          : 0;
      return (hours * 60) + mins;
    } else if (d.contains('m')) {
      return int.tryParse(d.replaceAll('m', '').trim()) ?? 0;
    }
    return 0;
  }
}

class _SubjectDataAccumulator {
  final String id;
  final String name;
  final Color color;
  int completedTasks = 0;
  int totalTasks = 0;
  int studyMinutes = 0;

  _SubjectDataAccumulator({
    required this.id,
    required this.name,
    required this.color,
  });
}
