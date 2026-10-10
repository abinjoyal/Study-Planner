import 'package:flutter/material.dart';
import '../providers/planner_state.dart';

class ScheduleViewToggle extends StatelessWidget {
  final ScheduleViewMode currentMode;
  final ValueChanged<ScheduleViewMode> onModeChanged;

  const ScheduleViewToggle({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5FA),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildItem(
            label: 'Day',
            mode: ScheduleViewMode.day,
          ),
          _buildItem(
            label: 'Week',
            mode: ScheduleViewMode.week,
          ),
          _buildItem(
            label: 'Month',
            mode: ScheduleViewMode.month,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({required String label, required ScheduleViewMode mode}) {
    final isSelected = currentMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => onModeChanged(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF6E1F) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF6E1F).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF7A869A),
            ),
          ),
        ),
      ),
    );
  }
}
