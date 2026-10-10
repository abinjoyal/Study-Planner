import '../repositories/progress_repository.dart';

class GetWeeklyGoal {
  final ProgressRepository repository;

  GetWeeklyGoal(this.repository);

  Future<double> call() {
    return repository.getWeeklyGoalPercentage();
  }
}
