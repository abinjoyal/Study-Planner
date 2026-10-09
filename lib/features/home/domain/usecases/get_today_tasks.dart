import '../entities/study_task.dart';
import '../repositories/home_repository.dart';

class GetTodayTasks {
  final HomeRepository repository;

  GetTodayTasks(this.repository);

  Future<List<StudyTask>> call() async {
    return await repository.getTodayTasks();
  }
}
