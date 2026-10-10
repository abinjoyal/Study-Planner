import '../entities/study_session.dart';
import '../repositories/planner_repository.dart';

class UpdateStudySession {
  final PlannerRepository repository;

  UpdateStudySession(this.repository);

  Future<void> call(StudySession session) {
    return repository.updateStudySession(session);
  }
}
