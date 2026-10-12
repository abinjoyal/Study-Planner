import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettingsState {
  final bool studyReminders;
  final bool streakAlerts;
  final bool examDeadlines;
  final bool soundEnabled;
  final bool isDarkMode;
  final int dailyGoalMinutes;
  final int weeklyGoalHours;
  final bool shareProgress;
  final int primaryColorIndex;

  static const List<Color> accentColors = [
    Color(0xFFF95700), // Orange
    Color(0xFF2563EB), // Blue
    Color(0xFF7C3AED), // Purple
    Color(0xFF059669), // Emerald
  ];

  static const List<String> accentNames = [
    'warm study orange',
    'vibrant electric blue',
    'royal study purple',
    'emerald growth green',
  ];

  Color get activeColor =>
      accentColors[primaryColorIndex.clamp(0, accentColors.length - 1)];

  String get activeColorName =>
      accentNames[primaryColorIndex.clamp(0, accentNames.length - 1)];

  const ProfileSettingsState({
    this.studyReminders = true,
    this.streakAlerts = true,
    this.examDeadlines = true,
    this.soundEnabled = true,
    this.isDarkMode = false,
    this.dailyGoalMinutes = 120, // 2 hours
    this.weeklyGoalHours = 15,
    this.shareProgress = false,
    this.primaryColorIndex = 0,
  });

  ProfileSettingsState copyWith({
    bool? studyReminders,
    bool? streakAlerts,
    bool? examDeadlines,
    bool? soundEnabled,
    bool? isDarkMode,
    int? dailyGoalMinutes,
    int? weeklyGoalHours,
    bool? shareProgress,
    int? primaryColorIndex,
  }) {
    return ProfileSettingsState(
      studyReminders: studyReminders ?? this.studyReminders,
      streakAlerts: streakAlerts ?? this.streakAlerts,
      examDeadlines: examDeadlines ?? this.examDeadlines,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      weeklyGoalHours: weeklyGoalHours ?? this.weeklyGoalHours,
      shareProgress: shareProgress ?? this.shareProgress,
      primaryColorIndex: primaryColorIndex ?? this.primaryColorIndex,
    );
  }
}

class ProfileSettingsNotifier extends StateNotifier<ProfileSettingsState> {
  ProfileSettingsNotifier() : super(const ProfileSettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = ProfileSettingsState(
      studyReminders: prefs.getBool('pref_study_reminders') ?? true,
      streakAlerts: prefs.getBool('pref_streak_alerts') ?? true,
      examDeadlines: prefs.getBool('pref_exam_deadlines') ?? true,
      soundEnabled: prefs.getBool('pref_sound_enabled') ?? true,
      isDarkMode: prefs.getBool('pref_dark_mode') ?? false,
      dailyGoalMinutes: prefs.getInt('pref_daily_goal_minutes') ?? 120,
      weeklyGoalHours: prefs.getInt('pref_weekly_goal_hours') ?? 15,
      shareProgress: prefs.getBool('pref_share_progress') ?? false,
      primaryColorIndex: prefs.getInt('pref_primary_color_index') ?? 0,
    );
  }

  Future<void> toggleStudyReminders(bool val) async {
    state = state.copyWith(studyReminders: val);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_study_reminders', val);
  }

  Future<void> toggleStreakAlerts(bool val) async {
    state = state.copyWith(streakAlerts: val);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_streak_alerts', val);
  }

  Future<void> toggleExamDeadlines(bool val) async {
    state = state.copyWith(examDeadlines: val);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_exam_deadlines', val);
  }

  Future<void> toggleSound(bool val) async {
    state = state.copyWith(soundEnabled: val);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_sound_enabled', val);
  }

  Future<void> toggleDarkMode(bool val) async {
    state = state.copyWith(isDarkMode: val);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_dark_mode', val);
  }

  Future<void> setPrimaryColorIndex(int index) async {
    state = state.copyWith(primaryColorIndex: index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pref_primary_color_index', index);
  }

  Future<void> setDailyGoalMinutes(int minutes) async {
    state = state.copyWith(dailyGoalMinutes: minutes);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pref_daily_goal_minutes', minutes);
  }

  Future<void> setWeeklyGoalHours(int hours) async {
    state = state.copyWith(weeklyGoalHours: hours);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pref_weekly_goal_hours', hours);
  }

  Future<void> toggleShareProgress(bool val) async {
    state = state.copyWith(shareProgress: val);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_share_progress', val);
  }
}

final profileSettingsNotifierProvider =
    StateNotifierProvider<ProfileSettingsNotifier, ProfileSettingsState>((ref) {
  return ProfileSettingsNotifier();
});
