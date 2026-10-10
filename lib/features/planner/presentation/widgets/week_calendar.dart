import 'package:flutter/material.dart';
import '../../domain/entities/planner_day.dart';
import 'calendar_day_item.dart';

class WeekCalendar extends StatelessWidget {
  final List<PlannerDay> days;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const WeekCalendar({
    super.key,
    required this.days,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Generate default week if days list is empty
    final listToDisplay = days.isNotEmpty
        ? days
        : _generateDefaultWeek(selectedDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: listToDisplay.map((day) {
        final isSelected = day.date.year == selectedDate.year &&
            day.date.month == selectedDate.month &&
            day.date.day == selectedDate.day;

        return CalendarDayItem(
          dayName: day.dayName,
          dayNumber: day.dayNumber,
          isSelected: isSelected,
          onTap: () => onDateSelected(day.date),
        );
      }).toList(),
    );
  }

  List<PlannerDay> _generateDefaultWeek(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return List.generate(7, (index) {
      final current = monday.add(Duration(days: index));
      return PlannerDay(
        date: current,
        dayName: dayNames[index],
        dayNumber: current.day,
        isSelected: current.day == date.day,
      );
    });
  }
}
