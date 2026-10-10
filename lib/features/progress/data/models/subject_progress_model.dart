import 'package:flutter/material.dart';
import '../../domain/entities/subject_progress.dart';

class SubjectProgressModel extends SubjectProgress {
  const SubjectProgressModel({
    required super.id,
    required super.subjectName,
    required super.completedTasks,
    required super.totalTasks,
    required super.studyMinutes,
    super.themeColor,
  });

  factory SubjectProgressModel.fromJson(Map<String, dynamic> json) {
    return SubjectProgressModel(
      id: json['id'] as String,
      subjectName: json['subject_name'] as String,
      completedTasks: json['completed_tasks'] as int? ?? 0,
      totalTasks: json['total_tasks'] as int? ?? 0,
      studyMinutes: json['study_minutes'] as int? ?? 0,
      themeColor: json['color_hex'] != null
          ? Color(int.parse((json['color_hex'] as String).replaceAll('#', '0xFF')))
          : const Color(0xFF3B82F6),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_name': subjectName,
      'completed_tasks': completedTasks,
      'total_tasks': totalTasks,
      'study_minutes': studyMinutes,
      'color_hex': '#${themeColor.toARGB32().toRadixString(16).substring(2)}',
    };
  }
}
