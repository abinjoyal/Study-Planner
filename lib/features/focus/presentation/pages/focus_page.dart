import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyplanner/features/home/presentation/providers/home_provider.dart';
import '../providers/focus_stats_provider.dart';
import '../providers/focus_timer_provider.dart';
import '../widgets/focus_header.dart';
import '../widgets/focus_mode_selector.dart';
import '../widgets/focus_timer_circle.dart';
import '../widgets/focus_timer_controls.dart';
import '../widgets/today_focus_section.dart';
import 'focus_history_page.dart';
import 'focus_settings_page.dart';

class FocusPage extends ConsumerStatefulWidget {
  const FocusPage({super.key});

  @override
  ConsumerState<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends ConsumerState<FocusPage> {
  String? _selectedTaskId;

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(focusTimerNotifierProvider);
    final timerNotifier = ref.read(focusTimerNotifierProvider.notifier);
    final statsState = ref.watch(focusStatsNotifierProvider);

    final homeState = ref.watch(homeNotifierProvider);
    final todayTasks = homeState.dashboard?.todayTasks ?? [];
    final pendingTasks = todayTasks.where((t) => !t.isCompleted).toList();

    final activeTask = pendingTasks.where((t) => t.id == _selectedTaskId).firstOrNull
        ?? pendingTasks.firstOrNull
        ?? todayTasks.firstOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              FocusHeader(
                onStatsTap: () {
                  ref.read(focusStatsNotifierProvider.notifier).loadStats();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FocusHistoryPage()),
                  );
                },
                onSettingsTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FocusSettingsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Mode Selector
              FocusModeSelector(
                currentMode: timerState.mode,
                onModeSelected: (mode) {
                  timerNotifier.selectMode(mode);
                },
              ),
              const SizedBox(height: 20),

              // Target Task Banner (if tasks exist)
              if (activeTask != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: activeTask.iconBackgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          activeTask.iconSymbol,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeTask.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              activeTask.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (pendingTasks.length > 1)
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
                          onSelected: (id) => setState(() => _selectedTaskId = id),
                          itemBuilder: (context) {
                            return pendingTasks.map((t) {
                              return PopupMenuItem<String>(
                                value: t.id,
                                child: Text(
                                  t.title,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              );
                            }).toList();
                          },
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Circular Timer
              FocusTimerCircle(
                progress: timerState.progress,
                formattedTime: timerState.formattedRemaining,
                modeLabel: timerState.modeLabel,
              ),
              const SizedBox(height: 28),

              // Controls (Reset, Play/Pause, Skip)
              FocusTimerControls(
                isRunning: timerState.isRunning,
                isPaused: timerState.isPaused,
                onStartPause: () {
                  if (timerState.isRunning && !timerState.isPaused) {
                    timerNotifier.pauseTimer();
                  } else {
                    timerNotifier.startTimer();
                  }
                },
                onReset: () => timerNotifier.resetTimer(),
                onSkip: () => timerNotifier.skipTimer(),
              ),
              const SizedBox(height: 28),

              // Today's Focus Stats Section
              TodayFocusSection(
                totalFocusFormatted: statsState.totalFocusFormatted,
                sessionCount: statsState.sessionCount,
                onSeeAllTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FocusHistoryPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
