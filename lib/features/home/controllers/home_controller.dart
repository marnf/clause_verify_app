
import 'package:flutter_extension/core/services/Auth_service.dart';
import 'package:flutter_extension/core/services/endpoints.dart';
import 'package:flutter_extension/core/services/network_caller.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxBool isPremiumUser = false.obs;
  final RxBool canScan = false.obs;
  final RxInt freeScansRemaining = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  @override
  void onReady() {
    super.onReady();
    refreshData();
  }

  // ── Check if user can scan ──
  bool get hasScansRemaining => freeScansRemaining.value > 0;

  // ── Is unlimited plan ──
  bool get isUnlimited =>
      freeScansRemaining.value >= 10000;

  // ── Load user profile from API ──
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      final networkCaller = NetworkCaller();
      final response = await networkCaller.getRequest(
        Endpoints.user,
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData!['data'] as Map<String, dynamic>;

        isPremiumUser.value = data['is_premium'] == true;
        canScan.value = data['can_scan'] == true;
        freeScansRemaining.value = data['free_scans_remaining'] ?? 0;
        userName.value =
            '${data['first_name'] ?? ''} ${data['last_name'] ?? ''}'.trim();

        try {
          await AuthService.saveUserData(data);
        } catch (e) {
          print('⚠️ AuthService save failed: $e');
        }
      } else {
        _handleProfileLoadError();
      }
    } catch (e) {
      print('❌ Exception loading profile: $e');
      _handleProfileLoadError();
    } finally {
      isLoading.value = false;
    }
  }

  void _handleProfileLoadError() {
    // Load from local storage
    userName.value = AuthService.userName ?? '';
    isPremiumUser.value = AuthService.isPremium;
  }

  // ── Navigate to Upload Screen ──
  void navigateToUpload() {
    if (!hasScansRemaining) {
      _showScanLockedDialog();
      return;
    }
    Get.toNamed(AppRoute.uploadScreen);
  }

  // ── Navigate to Camera Screen ──
  void navigateToCamera() {
    if (!hasScansRemaining) {
      _showScanLockedDialog();
      return;
    }
    Get.toNamed(AppRoute.cameraScreen);
  }

  // ── Scan locked dialog ──
  void _showScanLockedDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lock_outline,
                    color: AppColors.error, size: 28),
              ),
              SizedBox(height: 20),
              Text(
                'scanLocked'.tr,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'upgradeToPremiumToUnlock'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
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
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        navigateToPremium();
                      },
                      child: Text(
                        'goPremium'.tr,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
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

  void navigateToPremium() {
    Get.toNamed(AppRoute.subscriptionScreen);
  }

  Future<void> refreshData() async {
    await loadUserProfile();
  }
}