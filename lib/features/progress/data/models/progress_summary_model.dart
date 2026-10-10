import '../../domain/entities/progress_summary.dart';

class ProgressSummaryModel extends ProgressSummary {
  const ProgressSummaryModel({
    required super.totalStudyMinutes,
    required super.totalTasksCount,
    required super.completedTasksCount,
    required super.completionPercentage,
    required super.weeklyGoalPercentage,
    required super.dailyAverageFormatted,
  });

  factory ProgressSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProgressSummaryModel(
      totalStudyMinutes: json['total_study_minutes'] as int? ?? 0,
      totalTasksCount: json['total_tasks_count'] as int? ?? 0,
      completedTasksCount: json['completed_tasks_count'] as int? ?? 0,
      completionPercentage:
          (json['completion_percentage'] as num?)?.toDouble() ?? 0.0,
      weeklyGoalPercentage:
          ((json['weekly_goal_percentage'] as num?)?.toDouble() ?? 0.0)
              .clamp(0.0, 100.0),
      dailyAverageFormatted:
          json['daily_average_formatted'] as String? ?? '0h 0m',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_study_minutes': totalStudyMinutes,
      'total_tasks_count': totalTasksCount,
      'completed_tasks_count': completedTasksCount,
      'completion_percentage': completionPercentage,
      'weekly_goal_percentage': weeklyGoalPercentage,
      'daily_average_formatted': dailyAverageFormatted,
    };
  }
}
