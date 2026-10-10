import '../entities/study_streak.dart';
import '../repositories/progress_repository.dart';

class GetStudyStreak {
  final ProgressRepository repository;

  GetStudyStreak(this.repository);

  Future<StudyStreak> call() {
    return repository.getStudyStreak();
  }
}
