import '../../domain/entities/planner_day.dart';

class PlannerDayModel extends PlannerDay {
  const PlannerDayModel({
    required super.date,
    required super.dayName,
    required super.dayNumber,
    super.isSelected = false,
  });

  factory PlannerDayModel.fromJson(Map<String, dynamic> json) {
    return PlannerDayModel(
      date: DateTime.parse(json['date'] as String),
      dayName: json['day_name'] as String,
      dayNumber: json['day_number'] as int,
      isSelected: json['is_selected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'day_name': dayName,
      'day_number': dayNumber,
      'is_selected': isSelected,
    };
  }

  factory PlannerDayModel.fromDate(DateTime date, {bool isSelected = false}) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayName = days[date.weekday - 1];
    return PlannerDayModel(
      date: date,
      dayName: dayName,
      dayNumber: date.day,
      isSelected: isSelected,
    );
  }
}
