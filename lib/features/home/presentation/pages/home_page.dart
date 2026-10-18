import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../../planner/presentation/widgets/week_calendar.dart';
import '../../../splash/widgets/splash_background.dart';
import '../providers/home_provider.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/home_header.dart';
import '../widgets/progress_card.dart';
import '../widgets/today_tasks_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);

    final dashboard = state.dashboard;
    final todayTasks = dashboard?.todayTasks ?? [];
    final completedCount =
        dashboard?.completedTasksCount ??
        todayTasks.where((t) => t.isCompleted).length;
    final totalCount = dashboard?.totalTasksCount ?? todayTasks.length;
    final progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;

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
                            dashboard?.hasUnreadNotifications ?? false,
                        onNotificationTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const NotificationsPage(),
                            ),
                          );
                        },
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
                        completedTasks: completedCount,
                        totalTasks: totalCount,
                        progress: progress,
                      ),
                      const SizedBox(height: 24),

                      // 4. Today's Tasks
                      TodayTasksSection(
                        tasks: todayTasks,
                        onToggleTask: (taskId) {
                          notifier.toggleTaskStatus(taskId);
                        },
                        onAddTask: () {
                          AddTaskBottomSheet.show(
                            context,
                            onTaskAdded: (newTask) {
                              notifier.addTask(newTask);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Motivational Card
                      //const MotivationalCard(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
