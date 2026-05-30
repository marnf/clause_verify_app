
import 'package:flutter_extension/core/common/widgets/app_bar.dart';
import 'package:flutter_extension/core/common/widgets/custom_button.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/core/utils/constants/icon_path.dart';
import 'package:flutter_extension/core/utils/constants/image_path.dart';
import 'package:flutter_extension/features/history/controller/history_preview_controller.dart';
import 'package:flutter_extension/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HistoryPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryPreviewController());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0.h),
      child: Scaffold(
        backgroundColor: Color(0xFF000000),
        appBar: CustomAppBar(title: 'WatchDetails'.tr),
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: Color(0xFFD4A574)),
              );
            }

            if (controller.analysisData.value == null) {
              return Center(
                child: Text(
                  'noDataAvailable'.tr,
                  style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16.sp),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Authenticity Evaluation Section
                  _buildAuthenticityEvaluation(controller),

                  SizedBox(height: 24.h),

                  // Category Analysis Section
                  _buildCategoryAnalysis(controller),

                  SizedBox(height: 24.h),

                  // Expert Commentary Section
                  _buildExpertCommentary(controller),

                  SizedBox(height: 24.h),

                  // Bottom Buttons
                  Obx(
                    () => Opacity(
                      opacity: controller.isPdfAvailable ? 1.0 : 0.5,
                      child: CustomButton(
                        text: 'downloadPdfAiPreExpertiseReport'.tr,
                        customTextStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: controller.isPdfAvailable
                              ? Colors.black
                              : Colors.grey.shade600,
                        ),
                        prefixIcon: Image.asset(
                          IconPath.document,
                          color: controller.isPdfAvailable
                              ? Colors.black
                              : Colors.grey.shade600,
                        ),
                        onTap: () {
                          if (controller.isPdfAvailable) {
                            Get.toNamed(
                              AppRoute.reportWebViewScreen,
                              arguments: {'id': controller.analysisId},
                            );
                          } else {}
                        },
                        enableShadow: controller.isPdfAvailable,
                        shadowColor: controller.isPdfAvailable
                            ? AppColors.primaryColor.withOpacity(0.5)
                            : Colors.transparent,
                        backgroundColor: controller.isPdfAvailable
                            ? AppColors.primaryColor
                            : Colors.grey.shade800,
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  CustomButton(
                    text: 'viewPriceEstimation'.tr,
                    backgroundColor: Colors.black,
                    borderColor: Color(0xFF364153),
                    isOutline: true,
                    customTextStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    prefixIcon: Image.asset(
                      IconPath.document,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Get.toNamed(
                        AppRoute.priceEstimationScreen,
                        arguments: {'id': controller.analysisId},
                      );
                    },
                  ),

                  SizedBox(height: 34.h),

                  // AI Confidence Level
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'aiConfidenceLevel'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${controller.aiConfidenceLevel}%',
                          style: TextStyle(
                            color: Color(0xFF51A2FF),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAuthenticityEvaluation(HistoryPreviewController controller) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            SizedBox(height: 24.h),
            Text(
              'authenticityEvaluation'.tr,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 24.h),

            // Circular Progress Indicator
            CircularPercentIndicator(
              radius: 90,
              lineWidth: 12.w,
              percent: controller.authenticityScore / 100,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${controller.authenticityScore}',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 48.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '/100',
                    style: TextStyle(color: Color(0xFF808080), fontSize: 14.sp),
                  ),
                ],
              ),
              progressColor: Color(0xFFD4A574),
              backgroundColor: Colors.black,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1500,
            ),

            SizedBox(height: 24.h),

            // Status Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Color(0xFFD292315),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFFCFAE674D).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    IconPath.checked,
                    color: Color(0xFFD4A574),
                    width: 28.w,
                    height: 28.h,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    controller.authenticityStatus,
                    style: TextStyle(
                      color: Color(0xFFD4A574),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryAnalysis(HistoryPreviewController controller) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Color(0xFF0D0D0D),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      IconPath.prime,
                      color: AppColors.primaryColor,
                      width: 18.w,
                      height: 18.h,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.categoryTitle,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          controller.categorySubtitle,
                          style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),
              Image.asset(
                ImagePath.divider,
                width: double.infinity,
                height: 1.h,
                color: Color(0xFF2A2A2A),
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20.h),

              // Category Items from Model
              ...controller.categoryItems.map((item) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${item.percentage}%',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: item.percentage / 100,
                          backgroundColor: Color(0xFF1A1A1A),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(
                              int.parse(item.color.replaceFirst('#', '0xFF')),
                            ),
                          ),
                          minHeight: 6.h,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpertCommentary(HistoryPreviewController controller) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Color(0xFF0D0D0D),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF332D1F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      IconPath.info,
                      color: AppColors.primaryColor,
                      width: 18.w,
                      height: 18.h,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.commentaryTitle,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          controller.commentarySubtitle,
                          style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Image.asset(
                ImagePath.divider,
                width: double.infinity,
                height: 1.h,
                color: Color(0xFF2A2A2A),
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20.h),

              // Commentary Items from Model
              ...controller.commentItems.map((comment) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Color(0xFF090909),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.h,
                          margin: EdgeInsets.only(top: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.title,
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                comment.description,
                                style: TextStyle(
                                  color: Color(0xFF999999),
                                  fontSize: 13.sp,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
