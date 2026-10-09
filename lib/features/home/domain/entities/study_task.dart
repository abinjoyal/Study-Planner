import 'package:flutter/material.dart';

class StudyTask {
  final String id;
  final String title;
  final String description;
  final String iconSymbol;
  final Color iconBackgroundColor;
  final bool isCompleted;
  final String? statusTag;
  final String? estimatedTime;

  const StudyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.iconSymbol,
    required this.iconBackgroundColor,
    required this.isCompleted,
    this.statusTag,
    this.estimatedTime,
  });

  StudyTask copyWith({
    String? id,
    String? title,
    String? description,
    String? iconSymbol,
    Color? iconBackgroundColor,
    bool? isCompleted,
    String? statusTag,
    String? estimatedTime,
  }) {
    return StudyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconSymbol: iconSymbol ?? this.iconSymbol,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      isCompleted: isCompleted ?? this.isCompleted,
      statusTag: statusTag ?? this.statusTag,
      estimatedTime: estimatedTime ?? this.estimatedTime,
    );
  }
}
