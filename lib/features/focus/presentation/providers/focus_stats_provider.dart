import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/focus_local_datasource.dart';
import '../../data/datasources/focus_remote_datasource.dart';
import '../../data/repositories/focus_repository_impl.dart';
import '../../domain/entities/focus_session.dart';
import '../../domain/repositories/focus_repository.dart';
import '../../domain/usecases/get_focus_history.dart';
import '../../domain/usecases/get_today_focus_stats.dart';
import '../../domain/usecases/save_focus_session.dart';

// DI Providers
final focusLocalDataSourceProvider = Provider<FocusLocalDataSource>((ref) {
  return FocusLocalDataSourceImpl();
});

final focusRemoteDataSourceProvider = Provider<FocusRemoteDataSource>((ref) {
  return FocusRemoteDataSourceImpl();
});

final focusRepositoryProvider = Provider<FocusRepository>((ref) {
  return FocusRepositoryImpl(
    localDataSource: ref.watch(focusLocalDataSourceProvider),
    remoteDataSource: ref.watch(focusRemoteDataSourceProvider),
  );
});

final getTodayFocusStatsUseCaseProvider = Provider<GetTodayFocusStats>((ref) {
  return GetTodayFocusStats(ref.watch(focusRepositoryProvider));
});

final getFocusHistoryUseCaseProvider = Provider<GetFocusHistory>((ref) {
  return GetFocusHistory(ref.watch(focusRepositoryProvider));
});

final saveFocusSessionUseCaseProvider = Provider<SaveFocusSession>((ref) {
  return SaveFocusSession(ref.watch(focusRepositoryProvider));
});

class FocusStatsState {
  final bool isLoading;
  final String totalFocusFormatted;
  final int totalFocusMinutes;
  final int sessionCount;
  final List<FocusSession> history;

  const FocusStatsState({
    this.isLoading = true,
    this.totalFocusFormatted = '2h 30m',
    this.totalFocusMinutes = 150,
    this.sessionCount = 4,
    this.history = const [],
  });

  FocusStatsState copyWith({
    bool? isLoading,
    String? totalFocusFormatted,
    int? totalFocusMinutes,
    int? sessionCount,
    List<FocusSession>? history,
  }) {
    return FocusStatsState(
      isLoading: isLoading ?? this.isLoading,
      totalFocusFormatted: totalFocusFormatted ?? this.totalFocusFormatted,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      sessionCount: sessionCount ?? this.sessionCount,
      history: history ?? this.history,
    );
  }
}

class FocusStatsNotifier extends StateNotifier<FocusStatsState> {
  final GetTodayFocusStats getTodayFocusStatsUseCase;
  final GetFocusHistory getFocusHistoryUseCase;

  FocusStatsNotifier({
    required this.getTodayFocusStatsUseCase,
    required this.getFocusHistoryUseCase,
  }) : super(const FocusStatsState()) {
    loadStats();
  }

  Future<void> loadStats() async {
    state = state.copyWith(isLoading: true);
    try {
      final stats = await getTodayFocusStatsUseCase();
      final history = await getFocusHistoryUseCase();
      state = state.copyWith(
        isLoading: false,
        totalFocusFormatted: stats['totalFocusFormatted'] as String? ?? '0m',
        totalFocusMinutes: stats['totalFocusMinutes'] as int? ?? 0,
        sessionCount: stats['sessionCount'] as int? ?? 0,
        history: history,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final focusStatsNotifierProvider =
    StateNotifierProvider<FocusStatsNotifier, FocusStatsState>((ref) {
  return FocusStatsNotifier(
    getTodayFocusStatsUseCase: ref.watch(getTodayFocusStatsUseCaseProvider),
    getFocusHistoryUseCase: ref.watch(getFocusHistoryUseCaseProvider),
  );
});
