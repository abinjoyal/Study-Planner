import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/supabase_service.dart';
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

  runApp(
    const ProviderScope(
      child: StudyPlannerApp(),
    ),
  );
}

class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyPlanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF95700),
          primary: const Color(0xFFF95700),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF9F6),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
