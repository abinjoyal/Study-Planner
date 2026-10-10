import 'package:flutter/material.dart';
import '../../domain/repositories/progress_repository.dart';

class ProgressPeriodSelector extends StatelessWidget {
  final ProgressPeriod currentPeriod;
  final ValueChanged<ProgressPeriod> onPeriodSelected;

  const ProgressPeriodSelector({
    super.key,
    required this.currentPeriod,
    required this.onPeriodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5FA),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildItem('This Week', ProgressPeriod.thisWeek),
          _buildItem('This Month', ProgressPeriod.thisMonth),
          _buildItem('All Time', ProgressPeriod.allTime),
        ],
      ),
    );
  }

  Widget _buildItem(String label, ProgressPeriod period) {
    final isSelected = currentPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => onPeriodSelected(period),
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
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF7A869A),
            ),
          ),
        ),
      ),
    );
  }
}
