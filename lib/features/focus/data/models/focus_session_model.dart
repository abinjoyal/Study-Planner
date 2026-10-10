import '../../domain/entities/focus_session.dart';

class FocusSessionModel extends FocusSession {
  const FocusSessionModel({
    required super.id,
    required super.mode,
    required super.duration,
    required super.startTime,
    required super.endTime,
    super.isCompleted = true,
  });

  factory FocusSessionModel.fromJson(Map<String, dynamic> json) {
    return FocusSessionModel(
      id: json['id'] as String,
      mode: FocusMode.values.firstWhere(
        (m) => m.name == json['mode'],
        orElse: () => FocusMode.focus,
      ),
      duration: Duration(seconds: json['duration_seconds'] as int? ?? 1500),
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      isCompleted: json['is_completed'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mode': mode.name,
      'duration_seconds': duration.inSeconds,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'is_completed': isCompleted,
    };
  }

  factory FocusSessionModel.fromEntity(FocusSession entity) {
    return FocusSessionModel(
      id: entity.id,
      mode: entity.mode,
      duration: entity.duration,
      startTime: entity.startTime,
      endTime: entity.endTime,
      isCompleted: entity.isCompleted,
    );
  }
}
