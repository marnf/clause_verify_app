import 'dart:io';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/core/utils/constants/icon_path.dart';
import 'package:flutter_extension/features/home/controllers/watch_capture_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class WatchCaptureScreen extends StatelessWidget {
  const WatchCaptureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WatchCaptureController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 0,
        leadingWidth: 56.w,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
          ),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Row(
            children: [
              SizedBox(width: 8.w),
              Text(
                controller.getCurrentStepTitle(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              // Progress Indicator
              Obx(
                () => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: controller.currentStep.value >= 1
                                  ? const Color(0xFFD4AF37)
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Container(
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: controller.currentStep.value >= 2
                                  ? const Color(0xFFD4AF37)
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Container(
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: controller.currentStep.value >= 3
                                  ? const Color(0xFFD4AF37)
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '${controller.currentStep.value}/3',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Camera Frame
  Expanded(
  child: Obx(() {
    final capturedImage = controller.getCapturedImage();
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:  Color(0xFF3E341F),
              width: 3,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
            ),
            child: capturedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(capturedImage),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        IconPath.UploadPic,
                        width: 120.w,
                        height: 120.h,
                      ),
                      Text(
                        'positionYourWatchHere'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                        ),
                        child: Text(
                          controller.getCurrentStepDescription(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        // Corner accents - positioned exactly on border corners
        Positioned(
          top: -1.5,
          left: -1.5,
          child: _buildCornerAccent(isTopLeft: true),
        ),
        Positioned(
          top: -1.5,
          right: -1.5,
          child: _buildCornerAccent(isTopRight: true),
        ),
        Positioned(
          bottom: -1.5,
          left: -1.5,
          child: _buildCornerAccent(isBottomLeft: true),
        ),
        Positioned(
          bottom: -1.5,
          right: -1.5,
          child: _buildCornerAccent(isBottomRight: true),
        ),
      ],
    );
  }),
),
              SizedBox(height: 16.h),

              // Warning Message
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(0xFFD4AF37),
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'ensureSharpFocusAndControlledLightingForOptimalAnalysisAccuracy'.tr,
                        style: TextStyle(
                          color: const Color(0xFFD4AF37),
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[800]!, width: 1),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: controller.uploadFromGallery,
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                IconPath.miniUpload,
                                width: 24.sp,
                                height: 24.sp,
                                color: Colors.white,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                   'uploadPhoto'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // Text(
                              //      'fromYourGallery'.tr,
                              //   style: TextStyle(
                              //     color: Colors.grey[500],
                              //     fontSize: 9.sp,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: controller.capturePhoto,
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 24.sp,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'capturePhoto'.tr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Next Button (Full Width)
              Obx(
                () => Container(
                  width: double.infinity,
                  height: 52.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: controller.canProceedToNext()
                          ? const Color(0xFFD4AF37)
                          : Colors.grey[700]!,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: controller.canProceedToNext()
                          ? controller.goToNextStep
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                             'next'.tr,
                              style: TextStyle(
                                color: controller.canProceedToNext()
                                    ? const Color(0xFFD4AF37)
                                    : Colors.grey[700],
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.arrow_forward,
                              color: controller.canProceedToNext()
                                  ? const Color(0xFFD4AF37)
                                  : Colors.grey[700],
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Widget _buildCornerAccent({
  bool isTopLeft = false,
  bool isTopRight = false,
  bool isBottomLeft = false,
  bool isBottomRight = false,
}) {
  BorderRadius? borderRadius;
  
  if (isTopLeft) {
    borderRadius = BorderRadius.only(topLeft: Radius.circular(20));
  } else if (isTopRight) {
    borderRadius = BorderRadius.only(topRight: Radius.circular(20));
  } else if (isBottomLeft) {
    borderRadius = BorderRadius.only(bottomLeft: Radius.circular(20));
  } else if (isBottomRight) {
    borderRadius = BorderRadius.only(bottomRight: Radius.circular(20));
  }

  return Container(
    width: 36.w,
    height: 36.h,
    decoration: BoxDecoration(
      border: Border(
        top: (isTopLeft || isTopRight)
            ? BorderSide(color: AppColors.primaryColor, width: 4)
            : BorderSide.none,
        left: (isTopLeft || isBottomLeft)
            ? BorderSide(color: AppColors.primaryColor, width: 4)
            : BorderSide.none,
        right: (isTopRight || isBottomRight)
            ? BorderSide(color: AppColors.primaryColor, width: 4)
            : BorderSide.none,
        bottom: (isBottomLeft || isBottomRight)
            ? BorderSide(color: AppColors.primaryColor, width: 4)
            : BorderSide.none,
      ),
      borderRadius: borderRadius,
    ),
  );
}