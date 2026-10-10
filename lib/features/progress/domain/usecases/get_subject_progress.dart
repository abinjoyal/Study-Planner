import '../entities/subject_progress.dart';
import '../repositories/progress_repository.dart';

class GetSubjectProgress {
  final ProgressRepository repository;

  GetSubjectProgress(this.repository);

  Future<List<SubjectProgress>> call(ProgressPeriod period, {DateTime? customDate}) {
    return repository.getSubjectProgress(period, customDate: customDate);
  }
}
