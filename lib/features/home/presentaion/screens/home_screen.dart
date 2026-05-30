import 'package:flutter_extension/core/common/widgets/language_modal.dart';
import 'package:flutter_extension/core/localization/localization_controller.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/core/utils/constants/icon_path.dart';
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
                SizedBox(height: 4.h),

                Text(
                  'readyToVerifyAContract'.tr,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 28.h),

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
  Widget _buildHeader(HomeController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Greeting
        Expanded(
          child: Obx(() {
            final name = controller.userName.value;
            return Text(
              name.isNotEmpty ? '${'Hello'.tr}' : 'Hello'.tr,
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }),
        ),

        Row(
          children: [
            // ── Scan Points Badge ──
            Obx(() {
              final scans = controller.freeScansRemaining.value;
              final unlimited = controller.isUnlimited;
              final hasScans = controller.hasScansRemaining;

              return Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(
                    color: hasScans
                        ? AppColors.cardBorder
                        : AppColors.error.withOpacity(0.5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset(IconPath.point,
                        width: 16.w, height: 16.h),
                    SizedBox(width: 6.w),
                    if (unlimited)
                      Icon(Icons.all_inclusive,
                          color: AppColors.primaryColor, size: 16.sp)
                    else
                      Text(
                        '$scans',
                        style: TextStyle(
                          color: hasScans
                              ? AppColors.textSubtle
                              : AppColors.error,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              );
            }),

            SizedBox(width: 10.w),

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
    );
  }

  // ══════════════════════════════════════
  //  Upload Contract Card
  // ══════════════════════════════════════
  Widget _buildUploadCard(HomeController controller) {
    return Obx(() {
      final hasScans = controller.hasScansRemaining;

      return GestureDetector(
        onTap: () => controller.navigateToUpload(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: 20.w, vertical: 22.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasScans
                  ? AppColors.cardBorder
                  : AppColors.error.withOpacity(0.3),
              width: 1,
            ),
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
                        color: hasScans
                            ? AppColors.textWhite
                            : AppColors.textMuted,
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
                color: hasScans
                    ? AppColors.textSubtle
                    : AppColors.textMuted,
                size: 22,
              ),
            ],
          ),
        ),
      );
    });
  }

  // ══════════════════════════════════════
  //  Scan Contract Card
  // ══════════════════════════════════════
  Widget _buildScanCard(HomeController controller) {
    return Obx(() {
      final hasScans = controller.hasScansRemaining;

      return GestureDetector(
        onTap: () => controller.navigateToCamera(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: 20.w, vertical: 22.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasScans
                  ? AppColors.primaryColor.withOpacity(0.3)
                  : AppColors.error.withOpacity(0.3),
              width: 1,
            ),
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
                        color: hasScans
                            ? AppColors.textWhite
                            : AppColors.textMuted,
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
                color: hasScans
                    ? AppColors.textSubtle
                    : AppColors.textMuted,
                size: 22,
              ),
            ],
          ),
        ),
      );
    });
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