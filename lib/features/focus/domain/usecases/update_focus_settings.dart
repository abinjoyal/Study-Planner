import '../repositories/focus_repository.dart';

class UpdateFocusSettings {
  final FocusRepository repository;

  UpdateFocusSettings(this.repository);

  Future<void> call({
    required int focusMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
  }) {
    return repository.updateFocusSettings(
      focusMinutes: focusMinutes,
      shortBreakMinutes: shortBreakMinutes,
      longBreakMinutes: longBreakMinutes,
    );
  }
}
