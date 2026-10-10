import 'package:flutter/material.dart';
import '../../domain/entities/study_session.dart';

class StudySessionModel extends StudySession {
  const StudySessionModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.timeLabel,
    required super.duration,
    required super.subjectType,
    required super.date,
    super.isCompleted = false,
    super.customColor,
  });

  factory StudySessionModel.fromJson(Map<String, dynamic> json) {
    return StudySessionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      timeLabel: json['time_label'] as String? ?? '08:00',
      duration: json['duration'] as String? ?? '1h',
      subjectType: _parseSubjectType(json['subject_type'] as String?),
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      isCompleted: json['is_completed'] as bool? ?? false,
      customColor: json['color_hex'] != null
          ? Color(int.parse((json['color_hex'] as String).replaceAll('#', '0xFF')))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'time_label': timeLabel,
      'duration': duration,
      'subject_type': subjectType.name,
      'date': date.toIso8601String(),
      'is_completed': isCompleted,
      if (customColor != null)
        'color_hex': '#${customColor!.toARGB32().toRadixString(16).substring(2)}',
    };
  }

  static SubjectType _parseSubjectType(String? typeStr) {
    switch (typeStr?.toLowerCase()) {
      case 'maths':
      case 'math':
        return SubjectType.maths;
      case 'physics':
        return SubjectType.physics;
      case 'break':
      case 'breaktime':
        return SubjectType.breakTime;
      case 'chemistry':
        return SubjectType.chemistry;
      case 'english':
        return SubjectType.english;
      case 'revision':
        return SubjectType.revision;
      default:
        return SubjectType.custom;
    }
  }

  factory StudySessionModel.fromEntity(StudySession entity) {
    return StudySessionModel(
      id: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      timeLabel: entity.timeLabel,
      duration: entity.duration,
      subjectType: entity.subjectType,
      date: entity.date,
      isCompleted: entity.isCompleted,
      customColor: entity.customColor,
    );
  }
}
