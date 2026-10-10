import 'package:flutter/material.dart';

enum SubjectType {
  maths,
  physics,
  breakTime,
  chemistry,
  english,
  revision,
  custom,
}

class StudySession {
  final String id;
  final String title;
  final String subtitle;
  final String timeLabel; // e.g. "08:00"
  final String duration; // e.g. "1h", "30m"
  final SubjectType subjectType;
  final DateTime date;
  final bool isCompleted;
  final Color? customColor;

  const StudySession({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.duration,
    required this.subjectType,
    required this.date,
    this.isCompleted = false,
    this.customColor,
  });

  StudySession copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? timeLabel,
    String? duration,
    SubjectType? subjectType,
    DateTime? date,
    bool? isCompleted,
    Color? customColor,
  }) {
    return StudySession(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      timeLabel: timeLabel ?? this.timeLabel,
      duration: duration ?? this.duration,
      subjectType: subjectType ?? this.subjectType,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      customColor: customColor ?? this.customColor,
    );
  }
}
