import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoScanModal extends StatelessWidget {
  const NoScanModal({super.key});

  /// Baire tap korle automatic bondho hobe
  static void show() {
    Get.dialog(
      const NoScanModal(),
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.6),
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
            // ── Lock icon ──
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.lock_rounded,
                  color: Colors.redAccent, size: 34.sp),
            ),
            SizedBox(height: 18.h),

            Text('No Scans Available',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w800)),
            SizedBox(height: 8.h),
            Text(
              'You haven\'t purchased any package or single scan yet. '
              'Please upgrade to start analyzing your contracts.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.textMuted, fontSize: 13.sp, height: 1.5),
            ),
            SizedBox(height: 22.h),

            // ── Upgrade button ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // age modal bondho
                  controller.navigateToPremium(); // tarpor subscription page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bolt_rounded, size: 20.sp),
                    SizedBox(width: 6.w),
                    Text('Upgrade Now',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Maybe later',
                  style:
                      TextStyle(color: AppColors.textMuted, fontSize: 13.sp)),
            ),
          ],
        ),
      ),
    );
  }
}