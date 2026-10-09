import '../repositories/home_repository.dart';

class UpdateTaskStatus {
  final HomeRepository repository;

  UpdateTaskStatus(this.repository);

  Future<void> call({
    required String taskId,
    required bool isCompleted,
  }) async {
    return await repository.updateTaskStatus(taskId, isCompleted);
  }
}
