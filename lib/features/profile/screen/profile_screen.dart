import 'package:flutter_extension/core/common/widgets/language_modal.dart';
import 'package:flutter_extension/core/localization/localization_controller.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/core/utils/constants/icon_path.dart';
import 'package:flutter_extension/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());
  final LocalizationController localizationController =
      Get.find<LocalizationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),

                      // ── Profile Card ──
                      _buildProfileCard(),
                      SizedBox(height: 32.h),

                      // ── Preferences ──
                      _buildSectionTitle('preferences'.tr),
                      SizedBox(height: 12.h),
                      _buildLanguageRow(),
                      SizedBox(height: 32.h),

                      // ── Legal & Privacy ──
                      _buildSectionTitle('legalAndPrivacy'.tr),
                      SizedBox(height: 12.h),
                      _buildLegalCard(),
                      SizedBox(height: 40.h),

                      // ── Log Out ──
                      _buildLogoutButton(),
                      SizedBox(height: 16.h),

                      // ── Version Footer ──
                      Center(
                        child: Text(
                          'appVersion'.tr,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  //  Section Title
  // ══════════════════════════════════════
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textWhite,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ══════════════════════════════════════
  //  Profile Card
  // ══════════════════════════════════════
  Widget _buildProfileCard() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder, width: 1),
          ),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: AppColors.goldLight,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16.w),
                // Name & Email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.userName.value,
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        controller.userEmail.value,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Premium Badge
            if (controller.isPremium.value) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF251B0C),
                  border: Border.all(
                      color: AppColors.primaryColor, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Image.asset(IconPath.premium,
                        width: 20.w, height: 20.h),
                    SizedBox(width: 8),
                    Text(
                      'premiumMember'.tr,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  // ══════════════════════════════════════
  //  Language Row (tappable → opens modal)
  // ══════════════════════════════════════
  Widget _buildLanguageRow() {
    return GestureDetector(
      onTap: () {
        Get.dialog(const LanguageModal(isOnboarding: false));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            // Globe Icon
            Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: Color(0xFF13233D),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(IconPath.world, color: Colors.white),
            ),
            SizedBox(width: 12.w),

            // "Language" label
            Expanded(
              child: Text(
                'language'.tr,
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Current language name (right side)
            GetBuilder<LocalizationController>(
              builder: (langController) {
                return Text(
                  langController.currentLanguage.languageName,
                  style: TextStyle(
                    color: AppColors.textSubtle,
                    fontSize: 14.sp,
                  ),
                );
              },
            ),
            SizedBox(width: 8.w),

            // Chevron
            Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  //  Legal & Privacy Card
  // ══════════════════════════════════════
  Widget _buildLegalCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        children: [
          _buildLegalItem(
            'privacyPolicy'.tr,
            IconPath.security,
            // onTap: () => Get.toNamed(AppRoute.privacyPolicyScreen),
          ),
          _buildDivider(),
          _buildLegalItem(
            'termsConditions'.tr,
            IconPath.terms,
            // onTap: () => Get.toNamed(AppRoute.termsOfUseScreen),
          ),
          _buildDivider(),
          _buildLegalItem(
            'legalDisclaimer'.tr,
            IconPath.ai,
            // onTap: () => Get.toNamed(AppRoute.termsOfUseScreen),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(
        color: AppColors.divider,
        height: 1,
        thickness: 1,
      ),
    );
  }

  Widget _buildLegalItem(String title, String icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: Color(0xFF13233D),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(icon, color: Colors.white),
            ),
            SizedBox(width: 12.w),

            // Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
              ),
            ),

            // Chevron
            Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  //  Log Out Button
  // ══════════════════════════════════════
  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () => _showLogoutDialog(Get.context!),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Color(0xFF1C0A0A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppColors.error.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: AppColors.error, size: 20),
            SizedBox(width: 8.w),
            Text(
              'logout'.tr,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  //  Logout Dialog
  // ══════════════════════════════════════
  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout, color: AppColors.error, size: 28),
              ),
              SizedBox(height: 20),

              // Title
              Text(
                'logout'.tr,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                ),
              ),
              SizedBox(height: 8),

              // Subtitle
              Text(
                'readyToSignOut'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  // Cancel
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.cardBorder),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        'cancel'.tr,
                        style: TextStyle(color: AppColors.textWhite),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),

                  // Confirm Logout
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        controller.logout();
                      },
                      child: Text(
                        'logout'.tr,
                        style: TextStyle(color: AppColors.textWhite),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}