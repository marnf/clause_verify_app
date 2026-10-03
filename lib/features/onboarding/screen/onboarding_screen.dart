
// import 'package:clause_verify/core/utils/constants/app_colors.dart';
// import 'package:clause_verify/core/utils/constants/app_sizer.dart';
// import 'package:clause_verify/features/onboarding/controller/onboarding_controller.dart';
// import 'package:clause_verify/features/onboarding/model/onboarding_data.dart';
// import 'package:clause_verify/core/common/widgets/language_modal.dart';
// import 'package:clause_verify/core/localization/localization_controller.dart';
// import 'package:clause_verify/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class OnboardingScreen extends StatelessWidget {
//   final OnboardingController controller = Get.put(OnboardingController());

//   @override
//   Widget build(BuildContext context) {
//     final List<OnboardingData> pages = [
//       OnboardingData(
//         title: 'onboarding1Title'.tr,
//         description: 'onboarding1Description'.tr,
//         features: [
//           'onboarding1Feature1'.tr,
//           'onboarding1Feature2'.tr,
//           'onboarding1Feature3'.tr,
//         ],
//         icon: Icon(
//           Icons.document_scanner_rounded,
//           color: AppColors.primaryColor,
//           size: 40,
//         ),
//         isPlansPage: false,
//       ),
//       OnboardingData(
//         title: 'onboarding2Title'.tr,
//         description: 'onboarding2Description'.tr,
//         features: [
//           'onboarding2Feature1'.tr,
//           'onboarding2Feature2'.tr,
//           'onboarding2Feature3'.tr,
//         ],
//         icon: Icon(
//           Icons.warning_amber_rounded,
//           color: AppColors.primaryColor,
//           size: 40,
//         ),
//         isPlansPage: false,
//       ),
//       OnboardingData(
//         title: 'onboarding3Title'.tr,
//         description: 'onboarding3Description'.tr,
//         features: [
//           'onboarding3Feature1'.tr,
//           'onboarding3Feature2'.tr,
//           'onboarding3Feature3'.tr,
//         ],
//         icon: Icon(
//           Icons.picture_as_pdf_rounded,
//           color: AppColors.primaryColor,
//           size: 40,
//         ),
//         isPlansPage: false,
//       ),
//     ];

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Get.dialog(
//                         const LanguageModal(isOnboarding: true),
//                         barrierDismissible: false,
//                       );
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 12.w, vertical: 8.h),
//                       decoration: BoxDecoration(
//                         color: AppColors.surfaceLight,
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                             color: AppColors.cardBorder, width: 1),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.language_rounded,
//                             color: AppColors.primaryColor,
//                             size: 16,
//                           ),
//                           SizedBox(width: 6.w),
//                           GetBuilder<LocalizationController>(
//                             builder: (lc) {
//                               final code = lc.locale.languageCode.toUpperCase();
//                               return Text(
//                                 code,
//                                 style: TextStyle(
//                                   color: AppColors.primaryColor,
//                                   fontSize: 13.sp,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               );
//                             },
//                           ),
//                           SizedBox(width: 4.w),
//                           Icon(
//                             Icons.keyboard_arrow_down_rounded,
//                             color: AppColors.primaryColor,
//                             size: 16,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () => Get.offNamed(AppRoute.loginScreen),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 16.w, vertical: 8.h),
//                       decoration: BoxDecoration(
//                         color: AppColors.surfaceLight,
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                             color: AppColors.cardBorder, width: 1),
//                       ),
//                       child: Text(
//                         'skip'.tr,
//                         style: TextStyle(
//                           color: AppColors.textMuted,
//                           fontSize: 13.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: PageView.builder(
//                 controller: controller.pageController,
//                 onPageChanged: (index) {
//                   controller.currentPage.value = index;
//                 },
//                 itemCount: pages.length,
//                 itemBuilder: (context, index) {
//                   return OnboardingPage(data: pages[index]);
//                 },
//               ),
//             ),
//             Obx(
//               () => Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(
//                   pages.length,
//                   (index) => AnimatedContainer(
//                     duration: const Duration(milliseconds: 250),
//                     margin: EdgeInsets.symmetric(horizontal: 4.w),
//                     width: controller.currentPage.value == index ? 24.w : 6.w,
//                     height: 6.h,
//                     decoration: BoxDecoration(
//                       color: controller.currentPage.value == index
//                           ? AppColors.primaryColor
//                           : AppColors.cardBorder,
//                       borderRadius: BorderRadius.circular(3),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 24.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24.w),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 54.h,
//                 child: ElevatedButton(
//                   onPressed: controller.nextPage,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: Obx(() {
//                     final isLast = controller.currentPage.value == pages.length - 1;
//                     final label = isLast ? 'getStarted'.tr : 'continue'.tr;
//                     return Text(
//                       label,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 0.5,
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ),
//             SizedBox(height: 24.h),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OnboardingPage extends StatelessWidget {
//   final OnboardingData data;

