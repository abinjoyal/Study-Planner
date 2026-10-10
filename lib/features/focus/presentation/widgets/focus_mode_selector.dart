import 'package:flutter/material.dart';
import '../../domain/entities/focus_session.dart';

class FocusModeSelector extends StatelessWidget {
  final FocusMode currentMode;
  final ValueChanged<FocusMode> onModeSelected;

  const FocusModeSelector({
    super.key,
    required this.currentMode,
    required this.onModeSelected,
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
          _buildItem(
            label: 'Focus',
            mode: FocusMode.focus,
          ),
          _buildItem(
            label: 'Short Break',
            mode: FocusMode.shortBreak,
          ),
          _buildItem(
            label: 'Long Break',
            mode: FocusMode.longBreak,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({required String label, required FocusMode mode}) {
    final isSelected = currentMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => onModeSelected(mode),
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
