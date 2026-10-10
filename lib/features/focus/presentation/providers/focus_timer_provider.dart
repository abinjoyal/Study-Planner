import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/focus_session.dart';
import 'focus_settings_provider.dart';
import 'focus_stats_provider.dart';

class FocusTimerState {
  final FocusMode mode;
  final bool isRunning;
  final bool isPaused;
  final Duration totalDuration;
  final Duration remainingDuration;
  final DateTime? startTime;
  final DateTime? targetEndTime;

  const FocusTimerState({
    this.mode = FocusMode.focus,
    this.isRunning = false,
    this.isPaused = false,
    this.totalDuration = const Duration(minutes: 25),
    this.remainingDuration = const Duration(minutes: 25),
    this.startTime,
    this.targetEndTime,
  });

  double get progress {
    if (totalDuration.inSeconds == 0) return 0.0;
    final elapsed = totalDuration.inSeconds - remainingDuration.inSeconds;
    return (elapsed / totalDuration.inSeconds).clamp(0.0, 1.0);
  }

  String get formattedRemaining {
    final minutes = remainingDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remainingDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get modeLabel {
    switch (mode) {
      case FocusMode.focus:
        return 'Focus Time';
      case FocusMode.shortBreak:
        return 'Short Break';
      case FocusMode.longBreak:
        return 'Long Break';
    }
  }

  FocusTimerState copyWith({
    FocusMode? mode,
    bool? isRunning,
    bool? isPaused,
    Duration? totalDuration,
    Duration? remainingDuration,
    DateTime? startTime,
    DateTime? targetEndTime,
  }) {
    return FocusTimerState(
      mode: mode ?? this.mode,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      totalDuration: totalDuration ?? this.totalDuration,
      remainingDuration: remainingDuration ?? this.remainingDuration,
      startTime: startTime ?? this.startTime,
      targetEndTime: targetEndTime ?? this.targetEndTime,
    );
  }
}

class FocusTimerNotifier extends StateNotifier<FocusTimerState>
    with WidgetsBindingObserver {
  final Ref ref;
  Timer? _ticker;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FocusTimerNotifier(this.ref) : super(const FocusTimerState()) {
    WidgetsBinding.instance.addObserver(this);
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    try {
      await _notificationsPlugin.initialize(settings: initSettings);
    } catch (_) {}
  }

  Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'focus_timer_channel',
      'Focus Timer Notifications',
      channelDescription: 'Notifications for completed focus sessions',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    try {
      await _notificationsPlugin.show(
        id: 0,
        title: title,
        body: body,
        notificationDetails: details,
      );
    } catch (_) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && this.state.isRunning && !this.state.isPaused) {
      _syncTimerWithTimestamp();
    }
  }

  void selectMode(FocusMode mode) {
    _ticker?.cancel();
    final settings = ref.read(focusSettingsNotifierProvider);
    Duration duration;
    switch (mode) {
      case FocusMode.focus:
        duration = Duration(minutes: settings.focusMinutes);
        break;
      case FocusMode.shortBreak:
        duration = Duration(minutes: settings.shortBreakMinutes);
        break;
      case FocusMode.longBreak:
        duration = Duration(minutes: settings.longBreakMinutes);
        break;
    }

    state = FocusTimerState(
      mode: mode,
      isRunning: false,
      isPaused: false,
      totalDuration: duration,
      remainingDuration: duration,
    );
  }

  void startTimer() {
    if (state.isRunning && !state.isPaused) return;

    final now = DateTime.now();
    final targetEnd = state.isPaused && state.targetEndTime != null
        ? now.add(state.remainingDuration)
        : now.add(state.totalDuration);

    state = state.copyWith(
      isRunning: true,
      isPaused: false,
      startTime: state.startTime ?? now,
      targetEndTime: targetEnd,
    );

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _syncTimerWithTimestamp();
    });
  }

  void pauseTimer() {
    if (!state.isRunning || state.isPaused) return;
    _ticker?.cancel();
    _syncTimerWithTimestamp();
    state = state.copyWith(isPaused: true);
  }

  void resetTimer() {
    _ticker?.cancel();
    state = FocusTimerState(
      mode: state.mode,
      isRunning: false,
      isPaused: false,
      totalDuration: state.totalDuration,
      remainingDuration: state.totalDuration,
    );
  }

  void skipTimer() {
    _ticker?.cancel();
    _onTimerComplete();
  }

  void _syncTimerWithTimestamp() {
    if (state.targetEndTime == null) return;
    final now = DateTime.now();
    final diff = state.targetEndTime!.difference(now);

    if (diff <= Duration.zero) {
      _ticker?.cancel();
      _onTimerComplete();
    } else {
      state = state.copyWith(remainingDuration: diff);
    }
  }

  Future<void> _onTimerComplete() async {
    final completedSession = FocusSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mode: state.mode,
      duration: state.totalDuration,
      startTime: state.startTime ?? DateTime.now().subtract(state.totalDuration),
      endTime: DateTime.now(),
      isCompleted: true,
    );

    if (state.mode == FocusMode.focus) {
      await ref.read(saveFocusSessionUseCaseProvider).call(completedSession);
      ref.read(focusStatsNotifierProvider.notifier).loadStats();
      _showNotification('Focus Session Complete! 🎉', 'Great job! Time for a short break.');
    } else {
      _showNotification('Break Time Ended! ⏰', 'Ready to get back into focus mode?');
    }

    resetTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    super.dispose();
  }
}

final focusTimerNotifierProvider =
    StateNotifierProvider<FocusTimerNotifier, FocusTimerState>((ref) {
  return FocusTimerNotifier(ref);
});
