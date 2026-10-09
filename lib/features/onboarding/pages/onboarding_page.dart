import 'package:flutter/material.dart';
import '../../splash/widgets/splash_background.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_button.dart';

class OnboardingPage extends StatefulWidget {
  final VoidCallback? onOnboardingComplete;

  const OnboardingPage({
    super.key,
    this.onOnboardingComplete,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<OnboardingSlideModel> _slides = [
    OnboardingSlideModel(
      imagePath: 'assets/images/onboarding/onboarding_1.png',
      titlePrefix: 'Plan Your ',
      titleHighlight: 'Studies',
      description:
          'Organize your subjects and build\na study plan that works for you.',
      buttonText: 'Next',
      buttonColor: Color(0xFFF95700),
    ),
    OnboardingSlideModel(
      imagePath: 'assets/images/onboarding/onboarding_2.png',
      titlePrefix: 'Stay ',
      titleHighlight: 'Focused',
      description:
          'Break your study goals into\nmanageable sessions and\navoid distractions.',
      buttonText: 'Next',
      buttonColor: Color(0xFFF95700),
    ),
    OnboardingSlideModel(
      imagePath: 'assets/images/onboarding/onboarding_3.png',
      titlePrefix: 'Track Your ',
      titleHighlight: 'Progress',
      description:
          'See what you\'ve completed,\nmonitor your goals, and prepare\nconfidently for exams.',
      buttonText: 'Get Started',
      buttonColor: Color(0xFF2563EB),
    ),
  ];

  void _onNextPressed() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onOnboardingComplete?.call();
    }
  }

  void _onSkipPressed() {
    widget.onOnboardingComplete?.call();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSlide = _slides[_currentPage];

    return Scaffold(
      body: SplashBackground(
        child: Column(
          children: [
            // Top Bar with Skip Button
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _onSkipPressed,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // PageView Slider
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingContent(model: _slides[index]);
                },
              ),
            ),

            // Bottom Navigation Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Dot Indicators
                  OnboardingIndicator(
                    count: _slides.length,
                    currentIndex: _currentPage,
                  ),
                  const SizedBox(height: 28),

                  // Next / Get Started Action Button
                  OnboardingButton(
                    text: currentSlide.buttonText,
                    backgroundColor: currentSlide.buttonColor,
                    onPressed: _onNextPressed,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
