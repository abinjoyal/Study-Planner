import 'package:studyplanner/features/home/data/models/task_model.dart';

import '../../domain/entities/dashboard.dart';
import '../../domain/entities/study_task.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Dashboard> getDashboard() async {
    return await remoteDataSource.fetchDashboardData();
  }

  @override
  Future<List<StudyTask>> getTodayTasks() async {
    return await remoteDataSource.fetchTodayTasks();
  }

  @override
  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    await remoteDataSource.updateTaskCompletionStatus(taskId, isCompleted);
  }

  @override
  Future<void> addTask(StudyTask task) async {
    await remoteDataSource.addTask(TaskModel.fromEntity(task));
  }
}
