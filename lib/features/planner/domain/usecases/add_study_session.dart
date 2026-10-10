import '../entities/study_session.dart';
import '../repositories/planner_repository.dart';

class AddStudySession {
  final PlannerRepository repository;

  AddStudySession(this.repository);

  Future<void> call(StudySession session) {
    return repository.addStudySession(session);
  }
}
