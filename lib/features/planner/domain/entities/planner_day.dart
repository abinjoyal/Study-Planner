class PlannerDay {
  final DateTime date;
  final String dayName; // e.g. "Wed"
  final int dayNumber; // e.g. 8
  final bool isSelected;

  const PlannerDay({
    required this.date,
    required this.dayName,
    required this.dayNumber,
    this.isSelected = false,
  });

  PlannerDay copyWith({
    DateTime? date,
    String? dayName,
    int? dayNumber,
    bool? isSelected,
  }) {
    return PlannerDay(
      date: date ?? this.date,
      dayName: dayName ?? this.dayName,
      dayNumber: dayNumber ?? this.dayNumber,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
