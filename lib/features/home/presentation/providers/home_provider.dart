import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/dashboard.dart';
import '../../domain/entities/study_task.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/get_dashboard.dart';
import '../../domain/usecases/update_task_status.dart';
import 'home_state.dart';

// Dependency Injection Providers
final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSourceImpl();
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final remoteDataSource = ref.watch(homeRemoteDataSourceProvider);
  return HomeRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getDashboardUseCaseProvider = Provider<GetDashboard>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetDashboard(repository);
});

final updateTaskStatusUseCaseProvider = Provider<UpdateTaskStatus>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return UpdateTaskStatus(repository);
});

final addTaskUseCaseProvider = Provider<AddTask>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return AddTask(repository);
});

// Main Home StateNotifier & Provider
class HomeNotifier extends StateNotifier<HomeState> {
  final GetDashboard getDashboardUseCase;
  final UpdateTaskStatus updateTaskStatusUseCase;
  final AddTask addTaskUseCase;

  HomeNotifier({
    required this.getDashboardUseCase,
    required this.updateTaskStatusUseCase,
    required this.addTaskUseCase,
  }) : super(const HomeState()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true);
    try {
      final dashboard = await getDashboardUseCase();
      state = state.copyWith(
        isLoading: false,
        dashboard: dashboard,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> addTask(StudyTask task) async {
    final currentDashboard = state.dashboard;
    final updatedTasks = [
      if (currentDashboard != null) ...currentDashboard.todayTasks,
      task,
    ];
    final completedCount = updatedTasks.where((t) => t.isCompleted).length;

    state = state.copyWith(
      dashboard: currentDashboard?.copyWith(
            todayTasks: updatedTasks,
            totalTasksCount: updatedTasks.length,
            completedTasksCount: completedCount,
          ) ??
          Dashboard(
            studentName: 'Student',
            completedTasksCount: completedCount,
            totalTasksCount: updatedTasks.length,
            todayTasks: updatedTasks,
            hasUnreadNotifications: false,
          ),
    );

    try {
      await addTaskUseCase(task);
    } catch (e) {
      loadDashboard();
    }
  }

  Future<void> toggleTaskStatus(String taskId) async {
    final currentDashboard = state.dashboard;
    if (currentDashboard == null) return;

    final tasks = currentDashboard.todayTasks;
    final task = tasks.firstWhere((t) => t.id == taskId);
    final newStatus = !task.isCompleted;

    // Optimistic UI update
    final updatedTasks = tasks.map((t) {
      if (t.id == taskId) {
        return t.copyWith(isCompleted: newStatus);
      }
      return t;
    }).toList();

    final newCompletedCount = updatedTasks.where((t) => t.isCompleted).length;

    state = state.copyWith(
      dashboard: currentDashboard.copyWith(
        todayTasks: updatedTasks,
        completedTasksCount: newCompletedCount,
      ),
    );

    // Call UseCase
    try {
      await updateTaskStatusUseCase(taskId: taskId, isCompleted: newStatus);
    } catch (e) {
      // Revert if error
      loadDashboard();
    }
  }

  void setNavIndex(int index) {
    state = state.copyWith(selectedNavIndex: index);
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }
}

final homeNotifierProvider =
    StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final getDashboard = ref.watch(getDashboardUseCaseProvider);
  final updateTaskStatus = ref.watch(updateTaskStatusUseCaseProvider);
  final addTask = ref.watch(addTaskUseCaseProvider);
  return HomeNotifier(
    getDashboardUseCase: getDashboard,
    updateTaskStatusUseCase: updateTaskStatus,
    addTaskUseCase: addTask,
  );
});
