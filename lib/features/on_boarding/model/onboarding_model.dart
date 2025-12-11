import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color iconColor;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.iconColor,
  });
}
