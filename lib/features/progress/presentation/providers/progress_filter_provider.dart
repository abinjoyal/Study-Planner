import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/progress_repository.dart';

final progressFilterProvider = StateProvider<ProgressPeriod>((ref) {
  return ProgressPeriod.thisWeek;
});
