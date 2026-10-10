import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/subject_progress.dart';
import '../../domain/repositories/progress_repository.dart';
import 'progress_filter_provider.dart';
import 'progress_provider.dart';

final subjectProgressProvider =
    FutureProvider<List<SubjectProgress>>((ref) async {
  final period = ref.watch(progressFilterProvider);
  final getSubjectProgressUseCase =
      ref.watch(getSubjectProgressUseCaseProvider);
  return await getSubjectProgressUseCase(period);
});
