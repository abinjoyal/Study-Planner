import '../entities/dashboard.dart';
import '../repositories/home_repository.dart';

class GetDashboard {
  final HomeRepository repository;

  GetDashboard(this.repository);

  Future<Dashboard> call() async {
    return await repository.getDashboard();
  }
}
