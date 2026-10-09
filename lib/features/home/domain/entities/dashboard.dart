import 'study_task.dart';

class Dashboard {
  final String studentName;
  final int completedTasksCount;
  final int totalTasksCount;
  final List<StudyTask> todayTasks;
  final bool hasUnreadNotifications;

  const Dashboard({
    required this.studentName,
    required this.completedTasksCount,
    required this.totalTasksCount,
    required this.todayTasks,
    required this.hasUnreadNotifications,
  });

  double get progressPercentage =>
      totalTasksCount > 0 ? (completedTasksCount / totalTasksCount) : 0.0;

  Dashboard copyWith({
    String? studentName,
    int? completedTasksCount,
    int? totalTasksCount,
    List<StudyTask>? todayTasks,
    bool? hasUnreadNotifications,
  }) {
    return Dashboard(
      studentName: studentName ?? this.studentName,
      completedTasksCount: completedTasksCount ?? this.completedTasksCount,
      totalTasksCount: totalTasksCount ?? this.totalTasksCount,
      todayTasks: todayTasks ?? this.todayTasks,
      hasUnreadNotifications:
          hasUnreadNotifications ?? this.hasUnreadNotifications,
    );
  }
}
