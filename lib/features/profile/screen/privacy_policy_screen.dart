import 'package:flutter/material.dart';
import 'package:clause_verify/core/common/widgets/app_bar.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/profile/controller/privacy_policy_controller.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrivacyPolicyController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Privacy Policy'.tr),
     body: ListView(
  padding: EdgeInsets.symmetric(horizontal: 16.h),
  children: [
    Text(
      'Your Data Protection Rights'.tr,
      style: const TextStyle(
        color: AppColors.gold,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
    const SizedBox(height: 8),
    Text(
      'clauseverify respects your privacy and is committed to protecting your personal data. This Privacy Policy explains how your information is collected, used, and protected when you use the clauseverify application and services.'.tr,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
        height: 1.6,
      ),
    ),
    const SizedBox(height: 20),
    ...controller.sections.map((section) => _PrivacySectionWidget(section: section)),
  ],
),
    );
  }
}

class _PrivacySectionWidget extends StatelessWidget {
  final PrivacySection section;

  const _PrivacySectionWidget({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        ...section.content.map((text) {
          final isHighlighted = text.startsWith('We do not sell');
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: isHighlighted
                ? Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
          );
        }),
        const Divider(color: AppColors.divider, height: 24),
        const SizedBox(height: 4),
      ],
    );
  }
}
