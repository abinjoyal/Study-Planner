import 'package:flutter/material.dart';

enum NotificationCategory { all, reminders, achievements, deadlines }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final NotificationCategory category;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.category,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    String? timeAgo,
    NotificationCategory? category,
    IconData? icon,
    Color? iconColor,
    Color? iconBackgroundColor,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timeAgo: timeAgo ?? this.timeAgo,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      isRead: isRead ?? this.isRead,
    );
  }
}
