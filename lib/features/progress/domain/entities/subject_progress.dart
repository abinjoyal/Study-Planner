import 'package:flutter/material.dart';

class SubjectProgress {
  final String id;
  final String subjectName;
  final int completedTasks;
  final int totalTasks;
  final int studyMinutes;
  final Color themeColor;

  const SubjectProgress({
    required this.id,
    required this.subjectName,
    required this.completedTasks,
    required this.totalTasks,
    required this.studyMinutes,
    this.themeColor = const Color(0xFF3B82F6),
  });

  double get completionPercentage {
    if (totalTasks == 0) return 0.0;
    final pct = (completedTasks / totalTasks) * 100;
    return pct.clamp(0.0, 100.0);
  }

  String get studyTimeFormatted {
    final hours = studyMinutes ~/ 60;
    final mins = studyMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }

  SubjectProgress copyWith({
    String? id,
    String? subjectName,
    int? completedTasks,
    int? totalTasks,
    int? studyMinutes,
    Color? themeColor,
  }) {
    return SubjectProgress(
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      completedTasks: completedTasks ?? this.completedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
      studyMinutes: studyMinutes ?? this.studyMinutes,
      themeColor: themeColor ?? this.themeColor,
    );
  }
}
