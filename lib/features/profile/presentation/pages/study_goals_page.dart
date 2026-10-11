import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_settings_provider.dart';

class StudyGoalsPage extends ConsumerWidget {
  const StudyGoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(profileSettingsNotifierProvider);
    final notifier = ref.read(profileSettingsNotifierProvider.notifier);

    final dailyHours = (settings.dailyGoalMinutes / 60).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F6),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Study Goals',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Target Motivation Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.stars_rounded,
                            color: Color(0xFFFFD166), size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Your Learning Commitment',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Targeting $dailyHours hours daily and ${settings.weeklyGoalHours} hours weekly.',
                      style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Daily Study Target
              const Text(
                'Daily Study Target',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Set the target hours you aim to focus each day',
                style: TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Target Duration',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEDD5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$dailyHours hrs / day',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFEA580C),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFFF95700),
                        thumbColor: const Color(0xFFF95700),
                        overlayColor:
                            const Color(0xFFF95700).withValues(alpha: 0.15),
                        inactiveTrackColor: const Color(0xFFE2E8F0),
                        trackHeight: 6,
                      ),
                      child: Slider(
                        value: settings.dailyGoalMinutes.toDouble(),
                        min: 30,
                        max: 360,
                        divisions: 11,
                        label: '$dailyHours hrs',
                        onChanged: (val) {
                          notifier.setDailyGoalMinutes(val.toInt());
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('30 mins',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF94A3B8))),
                          Text('3 hrs',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF94A3B8))),
                          Text('6 hrs',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Weekly Goal
              const Text(
                'Weekly Study Goal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [10, 15, 20, 25].map((hours) {
                  final isSelected = settings.weeklyGoalHours == hours;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => notifier.setWeeklyGoalHours(hours),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFF95700)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFF95700)
                                : const Color(0xFFE2E8F0),
                            width: 1.2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFF95700)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : null,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$hours hrs',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'per week',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Share Progress Switch
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.share_rounded,
                        color: Color(0xFF16A34A),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Show in Study Leaderboard',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Allow peers to view your completed study goals',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: settings.shareProgress,
                      activeTrackColor: const Color(0xFFF95700),
                      onChanged: notifier.toggleShareProgress,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
