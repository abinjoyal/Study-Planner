import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../planner/presentation/widgets/week_calendar.dart';
import '../../../splash/widgets/splash_background.dart';
import '../providers/home_provider.dart';
import '../widgets/home_header.dart';
import '../widgets/motivational_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/today_tasks_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);

    final dashboard = state.dashboard;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SplashBackground(
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
                      // 1. Heading
                      HomeHeader(
                        studentName: dashboard?.studentName ?? 'Student',
                        hasNotification:
                            dashboard?.hasUnreadNotifications ?? true,
                        onNotificationTap: () {},
                      ),
                      const SizedBox(height: 16),

                      // 2. Week Calendar Strip
                      WeekCalendar(
                        days: const [],
                        selectedDate: state.selectedDate ?? DateTime.now(),
                        onDateSelected: (date) {
                          notifier.selectDate(date);
                        },
                      ),
                      const SizedBox(height: 20),

                      // 3. Progress Banner
                      ProgressCard(
                        completedTasks: dashboard?.completedTasksCount ?? 3,
                        totalTasks: dashboard?.totalTasksCount ?? 6,
                        progress: dashboard?.progressPercentage ?? 0.5,
                      ),
                      const SizedBox(height: 24),

                      // 4. Today's Tasks
                      TodayTasksSection(
                        tasks: dashboard?.todayTasks ?? [],
                        onToggleTask: (taskId) {
                          notifier.toggleTaskStatus(taskId);
                        },
                      ),
                      const SizedBox(height: 12),

                      // Motivational Card
                      const MotivationalCard(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
