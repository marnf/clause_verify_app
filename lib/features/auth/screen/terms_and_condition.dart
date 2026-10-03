// import 'package:clause_verify/core/utils/constants/app_sizer.dart';
// import 'package:clause_verify/features/auth/controller/terms_and_conditions_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class TermsAndCondition extends StatelessWidget {
//   TermsAndCondition({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(TermsConditionsController());

//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // ── Title (no back button) ──
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
//               child: Text(
//                 'aiDisclaimerTitle'.tr,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),

//             // ── Scrollable Content ──
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(horizontal: 24.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 8.h),

//                     // ── Header ──
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF1A1A1A),
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                                 color: const Color(0xFF2E2E2E), width: 1),
//                           ),
//                           child: const Icon(
//                             Icons.gavel_rounded,
//                             color: Color(0xFFC9952A),
//                             size: 20,
//                           ),
//                         ),
//                         SizedBox(width: 12.w),
//                         Expanded(
//                           child: Text(
//                             'aiDisclaimerTitle'.tr,
//                             style: TextStyle(
//                               color: const Color(0xFFC9952A),
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8.h),

//                     Text(
//                       'aiDisclaimerIntro'.tr,
//                       style: TextStyle(
//                         color: const Color(0xFFB0A090),
//                         fontSize: 13.sp,
//                       ),
//                     ),
//                     SizedBox(height: 24.h),

//                     // ── Section 1: What ClauseVerify is ──
//                     _buildSectionTitle('aiDisclaimerWhatIsTitle'.tr),
//                     SizedBox(height: 10.h),
//                     _buildBodyText('aiDisclaimerWhatIsBody'.tr),
//                     SizedBox(height: 20.h),

//                     // ── Section 2: What ClauseVerify is not ──
//                     _buildSectionTitle('aiDisclaimerWhatIsNotTitle'.tr),
//                     SizedBox(height: 10.h),
//                     _buildBodyText('aiDisclaimerWhatIsNotBody'.tr),
//                     SizedBox(height: 20.h),

//                     // ── Section 3: Limitations of AI analysis ──
//                     _buildSectionTitle('aiDisclaimerLimitationsTitle'.tr),
//                     SizedBox(height: 10.h),
//                     _buildBodyText('aiDisclaimerLimitationsBody'.tr),
//                     SizedBox(height: 20.h),

//                     // ── Section 4: Your responsibility ──
//                     _buildSectionTitle('aiDisclaimerResponsibilityTitle'.tr),
//                     SizedBox(height: 10.h),
//                     _buildBodyText('aiDisclaimerResponsibilityBody'.tr),
//                     SizedBox(height: 20.h),

//                     // ── Section 5: Your data ──
//                     _buildSectionTitle('aiDisclaimerDataTitle'.tr),
//                     SizedBox(height: 10.h),
//                     _buildBodyText('aiDisclaimerDataBody'.tr),
//                     SizedBox(height: 28.h),

//                     // ── Divider ──
//                     const Divider(color: Color(0xFF2A2A2A), thickness: 1),
//                     SizedBox(height: 24.h),

//                     // ── Checkbox ──
//                     Obx(
//                       () => InkWell(
//                         onTap: controller.toggleCheckbox,
//                         borderRadius: BorderRadius.circular(8),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 22,
//                               height: 22,
//                               margin: const EdgeInsets.only(top: 1),
//                               decoration: BoxDecoration(
//                                 color: controller.isAgreed.value
//                                     ? const Color(0xFFC9952A)
//                                     : Colors.transparent,
//                                 border: Border.all(
//                                   color: controller.isAgreed.value
//                                       ? const Color(0xFFC9952A)
//                                       : const Color(0xFF6E6E6E),
//                                   width: 1.5,
//                                 ),
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: controller.isAgreed.value
//                                   ? const Icon(
//                                       Icons.check_rounded,
//                                       color: Colors.white,
//                                       size: 15,
//                                     )
//                                   : null,
//                             ),
//                             SizedBox(width: 12.w),
//                             Expanded(
//                               child: Text(
//                                 'iHaveReadAndAgreeToTheTermsOfUseAiDisclaimer'.tr,
//                                 style: TextStyle(
//                                   color: const Color(0xFFB0A090),
//                                   fontSize: 14.sp,
//                                   height: 1.5,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 24.h),

