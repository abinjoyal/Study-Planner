import '../entities/progress_summary.dart';
import '../repositories/progress_repository.dart';

class GetProgressSummary {
  final ProgressRepository repository;

  GetProgressSummary(this.repository);

  Future<ProgressSummary> call(ProgressPeriod period) {
    return repository.getProgressSummary(period);
  }
}
