import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanDetailsBottomSheet extends StatelessWidget {
  const ScanDetailsBottomSheet({super.key});

  static void show() {
    Get.bottomSheet(
      const ScanDetailsBottomSheet(),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.black.withValues(alpha: 0.6),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
            decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          final total = controller.totalScans;
          final hasScans = total > 0;

          return Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                                           decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.document_scanner_rounded,
                          color: AppColors.primaryColor, size: 22.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('scanBalanceTitle'.tr,
                              style: TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: 2.h),
                          Text('availableContractScans'.tr,
                              style: TextStyle(
                                  color: AppColors.textMuted, fontSize: 12.sp)),
                        ],
                      ),
                    ),
                
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: hasScans
                          ? [
                              AppColors.primaryColor.withValues(alpha: 0.22),
                              AppColors.primaryColor.withValues(alpha: 0.06),
                            ]
                          : [
                              AppColors.error.withValues(alpha: 0.18),
                              AppColors.error.withValues(alpha: 0.05),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          (hasScans ? AppColors.primaryColor : AppColors.error)
                              .withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                                        Text('totalAvailableScans'.tr,
                                style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 4.h),
                            Text(
                              hasScans
                                  ? (total == 1
                                      ? 'scanBalanceRemainingSingular'.trParams({'total': total.toString()})
                                      : 'scanBalanceRemainingPlural'.trParams({'total': total.toString()}))
                                  : 'noScansLeftUpgrade'.tr,
                              style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12.sp,
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text('$total',
                          style: TextStyle(
                              color: hasScans
                                  ? AppColors.primaryColor
                                  : AppColors.error,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w800,
                              height: 1)),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _StatBox(
                          label: 'singleScanTitle'.tr, // Pay-Per-Scan
                          value: controller.scanLimit,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _StatBox(
                          label: 'monthlyPlanTitle'.tr, // Monthly
                          value: controller.monthlyPackage,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _StatBox(
                          label: 'unlimitedPlanTitle'.tr, // Pro
                          value: controller.unlimitedPackage,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
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
                        Icon(Icons.bolt_rounded, size: 20.sp),
                        SizedBox(width: 6.w),
                        Text(hasScans ? 'getMoreScans'.tr : 'goPremium'.tr,
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final int value;

 
  const _StatBox({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final active = value > 0;
    final color = active ? AppColors.primaryColor : AppColors.textMuted;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      decoration: BoxDecoration(
                color: active
            ? AppColors.primaryColor.withValues(alpha: 0.08)
            : AppColors.navy,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: active
              ? AppColors.primaryColor.withValues(alpha: 0.45)
              : AppColors.cardBorder,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         
          Text('$value',
              style: TextStyle(
                  color: active ? AppColors.textWhite : AppColors.textMuted,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  height: 1)),
          SizedBox(height: 6.h),
          Text(label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// 👈 _PlanChip ক্লাসটিও সম্পূর্ণ বাদ দেওয়া হয়েছে