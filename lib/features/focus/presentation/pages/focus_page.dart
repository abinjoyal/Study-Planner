import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/focus_stats_provider.dart';
import '../providers/focus_timer_provider.dart';
import '../widgets/focus_header.dart';
import '../widgets/focus_mode_selector.dart';
import '../widgets/focus_quote_card.dart';
import '../widgets/focus_timer_circle.dart';
import '../widgets/focus_timer_controls.dart';
import '../widgets/today_focus_section.dart';
import 'focus_history_page.dart';
import 'focus_settings_page.dart';

class FocusPage extends ConsumerWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(focusTimerNotifierProvider);
    final timerNotifier = ref.read(focusTimerNotifierProvider.notifier);

    final statsState = ref.watch(focusStatsNotifierProvider);

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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FocusHistoryPage(),
                    ),
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
              const SizedBox(height: 28),

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

              // Quote Card
              const FocusQuoteCard(),
              const SizedBox(height: 24),

              // Today's Focus Stats Section
              TodayFocusSection(
                totalFocusFormatted: statsState.totalFocusFormatted,
                sessionCount: statsState.sessionCount,
                onSeeAllTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FocusHistoryPage(),
                    ),
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
