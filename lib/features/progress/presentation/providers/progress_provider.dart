import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/progress_local_datasource.dart';
import '../../data/datasources/progress_remote_datasource.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/entities/progress_summary.dart';
import '../../domain/entities/study_streak.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/usecases/get_progress_history.dart';
import '../../domain/usecases/get_progress_summary.dart';
import '../../domain/usecases/get_study_streak.dart';
import '../../domain/usecases/get_subject_progress.dart';
import '../../domain/usecases/get_weekly_goal.dart';
import 'progress_filter_provider.dart';

// DI Providers
final progressLocalDataSourceProvider =
    Provider<ProgressLocalDataSource>((ref) {
  return ProgressLocalDataSourceImpl();
});

final progressRemoteDataSourceProvider =
    Provider<ProgressRemoteDataSource>((ref) {
  return ProgressRemoteDataSourceImpl();
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepositoryImpl(
    localDataSource: ref.watch(progressLocalDataSourceProvider),
    remoteDataSource: ref.watch(progressRemoteDataSourceProvider),
  );
});

final getProgressSummaryUseCaseProvider = Provider<GetProgressSummary>((ref) {
  return GetProgressSummary(ref.watch(progressRepositoryProvider));
});

final getSubjectProgressUseCaseProvider = Provider<GetSubjectProgress>((ref) {
  return GetSubjectProgress(ref.watch(progressRepositoryProvider));
});

final getStudyStreakUseCaseProvider = Provider<GetStudyStreak>((ref) {
  return GetStudyStreak(ref.watch(progressRepositoryProvider));
});

final getWeeklyGoalUseCaseProvider = Provider<GetWeeklyGoal>((ref) {
  return GetWeeklyGoal(ref.watch(progressRepositoryProvider));
});

final getProgressHistoryUseCaseProvider = Provider<GetProgressHistory>((ref) {
  return GetProgressHistory(ref.watch(progressRepositoryProvider));
});

class ProgressState {
  final bool isLoading;
  final ProgressSummary? summary;
  final StudyStreak? streak;
  final double weeklyGoalPct;
  final DateTime? selectedDate;
  final String? errorMessage;

  const ProgressState({
    this.isLoading = true,
    this.summary,
    this.streak,
    this.weeklyGoalPct = 0.0,
    this.selectedDate,
    this.errorMessage,
  });

  ProgressState copyWith({
    bool? isLoading,
    ProgressSummary? summary,
    StudyStreak? streak,
    double? weeklyGoalPct,
    DateTime? selectedDate,
    bool clearSelectedDate = false,
    String? errorMessage,
  }) {
    return ProgressState(
      isLoading: isLoading ?? this.isLoading,
      summary: summary ?? this.summary,
      streak: streak ?? this.streak,
      weeklyGoalPct: weeklyGoalPct ?? this.weeklyGoalPct,
      selectedDate: clearSelectedDate ? null : (selectedDate ?? this.selectedDate),
      errorMessage: errorMessage,
    );
  }
}

class ProgressNotifier extends StateNotifier<ProgressState> {
  final Ref ref;
  final GetProgressSummary getProgressSummaryUseCase;
  final GetStudyStreak getStudyStreakUseCase;
  final GetWeeklyGoal getWeeklyGoalUseCase;

  ProgressNotifier(
    this.ref, {
    required this.getProgressSummaryUseCase,
    required this.getStudyStreakUseCase,
    required this.getWeeklyGoalUseCase,
  }) : super(const ProgressState()) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      final period = ref.read(progressFilterProvider);
      final summary = await getProgressSummaryUseCase(
        period,
        customDate: state.selectedDate,
      );
      final streak = await getStudyStreakUseCase();
      final goal = await getWeeklyGoalUseCase();

      state = state.copyWith(
        isLoading: false,
        summary: summary,
        streak: streak,
        weeklyGoalPct: goal,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void selectDate(DateTime? date) {
    if (date == null) {
      state = state.copyWith(clearSelectedDate: true);
    } else {
      state = state.copyWith(selectedDate: date);
    }
    loadData();
  }

  void changePeriod(ProgressPeriod period) {
    ref.read(progressFilterProvider.notifier).state = period;
    state = state.copyWith(clearSelectedDate: true);
    loadData();
  }
}

final progressNotifierProvider =
    StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  return ProgressNotifier(
    ref,
    getProgressSummaryUseCase: ref.watch(getProgressSummaryUseCaseProvider),
    getStudyStreakUseCase: ref.watch(getStudyStreakUseCaseProvider),
    getWeeklyGoalUseCase: ref.watch(getWeeklyGoalUseCaseProvider),
  );
});
