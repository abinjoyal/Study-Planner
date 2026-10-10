enum FocusMode { focus, shortBreak, longBreak }

class FocusSession {
  final String id;
  final FocusMode mode;
  final Duration duration;
  final DateTime startTime;
  final DateTime endTime;
  final bool isCompleted;

  const FocusSession({
    required this.id,
    required this.mode,
    required this.duration,
    required this.startTime,
    required this.endTime,
    this.isCompleted = true,
  });

  FocusSession copyWith({
    String? id,
    FocusMode? mode,
    Duration? duration,
    DateTime? startTime,
    DateTime? endTime,
    bool? isCompleted,
  }) {
    return FocusSession(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      duration: duration ?? this.duration,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
