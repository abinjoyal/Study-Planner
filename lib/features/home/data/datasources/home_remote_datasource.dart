import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';
import '../models/task_model.dart';

abstract class HomeRemoteDataSource {
  Future<DashboardModel> fetchDashboardData();
  Future<List<TaskModel>> fetchTodayTasks();
  Future<void> updateTaskCompletionStatus(String taskId, bool isCompleted);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  // Mock data matching the design screenshot
  List<TaskModel> _mockTasks = [
    const TaskModel(
      id: '1',
      title: 'Maths - Chapter 4',
      description: 'Complete exercises 1-10',
      iconSymbol: 'Σ',
      iconBackgroundColor: Color(0xFF3B82F6),
      isCompleted: true,
      statusTag: 'In Progress',
    ),
    const TaskModel(
      id: '2',
      title: 'Physics - Notes Review',
      description: 'Read and make short notes',
      iconSymbol: '⚛',
      iconBackgroundColor: Color(0xFFA855F7),
      isCompleted: false,
      estimatedTime: '2h',
    ),
    const TaskModel(
      id: '3',
      title: 'English - Practice',
      description: 'Solve previous year questions',
      iconSymbol: '📖',
      iconBackgroundColor: Color(0xFF10B981),
      isCompleted: false,
      estimatedTime: '1h',
    ),
    const TaskModel(
      id: '4',
      title: 'Chemistry - Chapter 3',
      description: 'Watch lecture and make notes',
      iconSymbol: '🧪',
      iconBackgroundColor: Color(0xFFF59E0B),
      isCompleted: false,
      estimatedTime: '1h',
    ),
  ];

  @override
  Future<DashboardModel> fetchDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final completedCount = _mockTasks.where((t) => t.isCompleted).length;
    return DashboardModel(
      studentName: 'Student',
      completedTasksCount: completedCount,
      totalTasksCount: 6,
      todayTasks: _mockTasks,
      hasUnreadNotifications: true,
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
}
