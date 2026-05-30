import 'package:flutter/material.dart';
import 'package:flutter_extension/core/common/widgets/app_bar.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/features/profile/controller/terms_of_use_controller.dart';
import 'package:get/get.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsOfUseController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(title: 'Terms of Use'.tr),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        children: [
          Text(
            'ChronoVerify – Legal Terms and Conditions'.tr,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'By accessing or using the ChronoVerify application, you agree to these Terms of Use. If you do not agree, you must discontinue use of the Application.'
                .tr,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          ...controller.sections.map(
            (section) => _TermsSectionWidget(section: section),
          ),
        ],
      ),
    );
  }
}

class _TermsSectionWidget extends StatelessWidget {
  final TermsSection section;

  const _TermsSectionWidget({required this.section});

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
        Text(
          section.content,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            height: 1.7,
          ),
        ),
        const Divider(color: AppColors.divider, height: 28),
        const SizedBox(height: 2),
      ],
    );
  }
}
