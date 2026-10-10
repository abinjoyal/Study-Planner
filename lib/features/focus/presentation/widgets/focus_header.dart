import 'package:flutter/material.dart';

class FocusHeader extends StatelessWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onStatsTap;
  final VoidCallback? onSettingsTap;

  const FocusHeader({
    super.key,
    this.onBackTap,
    this.onStatsTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBackTap != null) ...[
          IconButton(
            onPressed: onBackTap,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1B1C4B),
              size: 20,
            ),
          ),
        ] else ...[
          const SizedBox(width: 8),
        ],
        const Expanded(
          child: Text(
            'Focus Timer',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1B1C4B),
              letterSpacing: -0.5,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: onStatsTap,
                icon: const Icon(
                  Icons.bar_chart_rounded,
                  color: Color(0xFF1B1C4B),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: onSettingsTap,
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFF1B1C4B),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
