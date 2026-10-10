import '../../domain/entities/study_streak.dart';

class StudyStreakModel extends StudyStreak {
  const StudyStreakModel({
    required super.currentStreakDays,
    required super.longestStreakDays,
    required super.qualifyingDates,
  });

  factory StudyStreakModel.fromJson(Map<String, dynamic> json) {
    final rawDates = json['qualifying_dates'] as List<dynamic>? ?? [];
    return StudyStreakModel(
      currentStreakDays: json['current_streak_days'] as int? ?? 0,
      longestStreakDays: json['longest_streak_days'] as int? ?? 0,
      qualifyingDates: rawDates.map((d) => DateTime.parse(d as String)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_streak_days': currentStreakDays,
      'longest_streak_days': longestStreakDays,
      'qualifying_dates': qualifyingDates.map((d) => d.toIso8601String()).toList(),
    };
  }
}
