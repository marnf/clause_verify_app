


import 'package:clause_verify/core/localization/language_constants.dart';
import 'package:clause_verify/core/localization/localization_controller.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';

class LanguageModal extends StatelessWidget {
  final bool isOnboarding;

  const LanguageModal({
    Key? key,
    this.isOnboarding = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: GetBuilder<LocalizationController>(
          builder: (controller) {
            final currentCode = controller.locale.languageCode;
            final isUpdating = controller.isUpdating;
            final languages = LanguageConstants.supportedLanguages;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header ──
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.navy,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.cardBorder, width: 1),
                        ),
                        child: const Icon(
                          Icons.language_rounded,
                          color: AppColors.primaryColor,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'language'.tr,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'selectYourPreferredLanguage'.tr,
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Close button — only when not onboarding
                      if (!isOnboarding)
                        GestureDetector(
                          onTap: () {
                            if (Get.isDialogOpen ?? false) Get.back();
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.navy,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.cardBorder, width: 1),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: AppColors.textMuted,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // ── Divider ──
                const Divider(color: AppColors.divider, height: 1),

                // ── Language List ──
                ...languages.map((lang) {
                  final isSelected = lang.languageCode == currentCode;
                  // যেহেতু সার্ভারে হিট করবে না, তাই loading state আর দরকার নেই, 
                  // তবুও কোডটা রেখে দিলাম যাতে UI ঠিক থাকে।
                  final isLoading = false; 

                  return InkWell(
                    onTap: isUpdating
                        ? null
                        : () async {
                            if (isSelected) {
                              if (Get.isDialogOpen ?? false) Get.back();
                              return;
                            }
                            
                            // ✅ এখানে পরিবর্তন করা হয়েছে: সবসময় skipServerUpdate: true পাস করা হচ্ছে
                            await controller.changeLanguageLocally(lang.languageCode);

                            if (Get.isDialogOpen ?? false) Get.back();
                          },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor.withOpacity(0.08)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          // Flag
                          Text(
                            lang.flag,
                            style: const TextStyle(fontSize: 22),
                          ),
                          SizedBox(width: 14.w),

                          // Language name
                          Expanded(
                            child: Text(
                              lang.languageName,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.white,
                                fontSize: 15.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),

                          // Right side: check or loading
                          if (isLoading)
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryColor.withOpacity(0.5),
                              ),
                            )
                          else if (isSelected)
                            Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: AppColors.black,
                                size: 14,
                              ),
                            )
                          else
                            const SizedBox(width: 22),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                SizedBox(height: 8.h),
              ],
            );
          },
        ),
      ),
    );
  }
}