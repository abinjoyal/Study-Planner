class AppConstants {
  static const String appName = 'Study Planner';
  static const String appVersion = '1.0.0';

  // API & Network
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Supabase (Replace with actual values or environment variables)
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
