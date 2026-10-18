import '../entities/study_task.dart';
import '../repositories/home_repository.dart';

class AddTask {
  final HomeRepository repository;

  AddTask(this.repository);

  Future<void> call(StudyTask task) async {
    await repository.addTask(task);
  }
}
