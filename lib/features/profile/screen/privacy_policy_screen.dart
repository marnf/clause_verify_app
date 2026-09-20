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
      appBar: CustomAppBar(title: 'privacyPolicy'.tr), // এখানে পরিবর্তন করা হয়েছে
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        children: [
          Text(
            'yourDataProtectionRights'.tr, // এখানে পরিবর্তন করা হয়েছে
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'privacyPolicyIntro'.tr, // এখানে পরিবর্তন করা হয়েছে
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
        ...section.content.asMap().entries.map((entry) { // এখানে লজিক পরিবর্তন করা হয়েছে
          final index = entry.key;
          final text = entry.value;
          
          // যেহেতু "We do not sell" লাইনটি privacyTitle4 এর প্রথম content (privacyContent4_1)
          // তাই আমরা ইনডেক্স দিয়ে চেক করছি, যাতে সব ভাষায় কাজ করে।
          final isHighlighted = section.title == 'privacyTitle4'.tr && index == 0;

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