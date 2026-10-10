import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/subject_progress.dart';
import '../providers/progress_provider.dart';

class ProgressDetailsPage extends ConsumerWidget {
  final SubjectProgress? selectedSubject;

  const ProgressDetailsPage({
    super.key,
    this.selectedSubject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(getProgressHistoryUseCaseProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text(
          selectedSubject != null
              ? '${selectedSubject!.subjectName} Details'
              : 'Progress Details',
          style: const TextStyle(
            color: Color(0xFF1B1C4B),
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1B1C4B)),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: historyAsync.call(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6E1F)),
            );
          }

          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedSubject != null) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedSubject!.subjectName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1B1C4B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${selectedSubject!.completedTasks} completed out of ${selectedSubject!.totalTasks} tasks',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${selectedSubject!.completionPercentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: selectedSubject!.themeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                const Text(
                  'Weekly Activity Log',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1B1C4B),
                  ),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = data[index];
                      final minutes = item['minutes'] as int;
                      final hours = minutes ~/ 60;
                      final remainingMins = minutes % 60;
                      final timeStr = hours > 0
                          ? '${hours}h ${remainingMins}m'
                          : '${remainingMins}m';

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['day'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1B1C4B),
                              ),
                            ),
                            Text(
                              timeStr,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFF6E1F),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
