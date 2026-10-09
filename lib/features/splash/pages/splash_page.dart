import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/presentation/pages/home_page.dart';
import '../../onboarding/pages/onboarding_page.dart';
import '../widgets/splash_background.dart';
import '../widgets/splash_logo.dart';
import '../widgets/splash_title.dart';
import '../widgets/splash_progress_bar.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback? onInitializationComplete;

  const SplashPage({
    super.key,
    this.onInitializationComplete,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  double _progress = 0.0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();
    _startLoadingProgress();
  }

  void _startLoadingProgress() {
    const totalSteps = 50;
    const stepDuration = Duration(milliseconds: 40);
    int currentStep = 0;

    _progressTimer = Timer.periodic(stepDuration, (timer) {
      if (!mounted) return;
      currentStep++;
      setState(() {
        _progress = currentStep / totalSteps;
      });

      if (currentStep >= totalSteps) {
        timer.cancel();
        _onLoadingFinished();
      }
    });
  }

  Future<void> _onLoadingFinished() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isOnboardingCompleted =
        prefs.getBool('isOnboardingCompleted') ?? false;

    if (!mounted) return;

    if (widget.onInitializationComplete != null) {
      widget.onInitializationComplete!();
    } else {
      if (isOnboardingCompleted) {
        // Subsequent launches: Splash -> Home directly
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        // First launch: Splash -> Onboarding
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const OnboardingPage(),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            
            // Central Logo Widget
            SplashLogo(animation: _fadeAnimation),
            
            const SizedBox(height: 28),
            
            // Branding Title & Tagline
            SplashTitle(animation: _fadeAnimation),
            
            const Spacer(flex: 4),
            
            // Bottom Loading Bar
            SplashProgressBar(progress: _progress),
            
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