//   const OnboardingPage({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return _buildRegularPage();
//   }

//   Widget _buildRegularPage() {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: 24.h),
//           Container(
//             width: 96.w,
//             height: 96.h,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: AppColors.surfaceLight,
//               border: Border.all(
//                   color: AppColors.primaryColor.withOpacity(0.4), width: 1.5),
//             ),
//             child: Center(child: data.icon),
//           ),
//           SizedBox(height: 32.h),
//           Text(
//             data.title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 22.sp,
//               fontWeight: FontWeight.w700,
//               height: 1.3,
//             ),
//           ),
//           SizedBox(height: 14.h),
//           Text(
//             data.description,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: AppColors.textSubtle,
//               fontSize: 14.sp,
//               height: 1.65,
//             ),
//           ),
//           SizedBox(height: 32.h),
//           ...data.features.map(
//             (feature) => Padding(
//               padding: EdgeInsets.only(bottom: 14.h),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(top: 10),
//                     child: Container(
//                       width: 6,
//                       height: 6,
//                       decoration: BoxDecoration(
//                         color: AppColors.primaryColor,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 12.w),
//                   Expanded(
//                     child: Text(
//                       feature,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14.sp,
//                         height: 1.5,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }







import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/onboarding/controller/onboarding_controller.dart';
import 'package:clause_verify/features/onboarding/model/onboarding_data.dart';
import 'package:clause_verify/core/common/widgets/language_modal.dart';
import 'package:clause_verify/core/localization/localization_controller.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    final List<OnboardingData> pages = [
      OnboardingData(
        title: 'onboarding1Title'.tr,
        description: 'onboarding1Description'.tr,
        features: [
          'onboarding1Feature1'.tr,
          'onboarding1Feature2'.tr,
          'onboarding1Feature3'.tr,
        ],
        icon: Icon(
          Icons.document_scanner_rounded,
          color: AppColors.primaryColor,
          size: 40,
        ),
        isPlansPage: false,
      ),
      OnboardingData(
        title: 'onboarding2Title'.tr,
        description: 'onboarding2Description'.tr,
        features: [
          'onboarding2Feature1'.tr,
          'onboarding2Feature2'.tr,
          'onboarding2Feature3'.tr,
        ],
        icon: Icon(
          Icons.warning_amber_rounded,
          color: AppColors.primaryColor,
          size: 40,
        ),
        isPlansPage: false,
      ),
      OnboardingData(
        title: 'onboarding3Title'.tr,
        description: 'onboarding3Description'.tr,
        features: [
          'onboarding3Feature1'.tr,
          'onboarding3Feature2'.tr,
          'onboarding3Feature3'.tr,
        ],
        icon: Icon(
          Icons.picture_as_pdf_rounded,
          color: AppColors.primaryColor,
          size: 40,
        ),
        isPlansPage: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.dialog(
                        const LanguageModal(isOnboarding: true),
                        barrierDismissible: false,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.cardBorder, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.language_rounded,
                            color: AppColors.primaryColor,
                            size: 16,
                          ),
                          SizedBox(width: 6.w),
                          GetBuilder<LocalizationController>(
                            builder: (lc) {
                              final code = lc.locale.languageCode.toUpperCase();
                              return Text(
                                code,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.primaryColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.offNamed(AppRoute.loginScreen),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.cardBorder, width: 1),
                      ),
                      child: Text(
                        'skip'.tr,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: (index) {
                  controller.currentPage.value = index;
                },
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: pages[index]);
                },
              ),
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: controller.currentPage.value == index ? 24.w : 6.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? AppColors.primaryColor
                          : AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: controller.nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Obx(() {
                    final isLast = controller.currentPage.value == pages.length - 1;
                    final label = isLast ? 'getStarted'.tr : 'continue'.tr;
                    return Text(
                      label,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return _buildRegularPage();
  }

  Widget _buildRegularPage() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 24.h),
          Container(
            width: 96.w,
            height: 96.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceLight,
              border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.4), width: 1.5),
            ),
            child: Center(child: data.icon),
          ),
          SizedBox(height: 32.h),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14.sp,
              height: 1.65,
            ),
          ),
          SizedBox(height: 32.h),
          ...data.features.map(
            (feature) => Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}