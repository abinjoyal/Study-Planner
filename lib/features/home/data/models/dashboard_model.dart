import '../../domain/entities/dashboard.dart';
import 'task_model.dart';

class DashboardModel extends Dashboard {
  const DashboardModel({
    required super.studentName,
    required super.completedTasksCount,
    required super.totalTasksCount,
    required super.todayTasks,
    required super.hasUnreadNotifications,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      studentName: json['studentName'] as String,
      completedTasksCount: json['completedTasksCount'] as int,
      totalTasksCount: json['totalTasksCount'] as int,
      todayTasks: (json['todayTasks'] as List<dynamic>)
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasUnreadNotifications: json['hasUnreadNotifications'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentName': studentName,
      'completedTasksCount': completedTasksCount,
      'totalTasksCount': totalTasksCount,
      'todayTasks':
          todayTasks.map((t) => TaskModel.fromEntity(t).toJson()).toList(),
      'hasUnreadNotifications': hasUnreadNotifications,
    };
  }
}
