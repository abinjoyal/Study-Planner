import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyplanner/features/focus/presentation/pages/focus_page.dart';
import 'package:studyplanner/features/planner/presentation/pages/planner_page.dart';

import '../../../splash/widgets/splash_background.dart';
import '../providers/home_provider.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/home_header.dart';
import '../widgets/motivational_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/today_tasks_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);

    final dashboard = state.dashboard;

    Widget body;
    switch (state.selectedNavIndex) {
      case 2:
        body = const FocusPage();
        break;
      case 1:
        body = const PlannerPage();
        break;
      case 0:
      default:
        body = SplashBackground(
          child: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF95700)),
                )
              : RefreshIndicator(
                  onRefresh: () => notifier.loadDashboard(),
                  color: const Color(0xFFF95700),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        // Header with Greeting & Notification
                        HomeHeader(
                          studentName: dashboard?.studentName ?? 'Student',
                          hasNotification:
                              dashboard?.hasUnreadNotifications ?? true,
                          onNotificationTap: () {},
                        ),
                        const SizedBox(height: 20),

                        // Progress Card
                        ProgressCard(
                          completedTasks: dashboard?.completedTasksCount ?? 3,
                          totalTasks: dashboard?.totalTasksCount ?? 6,
                          progress: dashboard?.progressPercentage ?? 0.5,
                        ),
                        const SizedBox(height: 20),

                        // Quick Actions Grid
                        QuickActionGrid(
                          onAddSubject: () {},
                          onCreatePlan: () {
                            notifier.setNavIndex(1);
                          },
                          onFocusTimer: () {
                            notifier.setNavIndex(2);
                          },
                          onViewSyllabus: () {},
                        ),
                        const SizedBox(height: 24),

                        // Today's Tasks Section
                        TodayTasksSection(
                          tasks: dashboard?.todayTasks ?? [],
                          onToggleTask: (taskId) {
                            notifier.toggleTaskStatus(taskId);
                          },
                        ),
                        const SizedBox(height: 8),

                        // Motivational Card
                        const MotivationalCard(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
        );
        break;
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: HomeBottomNavigation(
        selectedIndex: state.selectedNavIndex,
        onItemTapped: (index) {
          notifier.setNavIndex(index);
        },
      ),
    );
  }
}
