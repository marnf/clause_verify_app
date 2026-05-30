import 'package:flutter_extension/core/localization/language_constants.dart';
import 'package:flutter_extension/core/localization/localization_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';

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
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2E2E2E), width: 1),
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
                          color: const Color(0xFF1A1A1A),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF2E2E2E), width: 1),
                        ),
                        child: const Icon(
                          Icons.language_rounded,
                          color: Color(0xFFC9952A),
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
                                color: Colors.white,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'selectYourPreferredLanguage'.tr,
                              style: TextStyle(
                                color: const Color(0xFF6E6E6E),
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
                              color: const Color(0xFF1A1A1A),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFF2E2E2E), width: 1),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF6E6E6E),
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // ── Divider ──
                const Divider(color: Color(0xFF1E1E1E), height: 1),

                // ── Language List ──
                ...languages.map((lang) {
                  final isSelected = lang.languageCode == currentCode;
                  final isLoading = isUpdating && !isSelected;

                  return InkWell(
                    onTap: isUpdating
                        ? null
                        : () async {
                            if (isSelected) {
                              if (Get.isDialogOpen ?? false) Get.back();
                              return;
                            }
                            if (isOnboarding) {
                              await controller.changeLanguageByCode(
                                lang.languageCode,
                                skipServerUpdate: true,
                              );
                            } else {
                              await controller.changeLanguageByCode(
                                lang.languageCode,
                              );
                            }
                            if (Get.isDialogOpen ?? false) Get.back();
                          },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFC9952A).withOpacity(0.08)
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
                                    ? const Color(0xFFC9952A)
                                    : Colors.white,
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
                                color: const Color(0xFFC9952A).withOpacity(0.5),
                              ),
                            )
                          else if (isSelected)
                            Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: Color(0xFFC9952A),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
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