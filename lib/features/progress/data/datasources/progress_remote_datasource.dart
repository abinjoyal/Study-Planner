import '../models/progress_summary_model.dart';
import '../../domain/repositories/progress_repository.dart';

abstract class ProgressRemoteDataSource {
  Future<ProgressSummaryModel?> fetchRemoteSummary(ProgressPeriod period);
}

class ProgressRemoteDataSourceImpl implements ProgressRemoteDataSource {
  @override
  Future<ProgressSummaryModel?> fetchRemoteSummary(ProgressPeriod period) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return null;
  }
}
