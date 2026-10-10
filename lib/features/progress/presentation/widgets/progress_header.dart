import 'package:flutter/material.dart';

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'My Progress',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1B1C4B),
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
