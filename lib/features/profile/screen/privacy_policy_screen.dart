// import 'package:flutter/material.dart';
// import 'package:clause_verify/core/common/widgets/app_bar.dart';
// import 'package:clause_verify/core/utils/constants/app_colors.dart';
// import 'package:clause_verify/core/utils/constants/app_sizer.dart';
// import 'package:clause_verify/features/profile/controller/privacy_policy_controller.dart';
// import 'package:get/get.dart';

// class PrivacyPolicyScreen extends StatelessWidget {
//   const PrivacyPolicyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(PrivacyPolicyController());

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: CustomAppBar(title: 'privacyPolicy'.tr),
//       body: ListView(
//         padding: EdgeInsets.symmetric(horizontal: 16.h),
//         children: [
//           Text(
//             'privacyLastUpdated'.tr,
//             style: const TextStyle(
//               color: AppColors.primaryColor,
//               fontSize: 13,
//               fontStyle: FontStyle.italic,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'privacyPolicyIntro'.tr,
//             style: const TextStyle(
//               color: AppColors.textMuted,
//               fontSize: 13,
//               height: 1.6,
//             ),
//           ),
//           const SizedBox(height: 20),
//           ...controller.sections.map((section) => _PrivacySectionWidget(section: section)),
//           // 👇 ক্লায়েন্টের দেওয়া কন্টাক্ট টেক্সট যুক্ত করা হলো
//           const SizedBox(height: 20),
//           Text(
//             'privacyContactTitle'.tr,
//             style: const TextStyle(
//               color: AppColors.primaryColor,
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             'privacyContactBody'.tr,
//             style: const TextStyle(
//               color: AppColors.textMuted,
//               fontSize: 13,
//               height: 1.5,
//             ),
//           ),
//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
// }

// class _PrivacySectionWidget extends StatelessWidget {
//   final PrivacySection section;

//   const _PrivacySectionWidget({required this.section});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           section.title,
//           style: const TextStyle(
//             color: AppColors.primaryColor,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 10),
//         ...section.content.asMap().entries.map((entry) {
//           final index = entry.key;
//           final text = entry.value;
          
//           final isHighlighted = section.title == 'privacyTitle4'.tr && index == 0;

//           return Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: isHighlighted
//                 ? Text(
//                     text,
//                     style: const TextStyle(
//                       color: AppColors.primaryColor,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   )
//                 : Text(
//                     text,
//                     style: const TextStyle(
//                       color: AppColors.textMuted,
//                       fontSize: 13,
//                       height: 1.6,
//                     ),
//                   ),
//           );
//         }),
//         const Divider(color: AppColors.divider, height: 24),
//         const SizedBox(height: 4),
//       ],
//     );
//   }
// }






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
      appBar: CustomAppBar(title: 'privacyPolicy'.tr),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        children: [
          Text(
            'privacyLastUpdated'.tr,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 13.sp,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'privacyPolicyIntro'.tr,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13.sp,
              height: 1.6,
            ),
          ),
          SizedBox(height: 20.h),
          ...controller.sections.map((section) => _PrivacySectionWidget(section: section)),
          // 👇 ক্লায়েন্টের দেওয়া কন্টাক্ট টেক্সট যুক্ত করা হলো
          SizedBox(height: 20.h),
          Text(
            'privacyContactTitle'.tr,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'privacyContactBody'.tr,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
          SizedBox(height: 40.h),
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
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        ...section.content.asMap().entries.map((entry) {
          final index = entry.key;
          final text = entry.value;
          
          final isHighlighted = section.title == 'privacyTitle4'.tr && index == 0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: isHighlighted
                ? Text(
                    text,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13.sp,
                      height: 1.6,
                    ),
                  ),
          );
        }),
        Divider(color: AppColors.divider, height: 24.h),
        SizedBox(height: 4.h),
      ],
    );
  }
}