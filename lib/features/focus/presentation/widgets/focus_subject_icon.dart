import 'package:flutter/material.dart';

class FocusSubjectIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const FocusSubjectIcon({
    super.key,
    this.icon = Icons.menu_book_rounded,
    this.iconColor = const Color(0xFF2563EB),
    this.backgroundColor = const Color(0xFFEFF6FF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 26,
      ),
    );
  }
}
