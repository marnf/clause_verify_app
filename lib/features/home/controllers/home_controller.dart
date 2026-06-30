import 'package:clause_verify/core/services/Auth_service.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  final RxBool isPremiumUser = false.obs;
  final RxInt scanLimit = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAndLoad();
  }

  // ✅ Ensures AuthService is initialized before any read/write
  Future<void> _initializeAndLoad() async {
    await AuthService.init(); 
    _loadFromLocal();
    loadUserProfile();
  }

  void _loadFromLocal() {
    userName.value = AuthService.userName ?? '';
    isPremiumUser.value = AuthService.isPremium;
    scanLimit.value = AuthService.scanLimit;
    print('🔄 Local Data: Name=${userName.value}, Limit=${scanLimit.value}');
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      final networkCaller = NetworkCaller();
      final response = await networkCaller.getRequest(
        Endpoints.userProfile,
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData as Map<String, dynamic>;

        print('🔥 RAW API scan_limit: ${data['scan_limit']} (Type: ${data['scan_limit'].runtimeType})');

        await AuthService.saveUserData(data);

        // Update UI from AuthService
        isPremiumUser.value = AuthService.isPremium;
        scanLimit.value = AuthService.scanLimit;
        userName.value = AuthService.userName ?? '';

        print('✅ UI Updated scanLimit.value: ${scanLimit.value}');
      } else {
        print('❌ API Failed: ${response.errorMessage}');
        _loadFromLocal();
      }
    } catch (e) {
      print('❌ Exception loading profile: $e');
      _loadFromLocal();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> navigateToUpload() async {
    if (scanLimit.value <= 0) {
      Get.snackbar('Scan Limit Reached', 'You have no scans remaining. Please upgrade to continue.', snackPosition: SnackPosition.TOP);
      return;
    }
    await Get.toNamed(AppRoute.uploadScreen);
    await loadUserProfile();
  }

  Future<void> navigateToCamera() async {
    if (scanLimit.value <= 0) {
      Get.snackbar('Scan Limit Reached', 'You have no scans remaining. Please upgrade to continue.', snackPosition: SnackPosition.TOP);
      return;
    }
    await Get.toNamed(AppRoute.cameraScreen);
    await loadUserProfile();
  }

  Future<void> navigateToPremium() async {
    await Get.toNamed(AppRoute.subscriptionScreen);
    await loadUserProfile();
  }

  Future<void> refreshData() async {
    await loadUserProfile();
  }
}