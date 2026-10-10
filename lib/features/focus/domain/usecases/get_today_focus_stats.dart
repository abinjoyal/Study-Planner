import '../repositories/focus_repository.dart';

class GetTodayFocusStats {
  final FocusRepository repository;

  GetTodayFocusStats(this.repository);

  Future<Map<String, dynamic>> call() {
    return repository.getTodayFocusStats();
  }
}
