import 'package:flutter_extension/core/services/Auth_service.dart';
import 'package:flutter_extension/core/services/endpoints.dart';
import 'package:flutter_extension/core/services/network_caller.dart';
import 'package:flutter_extension/routes/app_routes.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxBool isPremiumUser = false.obs;
  final RxInt scanLimit = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Local data দিয়ে আগে দেখাও, তারপর API থেকে update করো
    _loadFromLocal();
    loadUserProfile();
  }

  void _loadFromLocal() {
    userName.value = AuthService.userName ?? '';
    isPremiumUser.value = AuthService.isPremium;
    scanLimit.value = AuthService.scanLimit;
  }

  // ── Load user profile from /api/auth/user-profile-info/ ──
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      final networkCaller = NetworkCaller();
      final response = await networkCaller.getRequest(
        Endpoints.userProfile,
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        // এই API directly user object return করে, 'data' wrapper নেই
        final data = response.responseData as Map<String, dynamic>;

        isPremiumUser.value = data['user_status'] == 'premium';
        scanLimit.value = data['scan_limit'] ?? 0;
        userName.value = data['full_name'] ?? '';

        // AuthService এ save করো পরের জন্য
        await AuthService.saveUserData(data);
      } else {
        _loadFromLocal();
      }
    } catch (e) {
      print('❌ Exception loading profile: $e');
      _loadFromLocal();
    } finally {
      isLoading.value = false;
    }
  }

  // ── Upload Contract — scan_limit check ──
  void navigateToUpload() {
    if (scanLimit.value <= 0) {
      Get.snackbar(
        'Scan Limit Reached',
        'You have no scans remaining. Please upgrade to continue.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    Get.toNamed(AppRoute.uploadScreen);
  }

  // ── Scan Contract — scan_limit check ──
  void navigateToCamera() {
    if (scanLimit.value <= 0) {
      Get.snackbar(
        'Scan Limit Reached',
        'You have no scans remaining. Please upgrade to continue.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    Get.toNamed(AppRoute.cameraScreen);
  }

  void navigateToPremium() {
    Get.toNamed(AppRoute.subscriptionScreen);
  }

  Future<void> refreshData() async {
    await loadUserProfile();
  }
}