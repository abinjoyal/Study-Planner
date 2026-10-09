import '../../domain/entities/dashboard.dart';

class HomeState {
  final bool isLoading;
  final Dashboard? dashboard;
  final String? errorMessage;
  final int selectedNavIndex;

  const HomeState({
    this.isLoading = true,
    this.dashboard,
    this.errorMessage,
    this.selectedNavIndex = 0,
  });

  HomeState copyWith({
    bool? isLoading,
    Dashboard? dashboard,
    String? errorMessage,
    int? selectedNavIndex,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      dashboard: dashboard ?? this.dashboard,
      errorMessage: errorMessage,
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
    );
  }
}
