import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoScanModal extends StatelessWidget {
  const NoScanModal({super.key});

  static void show() {
    Get.dialog(
      const NoScanModal(),
      barrierDismissible: true,
      barrierColor: AppColors.black.withValues(alpha: 0.6),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.fromLTRB(22.w, 26.h, 22.w, 20.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.lock_rounded,
                  color: AppColors.error, size: 34.sp),
            ),
            SizedBox(height: 18.h),

            // Client's exact Title
            Text('noScansLeftTitle'.tr, 
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w800)),
            SizedBox(height: 8.h),
            
            // Client's exact Message
            Text(
              'noScansRemainingMessage'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.textMuted, fontSize: 13.sp, height: 1.5),
            ),
            SizedBox(height: 22.h),

            // Main button -> Client's exact text: "See Plans"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); 
                  controller.navigateToPremium(); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.black,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('seePlansButton'.tr, // 👈 Updated
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
            
            // Secondary button -> Client's exact text: "Maybe later"
            TextButton(
              onPressed: () => Get.back(),
              child: Text('maybeLaterButton'.tr, // 👈 Updated
                  style:
                      TextStyle(color: AppColors.textMuted, fontSize: 13.sp)),
            ),
          ],
        ),
      ),
    );
  }
}