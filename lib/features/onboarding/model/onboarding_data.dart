import 'package:flutter/material.dart';

class OnboardingData {
  final String title;
  final String description;
  final List<String> features;
   final Widget icon;
  final bool isPlansPage;

  OnboardingData({
    required this.title,
    required this.description,
    required this.features,
    required this.icon,
    this.isPlansPage = false,
  });
}

