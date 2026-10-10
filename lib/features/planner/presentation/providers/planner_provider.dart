import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/planner_local_datasource.dart';
import '../../data/datasources/planner_remote_datasource.dart';
import '../../data/repositories/planner_repository_impl.dart';
import '../../domain/entities/study_session.dart';
import '../../domain/repositories/planner_repository.dart';
import '../../domain/usecases/add_study_session.dart';
import '../../domain/usecases/delete_study_session.dart';
import '../../domain/usecases/get_study_sessions.dart';
import '../../domain/usecases/get_weekly_schedule.dart';
import '../../domain/usecases/update_study_session.dart';
import 'planner_state.dart';

// Dependency Injection Providers
final plannerRemoteDataSourceProvider =
    Provider<PlannerRemoteDataSource>((ref) {
  return PlannerRemoteDataSourceImpl();
});

final plannerLocalDataSourceProvider = Provider<PlannerLocalDataSource>((ref) {
  return PlannerLocalDataSourceImpl();
});

final plannerRepositoryProvider = Provider<PlannerRepository>((ref) {
  return PlannerRepositoryImpl(
    remoteDataSource: ref.watch(plannerRemoteDataSourceProvider),
    localDataSource: ref.watch(plannerLocalDataSourceProvider),
  );
});

final getStudySessionsUseCaseProvider = Provider<GetStudySessions>((ref) {
  return GetStudySessions(ref.watch(plannerRepositoryProvider));
});

final addStudySessionUseCaseProvider = Provider<AddStudySession>((ref) {
  return AddStudySession(ref.watch(plannerRepositoryProvider));
});

final updateStudySessionUseCaseProvider = Provider<UpdateStudySession>((ref) {
  return UpdateStudySession(ref.watch(plannerRepositoryProvider));
});

final deleteStudySessionUseCaseProvider = Provider<DeleteStudySession>((ref) {
  return DeleteStudySession(ref.watch(plannerRepositoryProvider));
});

final getWeeklyScheduleUseCaseProvider = Provider<GetWeeklySchedule>((ref) {
  return GetWeeklySchedule(ref.watch(plannerRepositoryProvider));
});

// StateNotifier
class PlannerNotifier extends StateNotifier<PlannerState> {
  final GetStudySessions getStudySessionsUseCase;
  final AddStudySession addStudySessionUseCase;
  final UpdateStudySession updateStudySessionUseCase;
  final DeleteStudySession deleteStudySessionUseCase;
  final GetWeeklySchedule getWeeklyScheduleUseCase;

  PlannerNotifier({
    required this.getStudySessionsUseCase,
    required this.addStudySessionUseCase,
    required this.updateStudySessionUseCase,
    required this.deleteStudySessionUseCase,
    required this.getWeeklyScheduleUseCase,
  }) : super(PlannerState(selectedDate: DateTime.now())) {
    init();
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    try {
      final days = await getWeeklyScheduleUseCase(state.selectedDate);
      final sessions = await getStudySessionsUseCase(state.selectedDate);
      state = state.copyWith(
        isLoading: false,
        days: days,
        sessions: sessions,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> selectDate(DateTime date) async {
    state = state.copyWith(selectedDate: date, isLoading: true);
    final days = await getWeeklyScheduleUseCase(date);
    final sessions = await getStudySessionsUseCase(date);
    state = state.copyWith(
      isLoading: false,
      days: days,
      sessions: sessions,
    );
  }

  void setViewMode(ScheduleViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  Future<void> addSession(StudySession session) async {
    await addStudySessionUseCase(session);
    final sessions = await getStudySessionsUseCase(state.selectedDate);
    state = state.copyWith(sessions: sessions);
  }

  Future<void> updateSession(StudySession session) async {
    await updateStudySessionUseCase(session);
    final sessions = await getStudySessionsUseCase(state.selectedDate);
    state = state.copyWith(sessions: sessions);
  }

  Future<void> removeSession(String id) async {
    await deleteStudySessionUseCase(id);
    final sessions = await getStudySessionsUseCase(state.selectedDate);
    state = state.copyWith(sessions: sessions);
  }
}

final plannerNotifierProvider =
    StateNotifierProvider<PlannerNotifier, PlannerState>((ref) {
  return PlannerNotifier(
    getStudySessionsUseCase: ref.watch(getStudySessionsUseCaseProvider),
    addStudySessionUseCase: ref.watch(addStudySessionUseCaseProvider),
    updateStudySessionUseCase: ref.watch(updateStudySessionUseCaseProvider),
    deleteStudySessionUseCase: ref.watch(deleteStudySessionUseCaseProvider),
    getWeeklyScheduleUseCase: ref.watch(getWeeklyScheduleUseCaseProvider),
  );
});
