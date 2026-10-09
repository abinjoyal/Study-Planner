import 'package:flutter/material.dart';
import 'features/splash/pages/splash_page.dart';

void main() {
  runApp(const StudyPlannerApp());
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
