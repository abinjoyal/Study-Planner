import '../entities/focus_session.dart';
import '../repositories/focus_repository.dart';

class GetFocusHistory {
  final FocusRepository repository;

  GetFocusHistory(this.repository);

  Future<List<FocusSession>> call() {
    return repository.getFocusHistory();
  }
}
