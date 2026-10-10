import '../repositories/progress_repository.dart';

class GetProgressHistory {
  final ProgressRepository repository;

  GetProgressHistory(this.repository);

  Future<List<Map<String, dynamic>>> call() {
    return repository.getProgressHistory();
  }
}
