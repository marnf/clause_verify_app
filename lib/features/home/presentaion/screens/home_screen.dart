import 'package:flutter_extension/core/common/widgets/language_modal.dart';
import 'package:flutter_extension/core/localization/localization_controller.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/features/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                // ── Header ──
                _buildHeader(controller),
                SizedBox(height: 28.h), // হেডার এবং কার্ডের মাঝে গ্যাপ

                // ── Upload Contract Card ──
                _buildUploadCard(controller),
                SizedBox(height: 14.h),

                // ── Scan Contract Card ──
                _buildScanCard(controller),
                SizedBox(height: 28.h),

                // ── How It Works ──
                _buildHowItWorksSection(),
                SizedBox(height: 16.h),

                // ── Expert Tip ──
                _buildExpertTipSection(),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  //  Header
  // ══════════════════════════════════════
    // ══════════════════════════════════════
  //  Header
  // ══════════════════════════════════════
  Widget _buildHeader(HomeController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // উপর থেকে অ্যালাইন হবে
      children: [
        // ── Left Side: Hello, Name & Subtitle ──
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hello Text
              Text(
                'Hello'.tr,
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              
              // Name Text (নিচে শো করবে)
              Obx(() {
                final name = controller.userName.value;
                if (name.isEmpty) return const SizedBox.shrink(); // নাম না থাকলে জায়গা নেবে না
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Text(
                      name,
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              }),
              
              SizedBox(height: 4.h),
              
              // Subtitle
              Text(
                'readyToVerifyAContract'.tr,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 12.w), // টেক্সট এবং বাটনের মাঝে গ্যাপ

        // ── Right Side: Scan Limit & Language ──
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Scan Limit Badge ──
                Obx(() => GestureDetector(
                      onTap: controller.isPremiumUser.value
                          ? null
                          : controller.navigateToPremium,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(
                            color: controller.scanLimit.value > 0
                                ? AppColors.primaryColor.withOpacity(0.5)
                                : AppColors.error.withOpacity(0.5),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.document_scanner_outlined,
                              color: controller.scanLimit.value > 0
                                  ? AppColors.primaryColor
                                  : AppColors.error,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${controller.scanLimit.value}',
                              style: TextStyle(
                                color: controller.scanLimit.value > 0
                                    ? AppColors.textSubtle
                                    : AppColors.error,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

                SizedBox(width: 8.w),

                // ── Language Selector ──
                GetBuilder<LocalizationController>(
                  builder: (locController) {
                    final code =
                        locController.locale.languageCode.toUpperCase();
                    return GestureDetector(
                      onTap: () {
                        Get.dialog(
                          const LanguageModal(isOnboarding: false),
                          barrierDismissible: true,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(
                              color: AppColors.cardBorder, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.language,
                                color: AppColors.primaryColor, size: 16.sp),
                            SizedBox(width: 4.w),
                            Text(
                              code,
                              style: TextStyle(
                                color: AppColors.textSubtle,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ══════════════════════════════════════
  //  Upload Contract Card
  // ══════════════════════════════════════
  Widget _buildUploadCard(HomeController controller) {
    return GestureDetector(
      onTap: () => controller.navigateToUpload(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.upload_file_rounded,
                color: AppColors.primaryColor,
                size: 26.sp,
              ),
            ),
            SizedBox(width: 16.w),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'uploadContract'.tr,
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'browseFromDevice'.tr,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right,
              color: AppColors.textSubtle,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  //  Scan Contract Card
  // ══════════════════════════════════════
  Widget _buildScanCard(HomeController controller) {
    return GestureDetector(
      onTap: () => controller.navigateToCamera(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                color: AppColors.primaryColor,
                size: 26.sp,
              ),
            ),
            SizedBox(width: 16.w),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'scanContract'.tr,
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'takePhotosDescription'.tr,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right,
              color: AppColors.textSubtle,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  //  How It Works
  // ══════════════════════════════════════
  Widget _buildHowItWorksSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'howItWorks'.tr,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          _buildStepRow('1', 'uploadOrPhotographContract'.tr),
          SizedBox(height: 14.h),
          _buildStepRow('2', 'aiAnalyzesClauses'.tr),
          SizedBox(height: 14.h),
          _buildStepRow('3', 'receiveDetailedReport'.tr),
        ],
      ),
    );
  }

  Widget _buildStepRow(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textSubtle,
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════
  //  Expert Tip
  // ══════════════════════════════════════
  Widget _buildExpertTipSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.auto_awesome,
              color: AppColors.primaryColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'expertTip'.tr,
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'expertTipDescription'.tr,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13.sp,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}