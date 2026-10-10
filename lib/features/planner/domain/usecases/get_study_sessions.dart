import '../entities/study_session.dart';
import '../repositories/planner_repository.dart';

class GetStudySessions {
  final PlannerRepository repository;

  GetStudySessions(this.repository);

  Future<List<StudySession>> call(DateTime date) {
    return repository.getStudySessions(date);
  }
}
