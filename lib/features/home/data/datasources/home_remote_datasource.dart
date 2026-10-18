import '../models/dashboard_model.dart';
import '../models/task_model.dart';

abstract class HomeRemoteDataSource {
  Future<DashboardModel> fetchDashboardData();
  Future<List<TaskModel>> fetchTodayTasks();
  Future<void> updateTaskCompletionStatus(String taskId, bool isCompleted);
  Future<void> addTask(TaskModel task);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  List<TaskModel> _mockTasks = [];

  @override
  Future<DashboardModel> fetchDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final completedCount = _mockTasks.where((t) => t.isCompleted).length;
    return DashboardModel(
      studentName: 'Student',
      completedTasksCount: completedCount,
      totalTasksCount: _mockTasks.length,
      todayTasks: List.unmodifiable(_mockTasks),
      hasUnreadNotifications: false,
    );
  }

  @override
  Future<List<TaskModel>> fetchTodayTasks() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockTasks;
  }

  @override
  Future<void> updateTaskCompletionStatus(
      String taskId, bool isCompleted) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _mockTasks = _mockTasks.map((t) {
      if (t.id == taskId) {
        return TaskModel(
          id: t.id,
          title: t.title,
          description: t.description,
          iconSymbol: t.iconSymbol,
          iconBackgroundColor: t.iconBackgroundColor,
          isCompleted: isCompleted,
          statusTag: t.statusTag,
          estimatedTime: t.estimatedTime,
        );
      }
      return t;
    }).toList();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _mockTasks.add(task);
  }
}
