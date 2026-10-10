import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/planner_provider.dart';
import '../widgets/add_session_button.dart';
import '../widgets/planner_header.dart';
import '../widgets/schedule_view_toggle.dart';
import '../widgets/study_schedule_list.dart';
import '../widgets/week_calendar.dart';
import 'add_study_session_page.dart';

class PlannerPage extends ConsumerWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(plannerNotifierProvider);
    final notifier = ref.read(plannerNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: state.isLoading && state.sessions.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFF6E1F),
                ),
              )
            : RefreshIndicator(
                onRefresh: () => notifier.init(),
                color: const Color(0xFFFF6E1F),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Title & Calendar Button
                      PlannerHeader(
                        onCalendarTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: state.selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            notifier.selectDate(picked);
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Week Calendar Strip
                      WeekCalendar(
                        days: state.days,
                        selectedDate: state.selectedDate,
                        onDateSelected: (date) {
                          notifier.selectDate(date);
                        },
                      ),
                      const SizedBox(height: 20),

                      // Day / Week / Month Toggle
                      ScheduleViewToggle(
                        currentMode: state.viewMode,
                        onModeChanged: (mode) {
                          notifier.setViewMode(mode);
                        },
                      ),
                      const SizedBox(height: 24),

                      // Study Schedule Items List
                      StudyScheduleList(
                        sessions: state.sessions,
                        onEditSession: (session) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddStudySessionPage(
                                sessionToEdit: session,
                              ),
                            ),
                          );
                        },
                        onDeleteSession: (id) {
                          notifier.removeSession(id);
                        },
                      ),
                      const SizedBox(height: 28),

                      // Add Session Action Button
                      AddSessionButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AddStudySessionPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
