import '../models/focus_session_model.dart';

abstract class FocusRemoteDataSource {
  Future<void> syncFocusSession(FocusSessionModel session);
}

class FocusRemoteDataSourceImpl implements FocusRemoteDataSource {
  @override
  Future<void> syncFocusSession(FocusSessionModel session) async {
    // Stub remote sync operation (Supabase/Dio)
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