//                     // ── Accept Button ──
//                     Obx(
//                       () => SizedBox(
//                         width: double.infinity,
//                         height: 54.h,
//                         child: ElevatedButton(
//                           onPressed: controller.isAgreed.value
//                               ? controller.onAcceptPressed
//                               : null,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFC9952A),
//                             disabledBackgroundColor:
//                                 const Color(0xFFC9952A).withOpacity(0.35),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             elevation: 0,
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 12.w, vertical: 0),
//                           ),
//                           child: FittedBox(
//                             fit: BoxFit.scaleDown,
//                             child: Text(
//                               'acceptContinue'.tr,
//                               style: TextStyle(
//                                 color: controller.isAgreed.value
//                                     ? Colors.white
//                                     : Colors.white38,
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w700,
//                                 letterSpacing: 0.5,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: 16.h),

//                     // ── Footer ──
//                     Center(
//                       child: Text(
//                         'Qlox Inc. • Ontario, Canada • Qloxinc@gmail.com',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: const Color(0xFF6E6E6E),
//                           fontSize: 11.sp,
//                           height: 1.6,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 32.h),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         color: Colors.white,
//         fontSize: 16,
//         fontWeight: FontWeight.w700,
//         letterSpacing: 0.2,
//       ),
//     );
//   }

//   Widget _buildBodyText(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         color: Color(0xFFB0A090),
//         fontSize: 13,
//         height: 1.6,
//       ),
//     );
//   }
// }





import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/auth/controller/terms_and_conditions_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAndCondition extends StatelessWidget {
  TermsAndCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsConditionsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Title (no back button) ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Text(
                'aiDisclaimerTitle'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),

                    // ── Header ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.cardBorder, width: 1),
                          ),
                          child: Icon(
                            Icons.gavel_rounded,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'aiDisclaimerTitle'.tr,
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    Text(
                      'aiDisclaimerIntro'.tr,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ── Section 1: What ClauseVerify is ──
                    _buildSectionTitle('aiDisclaimerWhatIsTitle'.tr),
                    SizedBox(height: 10.h),
                    _buildBodyText('aiDisclaimerWhatIsBody'.tr),
                    SizedBox(height: 20.h),

                    // ── Section 2: What ClauseVerify is not ──
                    _buildSectionTitle('aiDisclaimerWhatIsNotTitle'.tr),
                    SizedBox(height: 10.h),
                    _buildBodyText('aiDisclaimerWhatIsNotBody'.tr),
                    SizedBox(height: 20.h),

                    // ── Section 3: Limitations of AI analysis ──
                    _buildSectionTitle('aiDisclaimerLimitationsTitle'.tr),
                    SizedBox(height: 10.h),
                    _buildBodyText('aiDisclaimerLimitationsBody'.tr),
                    SizedBox(height: 20.h),

                    // ── Section 4: Your responsibility ──
                    _buildSectionTitle('aiDisclaimerResponsibilityTitle'.tr),
                    SizedBox(height: 10.h),
                    _buildBodyText('aiDisclaimerResponsibilityBody'.tr),
                    SizedBox(height: 20.h),

                    // ── Section 5: Your data ──
                    _buildSectionTitle('aiDisclaimerDataTitle'.tr),
                    SizedBox(height: 10.h),
                    _buildBodyText('aiDisclaimerDataBody'.tr),
                    SizedBox(height: 28.h),

                    // ── Divider ──
                    Divider(color: AppColors.divider, thickness: 1),
                    SizedBox(height: 24.h),

                    // ── Checkbox ──
                    Obx(
                      () => InkWell(
                        onTap: controller.toggleCheckbox,
                        borderRadius: BorderRadius.circular(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              margin: const EdgeInsets.only(top: 1),
                              decoration: BoxDecoration(
                                color: controller.isAgreed.value
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                                border: Border.all(
                                  color: controller.isAgreed.value
                                      ? AppColors.primaryColor
                                      : AppColors.textMuted,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: controller.isAgreed.value
                                  ? Icon(
                                      Icons.check_rounded,
                                      color: AppColors.black,
                                      size: 15,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                'iHaveReadAndAgreeToTheTermsOfUseAiDisclaimer'.tr,
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 14.sp,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ── Accept Button ──
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: ElevatedButton(
                          onPressed: controller.isAgreed.value
                              ? controller.onAcceptPressed
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            disabledBackgroundColor:
                                AppColors.primaryColor.withOpacity(0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 0),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'acceptContinue'.tr,
                              style: TextStyle(
                                color: controller.isAgreed.value
                                    ? AppColors.black
                                    : AppColors.black38,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // ── Footer ──
                    Center(
                      child: Text(
                        'Qlox Inc. • Ontario, Canada • Qloxinc@gmail.com',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11.sp,
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textMuted,
        fontSize: 13,
        height: 1.6,
      ),
    );
  }
}