class ProgressSummary {
  final int totalStudyMinutes;
  final int totalTasksCount;
  final int completedTasksCount;
  final double completionPercentage; // 0.0 to 100.0
  final double weeklyGoalPercentage; // 0.0 to 100.0 (capped at 100.0)
  final String dailyAverageFormatted;

  const ProgressSummary({
    required this.totalStudyMinutes,
    required this.totalTasksCount,
    required this.completedTasksCount,
    required this.completionPercentage,
    required this.weeklyGoalPercentage,
    required this.dailyAverageFormatted,
  });

  String get totalStudyTimeFormatted {
    final hours = totalStudyMinutes ~/ 60;
    final mins = totalStudyMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }

  ProgressSummary copyWith({
    int? totalStudyMinutes,
    int? totalTasksCount,
    int? completedTasksCount,
    double? completionPercentage,
    double? weeklyGoalPercentage,
    String? dailyAverageFormatted,
  }) {
    return ProgressSummary(
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      totalTasksCount: totalTasksCount ?? this.totalTasksCount,
      completedTasksCount: completedTasksCount ?? this.completedTasksCount,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      weeklyGoalPercentage: weeklyGoalPercentage ?? this.weeklyGoalPercentage,
      dailyAverageFormatted: dailyAverageFormatted ?? this.dailyAverageFormatted,
    );
  }
}
