import '../entities/focus_session.dart';
import '../repositories/focus_repository.dart';

class SaveFocusSession {
  final FocusRepository repository;

  SaveFocusSession(this.repository);

  Future<void> call(FocusSession session) {
    return repository.saveFocusSession(session);
  }
}
