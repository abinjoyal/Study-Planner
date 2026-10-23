import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/domain/entities/study_task.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../domain/entities/subject_progress.dart';
import '../providers/progress_provider.dart';
import '../providers/subject_progress_provider.dart';
import '../widgets/subject_progress_card.dart';

class ProgressDetailsPage extends ConsumerStatefulWidget {
  final SubjectProgress? selectedSubject;

  const ProgressDetailsPage({
    super.key,
    this.selectedSubject,
  });

  @override
  ConsumerState<ProgressDetailsPage> createState() => _ProgressDetailsPageState();
}

class _ProgressDetailsPageState extends ConsumerState<ProgressDetailsPage> {
  SubjectProgress? _activeSubject;

  @override
  void initState() {
    super.initState();
    _activeSubject = widget.selectedSubject;
  }

  bool _isTaskForSubject(StudyTask task, String subjectName) {
    final lowerSub = subjectName.toLowerCase();
    final lowerTitle = task.title.toLowerCase();
    final lowerDesc = task.description.toLowerCase();

    if (subjectName == 'Maths' &&
        (task.iconSymbol == 'Σ' || lowerTitle.contains('math') || lowerDesc.contains('math'))) {
      return true;
    }
    if (subjectName == 'Physics' &&
        (task.iconSymbol == '⚛' || lowerTitle.contains('physic') || lowerDesc.contains('physic'))) {
      return true;
    }
    if (subjectName == 'Chemistry' &&
        (task.iconSymbol == '🧪' || lowerTitle.contains('chem') || lowerDesc.contains('chem'))) {
      return true;
    }
    if (subjectName == 'English' &&
        (task.iconSymbol == '📖' || lowerTitle.contains('eng') || lowerDesc.contains('eng'))) {
      return true;
    }
    if (lowerTitle.contains(lowerSub) || lowerDesc.contains(lowerSub)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final subjectsAsync = ref.watch(subjectProgressProvider);
    final historyAsync = ref.watch(progressHistoryProvider);
    final homeState = ref.watch(homeNotifierProvider);
    final allTasks = homeState.dashboard?.todayTasks ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1B1C4B),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _activeSubject != null
              ? '${_activeSubject!.subjectName} Details'
              : 'Progress Details',
          style: const TextStyle(
            color: Color(0xFF1B1C4B),
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1B1C4B)),
        actions: [
          if (_activeSubject != null)
            TextButton.icon(
              onPressed: () {
                setState(() => _activeSubject = null);
              },
              icon: const Icon(Icons.apps_rounded, size: 16, color: Color(0xFFFF6E1F)),
              label: const Text(
                'All Subjects',
                style: TextStyle(
                  color: Color(0xFFFF6E1F),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFFFF6E1F),
        onRefresh: () async {
          ref.read(progressNotifierProvider.notifier).loadData();
          ref.invalidate(progressHistoryProvider);
          ref.invalidate(subjectProgressProvider);
          await ref.read(homeNotifierProvider.notifier).loadDashboard();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Subject Header or Overview
              if (_activeSubject != null) ...[
                _buildSingleSubjectCard(_activeSubject!),
                const SizedBox(height: 24),
                _buildSubjectTasksSection(allTasks, _activeSubject!),
                const SizedBox(height: 24),
              ] else ...[
                subjectsAsync.when(
                  data: (subjects) => _buildAllSubjectsOverview(subjects),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF6E1F)),
                  ),
                  error: (error, stackTrace) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),
              ],

              // 2. Real Weekly Activity Log
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Weekly Activity Log',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B1C4B),
                    ),
                  ),
                  Text(
                    'Mon – Sun',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B1C4B).withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              historyAsync.when(
                data: (data) => _buildWeeklyLogList(data),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: CircularProgressIndicator(color: Color(0xFFFF6E1F)),
                  ),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'Unable to load activity log: $e',
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleSubjectCard(SubjectProgress subject) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: subject.themeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        subject.subjectName.isNotEmpty
                            ? subject.subjectName[0]
                            : 'S',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: subject.themeColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.subjectName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1B1C4B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${subject.completedTasks} of ${subject.totalTasks} tasks completed',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '${subject.completionPercentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: subject.themeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: subject.totalTasks > 0
                  ? (subject.completedTasks / subject.totalTasks).clamp(0.0, 1.0)
                  : 0.0,
              minHeight: 8,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(subject.themeColor),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Study Time',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1B1C4B).withValues(alpha: 0.6),
                ),
              ),
              Text(
                subject.studyTimeFormatted,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: subject.themeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectTasksSection(List<StudyTask> allTasks, SubjectProgress subject) {
    final subjectTasks =
        allTasks.where((t) => _isTaskForSubject(t, subject.subjectName)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tasks for this Subject',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B1C4B),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: subject.themeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${subjectTasks.where((t) => t.isCompleted).length}/${subjectTasks.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: subject.themeColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (subjectTasks.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'No tasks logged for ${subject.subjectName} yet.\nAdd new tasks from the Home tab to track them here.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subjectTasks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final task = subjectTasks[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: task.isCompleted,
                      activeColor: subject.themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      onChanged: (_) async {
                        await ref
                            .read(homeNotifierProvider.notifier)
                            .toggleTaskStatus(task.id);
                        ref.read(progressNotifierProvider.notifier).loadData();
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1B1C4B),
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          if (task.description.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              task.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (task.estimatedTime != null)
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task.estimatedTime!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildAllSubjectsOverview(List<SubjectProgress> subjects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'All Subjects Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B1C4B),
              ),
            ),
            Text(
              'Tap any subject for details',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1B1C4B).withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subjects.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final s = subjects[index];
            return SubjectProgressCard(
              subject: s,
              onTap: () {
                setState(() => _activeSubject = s);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildWeeklyLogList(List<Map<String, dynamic>> data) {
    // Find max minutes to draw proportional bars
    final maxMins = data.fold<int>(
      60,
      (max, item) {
        final m = item['minutes'] as int;
        return m > max ? m : max;
      },
    );

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = data[index];
        final minutes = item['minutes'] as int;
        final isToday = item['isToday'] as bool? ?? false;
        final dateStr = item['date'] as String? ?? '';
        final hours = minutes ~/ 60;
        final remainingMins = minutes % 60;
        final timeStr = hours > 0
            ? '${hours}h ${remainingMins}m'
            : '${remainingMins}m';

        final progressRatio = (minutes / maxMins).clamp(0.0, 1.0);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isToday
                ? Border.all(
                    color: const Color(0xFFFF6E1F).withValues(alpha: 0.4),
                    width: 1.5,
                  )
                : null,
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
              // Day & Date
              SizedBox(
                width: 65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item['day'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isToday
                                ? const Color(0xFFFF6E1F)
                                : const Color(0xFF1B1C4B),
                          ),
                        ),
                        if (isToday) ...[
                          const SizedBox(width: 4),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF6E1F),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (dateStr.isNotEmpty)
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1B1C4B).withValues(alpha: 0.4),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Activity Volume Bar
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progressRatio,
                    minHeight: 7,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      minutes > 0
                          ? const Color(0xFFFF6E1F)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Real Minutes Display
              Text(
                timeStr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: minutes > 0
                      ? const Color(0xFFFF6E1F)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
