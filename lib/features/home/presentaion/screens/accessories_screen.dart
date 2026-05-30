import 'package:flutter_extension/core/common/widgets/app_bar.dart';
import 'package:flutter_extension/core/common/widgets/custom_button.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/core/utils/constants/icon_path.dart';
import 'package:flutter_extension/features/home/controllers/accessories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccessoriesScreen extends StatelessWidget {
  AccessoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccessoriesController());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Scaffold(
        backgroundColor: Color(0xFF000000),
        appBar: CustomAppBar(title: 'accessoriesIncluded'.tr),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'selectAllAccessoriesYouHaveTheseImproveValueEstimationAndAuthenticityVerification'
                      .tr,
                  style: TextStyle(
                    color: Color(0xFFB0B0B0),
                    fontSize: 16.sp,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),

                // Accessories List
                _buildAccessoryItem(
                  controller: controller,
                  accessoryId: 'original_box',
                  icon: IconPath.box,
                  title: 'originalBox'.tr,
                ),
                SizedBox(height: 12.h),
                _buildAccessoryItem(
                  controller: controller,
                  accessoryId: 'original_certificate',
                  icon: IconPath.document,
                  title: 'originalBrandCertificate'.tr,
                ),
                SizedBox(height: 12.h),
                _buildAccessoryItem(
                  controller: controller,
                  accessoryId: 'invoice',
                  icon: IconPath.money,
                  title: 'invoice'.tr,
                ),
                SizedBox(height: 24.h),

                _buildExpertTipSection(),
                SizedBox(height: 24.h),

                // Selected Count Bar
                Obx(() {
                  if (controller.hasSelection) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Color(0xFF0D3B2B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${controller.selectedCount} ${'accessoriesSelected'.tr}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF4ADE80),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),

                // Start AI Analysis Button - No loading state
                CustomButton(
                  text: 'startAiAnalysis'.tr,
                  onTap: controller.startAiAnalysis,
                ),
                
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccessoryItem({
    required AccessoriesController controller,
    required String accessoryId,
    required String icon,
    required String title,
  }) {
    return Obx(() {
      final isSelected = controller.isSelected(accessoryId);
      return GestureDetector(
        onTap: () => controller.toggleSelection(accessoryId),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFF2A2A2A), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  icon,
                  width: 24.w,
                  height: 24.h,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Color(0xFFD4A574) : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFD4A574)
                        : const Color(0xFF4A4A4A),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 16, color: Colors.black)
                    : null,
              ),
            ],
          ),
        ),
      );
    });
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
            child: Image.asset(
              IconPath.info,
              width: 24.w,
              height: 24.h,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'whyThisMatters'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildBulletPoint(
                  'originalAccessoriesIncreaseResaleValueBy'.tr,
                ),
                SizedBox(height: 8.h),
                _buildBulletPoint(
                  'certificatesHelpVerifyAuthenticity'.tr,
                ),
                SizedBox(height: 8.h),
                _buildBulletPoint(
                  'completeSetsAreMoreDesirableToCollectors'.tr,
                ),
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