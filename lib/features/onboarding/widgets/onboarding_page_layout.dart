import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';

/// The layout shared by all onboarding pages:
/// illustration on top, then tagline, title and description.
class OnboardingPageLayout extends StatelessWidget {
  final Widget illustration;
  final String tagline;
  final String title;
  final String description;

  const OnboardingPageLayout({
    super.key,
    required this.illustration,
    required this.tagline,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Takes all the space that is left above the texts.
          Expanded(child: illustration),
          const SizedBox(height: 20),
          Text(
            tagline.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'JakartaSans',
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'JakartaSans',
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'JakartaSans',
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}