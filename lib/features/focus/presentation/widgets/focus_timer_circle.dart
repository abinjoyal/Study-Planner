import 'dart:math';
import 'package:flutter/material.dart';

import 'focus_subject_icon.dart';

class FocusTimerCircle extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String formattedTime;
  final String modeLabel;

  const FocusTimerCircle({
    super.key,
    required this.progress,
    required this.formattedTime,
    required this.modeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 270,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular Progress Arc & Sunburst Painter
          CustomPaint(
            size: const Size(270, 270),
            painter: _TimerCirclePainter(
              progress: progress,
              trackColor: const Color(0xFFEEF2F6),
              progressColor: const Color(0xFFFF6E1F),
            ),
          ),

          // Center Text Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FocusSubjectIcon(),
              const SizedBox(height: 12),
              Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B1C4B),
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                modeLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8E9BBD),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerCirclePainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  _TimerCirclePainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;

    // Track Paint
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress Arc Paint
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Sunburst decorative dashes top-right and bottom-left
    final burstPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    // Top-right dashes angles (around 30 to 60 deg)
    _drawDash(canvas, center, radius + 16, radius + 26, -pi / 6, burstPaint);
    _drawDash(canvas, center, radius + 16, radius + 26, -pi / 12, burstPaint);
    _drawDash(canvas, center, radius + 16, radius + 26, 0, burstPaint);

    // Bottom-left dashes angles (around 120 to 150 deg)
    _drawDash(canvas, center, radius + 16, radius + 26, 3 * pi / 4, burstPaint);
    _drawDash(canvas, center, radius + 16, radius + 26, 5 * pi / 6, burstPaint);
    _drawDash(canvas, center, radius + 16, radius + 26, 11 * pi / 12, burstPaint);
  }

  void _drawDash(
    Canvas canvas,
    Offset center,
    double innerRadius,
    double outerRadius,
    double angle,
    Paint paint,
  ) {
    final start = Offset(
      center.dx + innerRadius * cos(angle),
      center.dy + innerRadius * sin(angle),
    );
    final end = Offset(
      center.dx + outerRadius * cos(angle),
      center.dy + outerRadius * sin(angle),
    );
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant _TimerCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
