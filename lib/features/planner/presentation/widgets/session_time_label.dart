import 'package:flutter/material.dart';

class SessionTimeLabel extends StatelessWidget {
  final String timeLabel;

  const SessionTimeLabel({
    super.key,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      child: Text(
        timeLabel,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF64748B),
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
