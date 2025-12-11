import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../model/onboarding_model.dart';

class OnboardingData {
  static List<OnboardingModel> pages = [
    OnboardingModel(
      title: 'Start Earning Today',
      description:
          'Drive on your schedule and maximize your earnings with smart route planning.',
      icon: Icons.attach_money_rounded,
      color: AppColors.accent,
      iconColor: AppColors.accentLight,
    ),
    OnboardingModel(
      title: 'Real-Time Navigation',
      description:
          'Get the fastest routes with live traffic updates. Save time and fuel with our advanced navigation.',
      icon: Icons.navigation_rounded,
      color: AppColors.success,
      iconColor: const Color(0xFF74EDD0),
    ),
    OnboardingModel(
      title: 'Track Your Performance',
      description:
          'Monitor your earnings, trips, and ratings. Set goals and watch your driver business grow.',
      icon: Icons.trending_up_rounded,
      color: AppColors.info,
      iconColor: const Color(0xFF5BC4E8),
    ),
  ];
}
