import 'package:flutter/material.dart';
import '../../domain/entities/study_session.dart';

class SubjectIconStyle {
  final IconData icon;
  final Color iconColor;
  final Color cardBgColor;
  final Color leftAccentColor;

  const SubjectIconStyle({
    required this.icon,
    required this.iconColor,
    required this.cardBgColor,
    required this.leftAccentColor,
  });
}

class SubjectIconHelper {
  static SubjectIconStyle getStyle(SubjectType type) {
    switch (type) {
      case SubjectType.maths:
        return const SubjectIconStyle(
          icon: Icons.menu_book_rounded,
          iconColor: Color(0xFF2563EB),
          cardBgColor: Color(0xFFEFF6FF),
          leftAccentColor: Color(0xFF3B82F6),
        );
      case SubjectType.physics:
        return const SubjectIconStyle(
          icon: Icons.hub_rounded,
          iconColor: Color(0xFF9333EA),
          cardBgColor: Color(0xFFF3E8FF),
          leftAccentColor: Color(0xFFA855F7),
        );
      case SubjectType.breakTime:
        return const SubjectIconStyle(
          icon: Icons.local_cafe_rounded,
          iconColor: Color(0xFFEA580C),
          cardBgColor: Color(0xFFFFF7ED),
          leftAccentColor: Color(0xFFF97316),
        );
      case SubjectType.chemistry:
        return const SubjectIconStyle(
          icon: Icons.science_rounded,
          iconColor: Color(0xFFD97706),
          cardBgColor: Color(0xFFFFFBEB),
          leftAccentColor: Color(0xFFF59E0B),
        );
      case SubjectType.english:
        return const SubjectIconStyle(
          icon: Icons.auto_stories_rounded,
          iconColor: Color(0xFF0D9488),
          cardBgColor: Color(0xFFF0FDF4),
          leftAccentColor: Color(0xFF10B981),
        );
      case SubjectType.revision:
        return const SubjectIconStyle(
          icon: Icons.sync_rounded,
          iconColor: Color(0xFFF95700),
          cardBgColor: Color(0xFFFFF1F0),
          leftAccentColor: Color(0xFFFF6E1F),
        );
      case SubjectType.custom:
        return const SubjectIconStyle(
          icon: Icons.bookmark_rounded,
          iconColor: Color(0xFF475569),
          cardBgColor: Color(0xFFF8FAFC),
          leftAccentColor: Color(0xFF64748B),
        );
    }
  }
}

class SubjectIcon extends StatelessWidget {
  final SubjectType subjectType;
  final double size;

  const SubjectIcon({
    super.key,
    required this.subjectType,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    final style = SubjectIconHelper.getStyle(subjectType);
    return Icon(
      style.icon,
      color: style.iconColor,
      size: size,
    );
  }
}
