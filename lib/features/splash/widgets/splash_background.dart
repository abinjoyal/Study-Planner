import 'package:flutter/material.dart';

class SplashBackground extends StatelessWidget {
  final Widget child;

  const SplashBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFAF9F6),
      ),
      child: Stack(
        children: [
          // Top-Left Soft Warm Glow
          Positioned(
            top: -90,
            left: -90,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFE5CD).withValues(alpha: 0.7),
                    const Color(0xFFFFF2E6).withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          // Top-Right Soft Accent
          Positioned(
            top: 50,
            right: -50,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFEDD8).withValues(alpha: 0.45),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Bottom-Right Large Soft Orange Gradient
          Positioned(
            bottom: -100,
            right: -80,
            child: Container(
              width: 440,
              height: 440,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFDFBF).withValues(alpha: 0.75),
                    const Color(0xFFFFF1E4).withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          // Bottom-Left Soft Accent
          Positioned(
            bottom: 60,
            left: -90,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFF0E1).withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Full-screen Center-aligned Foreground Content
          Positioned.fill(
            child: SafeArea(
              child: SizedBox.expand(
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
