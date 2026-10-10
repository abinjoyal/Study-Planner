import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/progress_filter_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/subject_progress_provider.dart';
import '../widgets/achievement_card.dart';
import '../widgets/progress_header.dart';
import '../widgets/progress_period_selector.dart';
import '../widgets/progress_stats_grid.dart';
import '../widgets/study_streak_card.dart';
import '../widgets/subject_progress_section.dart';
import 'progress_details_page.dart';

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(progressNotifierProvider);
    final notifier = ref.read(progressNotifierProvider.notifier);
    final currentPeriod = ref.watch(progressFilterProvider);

    final subjectsAsync = ref.watch(subjectProgressProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: state.isLoading || state.summary == null
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF6E1F)),
              )
            : RefreshIndicator(
                onRefresh: () => notifier.loadData(),
                color: const Color(0xFFFF6E1F),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // My Progress Header Title
                      ProgressHeader(
                        onCalendarTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: state.selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            notifier.selectDate(picked);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Selected Date Filter Badge (If Active)
                      if (state.selectedDate != null) ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF1F0),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFF6E1F,
                                  ).withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.event_note_rounded,
                                    size: 16,
                                    color: Color(0xFFFF6E1F),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Stats for ${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFFF6E1F),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () => notifier.selectDate(null),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 16,
                                      color: Color(0xFFFF6E1F),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Period Selector (This Week / This Month / All Time)
                      ProgressPeriodSelector(
                        currentPeriod: currentPeriod,
                        onPeriodSelected: (period) {
                          notifier.changePeriod(period);
                        },
                      ),
                      const SizedBox(height: 20),

                      // Study Streak Banner
                      if (state.streak != null) ...[
                        StudyStreakCard(streak: state.streak!),
                        const SizedBox(height: 20),
                      ],

                      // Summary Statistics Grid (4 Cards)
                      ProgressStatsGrid(summary: state.summary!),
                      const SizedBox(height: 20),

                      // Achievement Card
                      AchievementCard(
                        weeklyGoalPercentage: state.weeklyGoalPct,
                      ),
                      const SizedBox(height: 24),

                      // Subject Progress Section
                      subjectsAsync.when(
                        data: (subjects) => SubjectProgressSection(
                          subjects: subjects,
                          onSeeAllTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ProgressDetailsPage(),
                              ),
                            );
                          },
                          onSubjectTap: (subject) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProgressDetailsPage(
                                  selectedSubject: subject,
                                ),
                              ),
                            );
                          },
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF6E1F),
                          ),
                        ),
                        error: (error, stackTrace) => const SizedBox.shrink(),
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
