import '../repositories/planner_repository.dart';

class DeleteStudySession {
  final PlannerRepository repository;

  DeleteStudySession(this.repository);

  Future<void> call(String sessionId) {
    return repository.deleteStudySession(sessionId);
  }
}
