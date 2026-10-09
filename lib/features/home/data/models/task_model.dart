import 'package:flutter/material.dart';
import '../../domain/entities/study_task.dart';

class TaskModel extends StudyTask {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconSymbol,
    required super.iconBackgroundColor,
    required super.isCompleted,
    super.statusTag,
    super.estimatedTime,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconSymbol: json['iconSymbol'] as String,
      iconBackgroundColor: Color(json['iconBackgroundColor'] as int),
      isCompleted: json['isCompleted'] as bool,
      statusTag: json['statusTag'] as String?,
      estimatedTime: json['estimatedTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconSymbol': iconSymbol,
      'iconBackgroundColor': iconBackgroundColor.toARGB32(),
      'isCompleted': isCompleted,
      'statusTag': statusTag,
      'estimatedTime': estimatedTime,
    };
  }

  factory TaskModel.fromEntity(StudyTask entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      iconSymbol: entity.iconSymbol,
      iconBackgroundColor: entity.iconBackgroundColor,
      isCompleted: entity.isCompleted,
      statusTag: entity.statusTag,
      estimatedTime: entity.estimatedTime,
    );
  }
}
