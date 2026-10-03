// import 'package:flutter/material.dart';
// import 'package:clause_verify/core/common/widgets/app_bar.dart';
// import 'package:clause_verify/core/utils/constants/app_colors.dart';
// import 'package:clause_verify/core/utils/constants/app_sizer.dart';
// import 'package:clause_verify/features/profile/controller/terms_of_use_controller.dart';
// import 'package:get/get.dart';

// class TermsOfUseScreen extends StatelessWidget {
//   const TermsOfUseScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(TermsOfUseController());

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: CustomAppBar(title: 'termsOfUse'.tr),
//       body: ListView(
//         padding: EdgeInsets.symmetric(horizontal: 16.h),
//         children: [
//           Text(
//             'termsLastUpdated'.tr,
//             style: const TextStyle(
//               color: AppColors.primaryColor,
//               fontSize: 13,
//               fontStyle: FontStyle.italic,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'termsIntroBody'.tr,
//             style: const TextStyle(
//               color: AppColors.textMuted,
//               fontSize: 13,
//               height: 1.6,
//             ),
//           ),
//           const SizedBox(height: 20),
//           ...controller.sections.map(
//             (section) => _TermsSectionWidget(section: section),
//           ),
//           // 👇 ক্লায়েন্টের দেওয়া কন্টাক্ট টেক্সট যুক্ত করা হলো
//           const SizedBox(height: 20),
//           Text(
//             'termsContactTitle'.tr,
//             style: const TextStyle(
//               color: AppColors.primaryColor,
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             'termsContactEmail'.tr,
//             style: const TextStyle(
//               color: AppColors.textMuted,
//               fontSize: 13,
//             ),
//           ),
//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
// }

// class _TermsSectionWidget extends StatelessWidget {
//   final TermsSection section;

//   const _TermsSectionWidget({required this.section});

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
//         Text(
//           section.content,
//           style: const TextStyle(
//             color: AppColors.textMuted,
//             fontSize: 13,
//             height: 1.7,
//           ),
//         ),
//         const Divider(color: AppColors.divider, height: 28),
//         const SizedBox(height: 2),
//       ],
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:clause_verify/core/common/widgets/app_bar.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/profile/controller/terms_of_use_controller.dart';
import 'package:get/get.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsOfUseController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'termsOfUse'.tr),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        children: [
          Text(
            'termsLastUpdated'.tr,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 13.sp,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'termsIntroBody'.tr,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13.sp,
              height: 1.6,
            ),
          ),
          SizedBox(height: 20.h),
          ...controller.sections.map(
            (section) => _TermsSectionWidget(section: section),
          ),
          // 👇 ক্লায়েন্টের দেওয়া কন্টাক্ট টেক্সট যুক্ত করা হলো
          SizedBox(height: 20.h),
          Text(
            'termsContactTitle'.tr,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'termsContactEmail'.tr,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 40.h),
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
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          section.content,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 13.sp,
            height: 1.7,
          ),
        ),
        Divider(color: AppColors.divider, height: 28.h),
        SizedBox(height: 2.h),
      ],
    );
  }
}