import 'package:flutter/material.dart';

class SplashTitle extends StatelessWidget {
  final Animation<double> animation;

  const SplashTitle({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // "StudyPlanner" Branding Title
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
                children: [
                  TextSpan(
                    text: 'Study',
                    style: TextStyle(color: Color(0xFF0F172A)),
                  ),
                  TextSpan(
                    text: 'Planner',
                    style: TextStyle(color: Color(0xFFF95700)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Tagline: PLAN • STUDY • ACHIEVE
            const Text(
              'PLAN  •  STUDY  •  ACHIEVE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF475569),
                letterSpacing: 2.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
