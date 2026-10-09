import 'package:flutter/material.dart';

class OnboardingSlideModel {
  final String imagePath;
  final String titlePrefix;
  final String titleHighlight;
  final String description;
  final String buttonText;
  final Color buttonColor;

  const OnboardingSlideModel({
    required this.imagePath,
    required this.titlePrefix,
    required this.titleHighlight,
    required this.description,
    required this.buttonText,
    required this.buttonColor,
  });
}

class OnboardingContent extends StatelessWidget {
  final OnboardingSlideModel model;

  const OnboardingContent({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 3D Illustration Container
          SizedBox(
            height: screenHeight * 0.38,
            child: Center(
              child: Image.asset(
                model.imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Title Text with Highlight Color
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                height: 1.2,
              ),
              children: [
                TextSpan(
                  text: model.titlePrefix,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                  ),
                ),
                TextSpan(
                  text: model.titleHighlight,
                  style: const TextStyle(
                    color: Color(0xFFF95700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Subtitle / Description Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              model.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
