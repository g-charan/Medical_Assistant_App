import 'package:flutter/material.dart';

/// Onboarding page data
class OnboardingPageData {
  /// Page title
  final String title;

  /// Page description
  final String description;

  /// Page icon
  final IconData icon;

  /// Constructor
  OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

/// Onboarding page widget
class OnboardingPage extends StatelessWidget {
  /// Page data
  final OnboardingPageData data;

  /// Constructor
  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 60, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
