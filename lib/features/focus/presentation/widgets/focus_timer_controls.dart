import 'package:flutter/material.dart';

class FocusTimerControls extends StatelessWidget {
  final bool isRunning;
  final bool isPaused;
  final VoidCallback onStartPause;
  final VoidCallback onReset;
  final VoidCallback onSkip;

  const FocusTimerControls({
    super.key,
    required this.isRunning,
    required this.isPaused,
    required this.onStartPause,
    required this.onReset,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset Button
        _buildSideButton(
          icon: Icons.replay_rounded,
          onTap: onReset,
        ),
        const SizedBox(width: 24),

        // Main Play / Pause Button
        GestureDetector(
          onTap: onStartPause,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6E1F),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6E1F).withValues(alpha: 0.38),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              (isRunning && !isPaused)
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
        ),
        const SizedBox(width: 24),

        // Skip Button
        _buildSideButton(
          icon: Icons.skip_next_rounded,
          onTap: onSkip,
        ),
      ],
    );
  }

  Widget _buildSideButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: const Color(0xFF1B1C4B),
          size: 22,
        ),
      ),
    );
  }
}
