import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/notification_item.dart';

class NotificationsState {
  final List<NotificationItem> notifications;
  final NotificationCategory selectedCategory;

  const NotificationsState({
    required this.notifications,
    this.selectedCategory = NotificationCategory.all,
  });

  List<NotificationItem> get filteredNotifications {
    if (selectedCategory == NotificationCategory.all) {
      return notifications;
    }
    return notifications
        .where((item) => item.category == selectedCategory)
        .toList();
  }

  int get unreadCount => notifications.where((item) => !item.isRead).length;

  NotificationsState copyWith({
    List<NotificationItem>? notifications,
    NotificationCategory? selectedCategory,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  NotificationsNotifier()
      : super(
          const NotificationsState(
            notifications: [
              NotificationItem(
                id: '1',
                title: 'Maths Session Starting Soon',
                message:
                    'Your scheduled study block for Chapter 4 begins in 15 minutes.',
                timeAgo: '10m ago',
                category: NotificationCategory.reminders,
                icon: Icons.alarm_rounded,
                iconColor: Color(0xFF0284C7),
                iconBackgroundColor: Color(0xFFE0F2FE),
                isRead: false,
              ),
              NotificationItem(
                id: '2',
                title: 'Streak Safeguard Alert',
                message:
                    'Complete at least one planned session today to keep your streak active.',
                timeAgo: '1h ago',
                category: NotificationCategory.achievements,
                icon: Icons.local_fire_department_rounded,
                iconColor: Color(0xFFEA580C),
                iconBackgroundColor: Color(0xFFFFEDD5),
                isRead: false,
              ),
              NotificationItem(
                id: '3',
                title: 'Physics Test Countdown',
                message:
                    'Your Physics examination is scheduled in 3 days. Review summary notes.',
                timeAgo: '3h ago',
                category: NotificationCategory.deadlines,
                icon: Icons.event_note_rounded,
                iconColor: Color(0xFF9333EA),
                iconBackgroundColor: Color(0xFFF3E8FF),
                isRead: false,
              ),
              NotificationItem(
                id: '4',
                title: 'Focus Session Completed',
                message:
                    'You completed a 25-minute Pomodoro session with zero interruptions.',
                timeAgo: 'Yesterday',
                category: NotificationCategory.reminders,
                icon: Icons.timer_rounded,
                iconColor: Color(0xFF16A34A),
                iconBackgroundColor: Color(0xFFDCFCE7),
                isRead: true,
              ),
              NotificationItem(
                id: '5',
                title: 'Weekly Target Reached',
                message:
                    'Congratulations on achieving your weekly study target of 10 hours.',
                timeAgo: '2d ago',
                category: NotificationCategory.achievements,
                icon: Icons.military_tech_rounded,
                iconColor: Color(0xFFF95700),
                iconBackgroundColor: Color(0xFFFFEDE4),
                isRead: true,
              ),
            ],
          ),
        );

  void setCategory(NotificationCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void markAsRead(String id) {
    state = state.copyWith(
      notifications: state.notifications.map((item) {
        if (item.id == id) {
          return item.copyWith(isRead: true);
        }
        return item;
      }).toList(),
    );
  }

  void markAllAsRead() {
    state = state.copyWith(
      notifications: state.notifications.map((item) {
        return item.copyWith(isRead: true);
      }).toList(),
    );
  }

  void removeNotification(String id) {
    state = state.copyWith(
      notifications:
          state.notifications.where((item) => item.id != id).toList(),
    );
  }

  void clearAll() {
    state = state.copyWith(notifications: const []);
  }
}

final notificationsNotifierProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier();
});
