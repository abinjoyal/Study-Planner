import '../../domain/entities/planner_day.dart';
import '../../domain/entities/study_session.dart';

enum ScheduleViewMode { day, week, month }

class PlannerState {
  final bool isLoading;
  final List<StudySession> sessions;
  final List<PlannerDay> days;
  final DateTime selectedDate;
  final ScheduleViewMode viewMode;
  final String? errorMessage;

  const PlannerState({
    this.isLoading = true,
    this.sessions = const [],
    this.days = const [],
    required this.selectedDate,
    this.viewMode = ScheduleViewMode.day,
    this.errorMessage,
  });

  PlannerState copyWith({
    bool? isLoading,
    List<StudySession>? sessions,
    List<PlannerDay>? days,
    DateTime? selectedDate,
    ScheduleViewMode? viewMode,
    String? errorMessage,
  }) {
    return PlannerState(
      isLoading: isLoading ?? this.isLoading,
      sessions: sessions ?? this.sessions,
      days: days ?? this.days,
      selectedDate: selectedDate ?? this.selectedDate,
      viewMode: viewMode ?? this.viewMode,
      errorMessage: errorMessage,
    );
  }
}
