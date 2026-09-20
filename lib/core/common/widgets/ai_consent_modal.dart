import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';

/// AI ডেটা শেয়ারিং কনসেন্ট মডাল (Apple Guideline 5.1.1(i) / 5.1.2(i) কমপ্লায়েন্স)
/// প্রতিবার document AI তে পাঠানোর আগে ইউজারের explicit permission নেয়।
class AIConsentModal {
  /// Consent dialog দেখায়। ইউজার "Agree" করলে true রিটার্ন করে।
  /// প্রতিবার দেখাবে — কোনো persistence নেই।
  static Future<bool> show() async {
    final result = await Get.dialog<bool>(
      const _ConsentDialog(),
      barrierDismissible: false,
    );
    return result == true;
  }
}

class _ConsentDialog extends StatelessWidget {
  const _ConsentDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 64.w,
                height: 64.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.smart_toy_outlined,
                  color: AppColors.primaryColor,
                  size: 30.sp,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'aiConsentTitle'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 14.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder, width: 1),
              ),
              child: Text(
                'aiConsentMessage'.tr,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13.sp,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () async {
                final uri =
                    Uri.parse('https://www.clauseverify.app/privacy-policy');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.open_in_new_rounded,
                    color: AppColors.primaryColor,
                    size: 14.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'privacyPolicy'.tr,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(result: false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppColors.cardBorder, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          'aiConsentDecline'.tr,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => Get.back(result: true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'aiConsentAgree'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}