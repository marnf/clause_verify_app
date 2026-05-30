import 'package:flutter_extension/core/common/widgets/app_bar.dart';
import 'package:flutter_extension/core/common/widgets/custom_button.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/core/utils/constants/icon_path.dart';
import 'package:flutter_extension/core/utils/constants/image_path.dart';
import 'package:flutter_extension/routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoInstructionsScreen extends StatelessWidget {
  PhotoInstructionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Scaffold(
        backgroundColor: Colors.black,
         appBar: CustomAppBar(title: 'photoInstructions'.tr),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // Main Analyze Watch Card
                _buildAnalyzeWatchCard(),

                SizedBox(height: 24.h),

                // Photo Requirements Section
                _buildPhotoRequirementsSection(),

                SizedBox(height: 24.h),

                // Expert Tip Section
                _buildExpertTipSection(),

                SizedBox(height: 20.h), // Space for button
                // Start Photo Capture Button
             
                CustomButton( text: 'startPhotoCapture'.tr, onTap: () {
                  Get.toNamed(AppRoute.watchCaptureScreen);
                }),
                SizedBox(height: 20.h), // Space for button
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyzeWatchCard() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              ImagePath.cameraWithCircle,
              width: 120.w,
              height: 120.h,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
             'uploadRequiredPhotos'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Align(
            alignment: Alignment.center,
            child: Text(
                'highQualityImagesEnsureAccurateAnalysis'.tr,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoRequirementsSection() {
    return Container(
      width: double.infinity,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Front View
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: _buildPhotoStep(
              stepNumber: '1',
            title: 'frontView'.tr,
               description: 'captureTheWatchDialStraightOnWithClearDetails'.tr,
            ),
          ),

          SizedBox(height: 20.h),

          // Back View
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: _buildPhotoStep(
              stepNumber: '2',
             title: 'backView'.tr,
              description: 'showTheCasebackWithEngravingsClearlyVisible'.tr,
            ),
          ),

          SizedBox(height: 20.h),

          // Bracelet
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              
              borderRadius: BorderRadius.circular(16),
            ),
            child: _buildPhotoStep(
              stepNumber: '3',
              title: 'bracelet'.tr,
              description: 'captureTheClaspAndAPartOfTheBracelet'.tr,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoStep({
    required String stepNumber,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Step Number Circle
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: Color(0xFF302D23),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 13.sp,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpertTipSection() {
    return Container(
      width: double.infinity,
      
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[800]!),
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Image.asset(IconPath.info, width: 24.w, height: 24.h, color: AppColors.primaryColor,),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                'tipsForBestResults'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
              _buildBulletPoint('ensureGoodLightingAndFocus'.tr), 
                SizedBox(height: 8.h),
                _buildBulletPoint('keepTheWatchCenteredInFrame'.tr), 
                SizedBox(height: 8.h),
                _buildBulletPoint('avoidReflectionsAndShadows'.tr), 
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          margin: EdgeInsets.only(top: 6.h, right: 10.w),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

}
