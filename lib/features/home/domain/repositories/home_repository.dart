import '../entities/dashboard.dart';
import '../entities/study_task.dart';

abstract class HomeRepository {
  Future<Dashboard> getDashboard();
  Future<List<StudyTask>> getTodayTasks();
  Future<void> updateTaskStatus(String taskId, bool isCompleted);
}
