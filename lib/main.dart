import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/supabase_service.dart';
import 'features/profile/presentation/providers/profile_settings_provider.dart';
import 'features/splash/pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables securely from .env
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {
    // If .env file is missing or in test mode, proceed gracefully
  }

  // Initialize Supabase if valid credentials are present in .env
  await SupabaseService.initialize();

  runApp(const ProviderScope(child: StudyPlannerApp()));
}

class StudyPlannerApp extends ConsumerWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(profileSettingsNotifierProvider);
    final activeColor = settings.activeColor;

    return MaterialApp(
      title: 'StudyPlanner',
      debugShowCheckedModeBanner: false,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: activeColor,
          primary: activeColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF9F6),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: activeColor,
          primary: activeColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
