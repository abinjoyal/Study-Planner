import '../entities/progress_summary.dart';
import '../entities/study_streak.dart';
import '../entities/subject_progress.dart';

enum ProgressPeriod { thisWeek, thisMonth, allTime }

abstract class ProgressRepository {
  Future<ProgressSummary> getProgressSummary(ProgressPeriod period);
  Future<List<SubjectProgress>> getSubjectProgress(ProgressPeriod period);
  Future<StudyStreak> getStudyStreak();
  Future<double> getWeeklyGoalPercentage();
  Future<List<Map<String, dynamic>>> getProgressHistory();
}
