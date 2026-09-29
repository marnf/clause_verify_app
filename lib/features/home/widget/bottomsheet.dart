import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanDetailsBottomSheet extends StatelessWidget {
  const ScanDetailsBottomSheet({super.key});

  /// Bottomsheet er baire click korle / niche drag korle automatic bondho hobe
  static void show() {
    Get.bottomSheet(
      const ScanDetailsBottomSheet(),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          final total = controller.totalScans;
          final isPremium = controller.isPremiumUser;
          final hasScans = total > 0;

          return Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Drag handle ──
                Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 20.h),

                // ── Title + plan chip ──
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.12),
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
                          Text('Scan Balance',
                              style: TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: 2.h),
                          Text('Your available contract scans',
                              style: TextStyle(
                                  color: AppColors.textMuted, fontSize: 12.sp)),
                        ],
                      ),
                    ),
                    _PlanChip(isPremium: isPremium),
                  ],
                ),
                SizedBox(height: 20.h),

                // ── Total card ──
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
                              Colors.redAccent.withValues(alpha: 0.18),
                              Colors.redAccent.withValues(alpha: 0.05),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          (hasScans ? AppColors.primaryColor : Colors.redAccent)
                              .withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Available Scans',
                                style: TextStyle(
                                    color: AppColors.textSubtle,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 4.h),
                            Text(
                              hasScans
                                  ? 'You can analyze $total more contract${total == 1 ? '' : 's'}.'
                                  : 'No scans left. Upgrade to continue.',
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
                                  : Colors.redAccent,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w800,
                              height: 1)),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // ── 3 ta box pashapashi ──
                // ✅ FIX: IntrinsicHeight chara stretch unbounded height e crash kore
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _StatBox(
                          icon: Icons.card_giftcard_rounded,
                          label: 'Scan Limit',
                          value: controller.scanLimit,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _StatBox(
                          icon: Icons.calendar_month_rounded,
                          label: 'Monthly',
                          value: controller.monthlyPackage,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _StatBox(
                          icon: Icons.all_inclusive_rounded,
                          label: 'Unlimited',
                          value: controller.unlimitedPackage,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // ── Upgrade button ──
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // age bottomsheet bondho
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
                        Text(hasScans ? 'Get More Scans' : 'Upgrade Now',
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

// ═════════════ Single stat box ═════════════
class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;

  const _StatBox({
    required this.icon,
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
            : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: active
              ? AppColors.primaryColor.withValues(alpha: 0.45)
              : AppColors.cardBorder,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(9.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(height: 12.h),
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

// ═════════════ Plan status chip ═════════════
class _PlanChip extends StatelessWidget {
  final bool isPremium;
  const _PlanChip({required this.isPremium});

  @override
  Widget build(BuildContext context) {
    final color = isPremium ? AppColors.primaryColor : AppColors.textMuted;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
              isPremium
                  ? Icons.workspace_premium_rounded
                  : Icons.person_outline_rounded,
              color: color,
              size: 14.sp),
          SizedBox(width: 4.w),
          Text(isPremium ? 'Premium' : 'Free',
              style: TextStyle(
                  color: color, fontSize: 11.sp, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}