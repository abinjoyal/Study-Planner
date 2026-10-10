import 'package:flutter_riverpod/flutter_riverpod.dart';

class FocusSettingsState {
  final int focusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;

  const FocusSettingsState({
    this.focusMinutes = 25,
    this.shortBreakMinutes = 5,
    this.longBreakMinutes = 15,
  });

  FocusSettingsState copyWith({
    int? focusMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
  }) {
    return FocusSettingsState(
      focusMinutes: focusMinutes ?? this.focusMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
    );
  }
}

class FocusSettingsNotifier extends StateNotifier<FocusSettingsState> {
  FocusSettingsNotifier() : super(const FocusSettingsState());

  void updateSettings({
    required int focusMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
  }) {
    state = state.copyWith(
      focusMinutes: focusMinutes,
      shortBreakMinutes: shortBreakMinutes,
      longBreakMinutes: longBreakMinutes,
    );
  }
}

final focusSettingsNotifierProvider =
    StateNotifierProvider<FocusSettingsNotifier, FocusSettingsState>((ref) {
  return FocusSettingsNotifier();
});
