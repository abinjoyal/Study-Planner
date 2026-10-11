import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class SupabaseService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    try {
      if (AppConstants.supabaseUrl.isNotEmpty &&
          AppConstants.supabaseUrl != 'YOUR_SUPABASE_URL' &&
          !AppConstants.supabaseUrl.contains('your-project') &&
          AppConstants.supabaseAnonKey != 'YOUR_SUPABASE_ANON_KEY' &&
          !AppConstants.supabaseAnonKey.contains('your-anon-key')) {
        await Supabase.initialize(
          url: AppConstants.supabaseUrl,
          publishableKey: AppConstants.supabaseAnonKey,
        );
        _initialized = true;
      }
    } catch (_) {
      _initialized = false;
    }
  }

  static bool get isInitialized {
    if (_initialized) return true;
    try {
      Supabase.instance.client;
      return true;
    } catch (_) {
      return false;
    }
  }

  static SupabaseClient? get client {
    if (!isInitialized) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  static User? get currentUser {
    try {
      return client?.auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  static bool get isAuthenticated => currentUser != null;
}
