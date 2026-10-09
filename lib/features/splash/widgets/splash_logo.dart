import 'package:flutter/material.dart';

class SplashLogo extends StatelessWidget {
  final Animation<double> animation;

  const SplashLogo({
    super.key,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: SizedBox(
          width: 260,
          height: 240,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Sparkle / Ray lines top-right of logo
              Positioned(
                top: 8,
                right: 30,
                child: CustomPaint(
                  size: const Size(32, 32),
                  painter: _SparklePainter(),
                ),
              ),

              // Orange Floating Dot (Top-Left)
              Positioned(
                top: 25,
                left: 20,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFA8C16),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Small Yellow Dot (Middle-Left)
              Positioned(
                top: 105,
                left: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD591),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Blue Floating Dot (Middle-Right)
              Positioned(
                top: 135,
                right: 12,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2F54EB),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Small Light Orange Dot (Bottom-Right)
              Positioned(
                bottom: 25,
                right: 32,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFC069),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Main Central App Icon (Cropped & Scaled to remove PNG white background margin)
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFA8C16).withOpacity(0.35),
                      blurRadius: 30,
                      spreadRadius: 1,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Transform.scale(
                    scale: 1.65,
                    child: Image.asset(
                      'assets/images/logo_1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFA8C16)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    // Ray 1
    canvas.drawLine(
      const Offset(4, 24),
      const Offset(10, 8),
      paint,
    );

    // Ray 2
    canvas.drawLine(
      const Offset(18, 20),
      const Offset(28, 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
