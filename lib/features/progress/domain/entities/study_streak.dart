class StudyStreak {
  final int currentStreakDays;
  final int longestStreakDays;
  final List<DateTime> qualifyingDates;

  const StudyStreak({
    required this.currentStreakDays,
    required this.longestStreakDays,
    required this.qualifyingDates,
  });

  StudyStreak copyWith({
    int? currentStreakDays,
    int? longestStreakDays,
    List<DateTime>? qualifyingDates,
  }) {
    return StudyStreak(
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      longestStreakDays: longestStreakDays ?? this.longestStreakDays,
      qualifyingDates: qualifyingDates ?? this.qualifyingDates,
    );
  }
}
