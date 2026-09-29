
import 'package:clause_verify/core/common/widgets/language_modal.dart';
import 'package:clause_verify/core/localization/localization_controller.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  HomeController get controller => Get.isRegistered<HomeController>()
      ? Get.find<HomeController>()
      : Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (locController) {
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
                    _buildHeader(),
                    SizedBox(height: 28.h),
                    _buildActionSection(),
                    SizedBox(height: 28.h),
                    _buildHowItWorksSection(),
                    SizedBox(height: 16.h),
                    _buildUpgradeCard(),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ══════════════ Header ══════════════
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('hello'.tr,
                  style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700)),
              Obx(() {
                final name = controller.userName;
                if (name.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Text(name,
                        style: TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                );
              }),
              SizedBox(height: 4.h),
              Text('readyToVerifyAContract'.tr,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp)),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Scan balance button ──
            Obx(() {
              final total = controller.totalScans;
              final empty = total <= 0;
              final color = empty ? Colors.redAccent : AppColors.primaryColor;
              return GestureDetector(
                onTap: controller.showScanDetails,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    border: Border.all(color: color, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.document_scanner_rounded,
                          color: color, size: 14.sp),
                      SizedBox(width: 4.w),
                      Text('$total ${total == 1 ? 'scan' : 'scans'}',
                          style: TextStyle(
                              color: color,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(width: 8.w),
            // ── Language selector ──
            GetBuilder<LocalizationController>(
              builder: (locController) {
                final code = locController.locale.languageCode.toUpperCase();
                return GestureDetector(
                  onTap: () => Get.dialog(
                      const LanguageModal(isOnboarding: false),
                      barrierDismissible: true),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                        color: AppColors.surface,
                        border:
                            Border.all(color: AppColors.cardBorder, width: 1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Icon(Icons.language,
                            color: AppColors.primaryColor, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(code,
                            style: TextStyle(
                                color: AppColors.textSubtle,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600)),
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

  // ══════════════ Upload + Scan cards (ekta common lock box) ══════════════
  Widget _buildActionSection() {
    return Obx(() {
      final locked = controller.isLocked;

      final cards = Column(
        children: [
          _buildActionCard(
            icon: Icons.upload_file_rounded,
            title: 'uploadContract'.tr,
            subtitle: 'browseFromDevice'.tr,
            highlightBorder: false,
            onTap: controller.navigateToUpload,
          ),
          SizedBox(height: 14.h),
          _buildActionCard(
            icon: Icons.camera_alt_rounded,
            title: 'scanContract'.tr,
            subtitle: 'takePhotosDescription'.tr,
            highlightBorder: true,
            onTap: controller.navigateToCamera,
          ),
        ],
      );

      if (!locked) return cards;

      // Locked: duto card er upore ekta common disabled overlay + majhe lock icon
      return GestureDetector(
        onTap: controller.showNoScanModal,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // niche-r card gulo tap pabe na, dim hoye thakbe
            Opacity(
              opacity: 0.35,
              child: IgnorePointer(child: cards),
            ),
            // overlay: duto card er upor ekta box
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder, width: 1),
                ),
              ),
            ),
            // majhe lock icon
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Icon(Icons.lock_rounded,
                  color: Colors.redAccent, size: 30.sp),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool highlightBorder,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: highlightBorder
                ? AppColors.primaryColor.withValues(alpha: 0.3)
                : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child:
                  Icon(icon, color: AppColors.primaryColor, size: 26.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 4.h),
                  Text(subtitle,
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 13.sp)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textSubtle, size: 22),
          ],
        ),
      ),
    );
  }

  // ══════════════ How It Works ══════════════
  Widget _buildHowItWorksSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('howItWorks'.tr,
              style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600)),
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
            decoration: const BoxDecoration(
                color: AppColors.primaryColor, shape: BoxShape.circle),
            child: Center(
                child: Text(number,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700)))),
        SizedBox(width: 12.w),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Text(text,
                    style: TextStyle(
                        color: AppColors.textSubtle,
                        fontSize: 13.sp,
                        height: 1.4)))),
      ],
    );
  }

  // ══════════════ Upgrade card ══════════════
  Widget _buildUpgradeCard() {
    return GestureDetector(
      onTap: controller.navigateToPremium,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  shape: BoxShape.circle),
              child: Icon(Icons.workspace_premium_rounded,
                  color: Colors.black, size: 24.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upgrade to Premium',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800)),
                  SizedBox(height: 4.h),
                  Text('Unlock unlimited scans and advanced features.',
                      style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.8),
                          fontSize: 12.sp)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 22.sp),
          ],
        ),
      ),
    );
  }
}