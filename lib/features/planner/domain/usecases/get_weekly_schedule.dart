import '../entities/planner_day.dart';
import '../repositories/planner_repository.dart';

class GetWeeklySchedule {
  final PlannerRepository repository;

  GetWeeklySchedule(this.repository);

  Future<List<PlannerDay>> call(DateTime startDate) {
    return repository.getWeeklySchedule(startDate);
  }
}
