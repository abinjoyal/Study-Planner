import 'package:flutter/material.dart';
import '../models/progress_summary_model.dart';
import '../models/study_streak_model.dart';
import '../models/subject_progress_model.dart';
import '../../domain/repositories/progress_repository.dart';

abstract class ProgressLocalDataSource {
  Future<ProgressSummaryModel> getSummary(ProgressPeriod period, {DateTime? customDate});
  Future<List<SubjectProgressModel>> getSubjectProgress(ProgressPeriod period, {DateTime? customDate});
  Future<StudyStreakModel> getStreak();
  Future<double> getWeeklyGoalPercentage();
}

class ProgressLocalDataSourceImpl implements ProgressLocalDataSource {
  final List<SubjectProgressModel> _mockSubjects = [
    const SubjectProgressModel(
      id: '1',
      subjectName: 'Maths',
      completedTasks: 8,
      totalTasks: 10,
      studyMinutes: 320,
      themeColor: Color(0xFF3B82F6),
    ),
    const SubjectProgressModel(
      id: '2',
      subjectName: 'Physics',
      completedTasks: 6,
      totalTasks: 8,
      studyMinutes: 240,
      themeColor: Color(0xFFA855F7),
    ),
    const SubjectProgressModel(
      id: '3',
      subjectName: 'Chemistry',
      completedTasks: 5,
      totalTasks: 7,
      studyMinutes: 210,
      themeColor: Color(0xFFF59E0B),
    ),
    const SubjectProgressModel(
      id: '4',
      subjectName: 'English',
      completedTasks: 4,
      totalTasks: 5,
      studyMinutes: 150,
      themeColor: Color(0xFF10B981),
    ),
  ];

  @override
  Future<ProgressSummaryModel> getSummary(ProgressPeriod period, {DateTime? customDate}) async {
    int totalTasks = 0;
    int completedTasks = 0;
    int totalMinutes = 0;

    for (var s in _mockSubjects) {
      totalTasks += s.totalTasks;
      completedTasks += s.completedTasks;
      totalMinutes += s.studyMinutes;
    }

    double multiplier = 1.0;
    if (customDate != null) {
      // Deterministic variation based on selected date's day of month
      multiplier = 0.25 + ((customDate.day % 5) * 0.15);
    } else {
      if (period == ProgressPeriod.thisMonth) multiplier = 3.2;
      if (period == ProgressPeriod.allTime) multiplier = 8.5;
    }

    final adjustedTasks = (totalTasks * multiplier).round().clamp(1, 999);
    final adjustedCompleted = (completedTasks * multiplier).round().clamp(0, adjustedTasks);
    final adjustedMinutes = (totalMinutes * multiplier).round().clamp(0, 99999);

    double completionPercentage = adjustedTasks > 0
        ? ((adjustedCompleted / adjustedTasks) * 100).clamp(0.0, 100.0)
        : 0.0;

    // Weekly Target e.g., 20 hours (1200 mins)
    const int weeklyTargetMinutes = 1200;
    double weeklyGoalPct =
        ((adjustedMinutes / weeklyTargetMinutes) * 100).clamp(0.0, 100.0);

    int avgDailyMins = (adjustedMinutes / (customDate != null ? 1 : 7)).round();
    int avgHours = avgDailyMins ~/ 60;
    int avgMins = avgDailyMins % 60;
    String dailyAvgStr = avgHours > 0 ? '${avgHours}h ${avgMins}m' : '${avgMins}m';

    return ProgressSummaryModel(
      totalStudyMinutes: adjustedMinutes,
      totalTasksCount: adjustedTasks,
      completedTasksCount: adjustedCompleted,
      completionPercentage: double.parse(completionPercentage.toStringAsFixed(1)),
      weeklyGoalPercentage: double.parse(weeklyGoalPct.toStringAsFixed(1)),
      dailyAverageFormatted: dailyAvgStr,
    );
  }

  @override
  Future<List<SubjectProgressModel>> getSubjectProgress(
      ProgressPeriod period, {DateTime? customDate}) async {
    if (customDate == null) return List.from(_mockSubjects);

    final factor = 0.5 + ((customDate.day % 4) * 0.2);
    return _mockSubjects.map((s) {
      final total = (s.totalTasks * factor).round().clamp(1, 20);
      final completed = (s.completedTasks * factor).round().clamp(0, total);
      final mins = (s.studyMinutes * factor).round();
      return SubjectProgressModel(
        id: s.id,
        subjectName: s.subjectName,
        completedTasks: completed,
        totalTasks: total,
        studyMinutes: mins,
        themeColor: s.themeColor,
      );
    }).toList();
  }

  @override
  Future<StudyStreakModel> getStreak() async {
    final now = DateTime.now();
    // Timezone-aware date normalization (stripping hours/mins)
    final todayNormalized = DateTime(now.year, now.month, now.day);

    final qualifyingDates = List.generate(7, (i) {
      return todayNormalized.subtract(Duration(days: i));
    });

    return StudyStreakModel(
      currentStreakDays: 7,
      longestStreakDays: 14,
      qualifyingDates: qualifyingDates,
    );
  }

  @override
  Future<double> getWeeklyGoalPercentage() async {
    return 85.0; // 85% completed of weekly goal
  }
}
