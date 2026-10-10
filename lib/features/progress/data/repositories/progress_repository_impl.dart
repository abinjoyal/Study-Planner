import '../datasources/progress_local_datasource.dart';
import '../datasources/progress_remote_datasource.dart';
import '../../domain/entities/progress_summary.dart';
import '../../domain/entities/study_streak.dart';
import '../../domain/entities/subject_progress.dart';
import '../../domain/repositories/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressLocalDataSource localDataSource;
  final ProgressRemoteDataSource remoteDataSource;

  ProgressRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<ProgressSummary> getProgressSummary(ProgressPeriod period) async {
    return await localDataSource.getSummary(period);
  }

  @override
  Future<List<SubjectProgress>> getSubjectProgress(ProgressPeriod period) async {
    return await localDataSource.getSubjectProgress(period);
  }

  @override
  Future<StudyStreak> getStudyStreak() async {
    return await localDataSource.getStreak();
  }

  @override
  Future<double> getWeeklyGoalPercentage() async {
    return await localDataSource.getWeeklyGoalPercentage();
  }

  @override
  Future<List<Map<String, dynamic>>> getProgressHistory() async {
    return [
      {'day': 'Mon', 'minutes': 180},
      {'day': 'Tue', 'minutes': 240},
      {'day': 'Wed', 'minutes': 210},
      {'day': 'Thu', 'minutes': 300},
      {'day': 'Fri', 'minutes': 150},
      {'day': 'Sat', 'minutes': 270},
      {'day': 'Sun', 'minutes': 220},
    ];
  }
}
