import '../../domain/entities/dashboard.dart';

class HomeState {
  final bool isLoading;
  final Dashboard? dashboard;
  final String? errorMessage;
  final int selectedNavIndex;
  final DateTime? selectedDate;

  const HomeState({
    this.isLoading = true,
    this.dashboard,
    this.errorMessage,
    this.selectedNavIndex = 0,
    this.selectedDate,
  });

  HomeState copyWith({
    bool? isLoading,
    Dashboard? dashboard,
    String? errorMessage,
    int? selectedNavIndex,
    DateTime? selectedDate,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      dashboard: dashboard ?? this.dashboard,
      errorMessage: errorMessage,
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
