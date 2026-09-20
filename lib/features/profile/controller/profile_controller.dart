


import 'package:clause_verify/core/services/auth_service.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {

  var userName = ''.obs;
  var userEmail = ''.obs;
  var isPremium = false.obs;
  var isLoading = false.obs;

  var isDeleting = false.obs;
  TextEditingController deleteConfirmController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    _loadUserData();
  }

  @override
  void onReady() {
    super.onReady();
    refreshFromAPI();
  }

  void _loadUserData() {
    final name = AuthService.userName ?? '';
    final email = AuthService.userEmail ?? '';

    userName.value = name;
    userEmail.value = email;
    isPremium.value = AuthService.isPremium;

    print('👤 User loaded (local): name=$name, email=$email');
  }

  // ✅ API থেকে fresh data fetch করুন
  Future<void> refreshFromAPI() async {
    try {
      isLoading.value = true;

      final networkCaller = NetworkCaller();
      final response = await networkCaller.getRequest(
        Endpoints.user,
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        // ✅ FIX: response এ কোনো 'data' wrapper নেই, পুরো object টাই root এ
        final data = response.responseData as Map<String, dynamic>;

        await AuthService.saveUserData(data);

        userName.value = AuthService.userName ?? '';
        userEmail.value = AuthService.userEmail ?? '';
        isPremium.value = AuthService.isPremium;

        print('✅ Profile refreshed: name=${userName.value}, email=${userEmail.value}, premium=${isPremium.value}');
      } else {
        print('❌ API Failed: ${response.errorMessage}');
        _loadUserData();
      }
    } catch (e) {
      print('❌ refreshFromAPI error: $e');
      _loadUserData();
    } finally {
      isLoading.value = false;
    }
  }

  void refreshUserData() {
    _loadUserData();
    update();
  }

  Future<void> deleteAccount() async {
    if (deleteConfirmController.text.trim().toLowerCase() != 'i want to delete my account') {
      Get.snackbar(
        'Error',
        'Please type exactly "i want to delete my account" to confirm.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isDeleting.value = true;

    try {
      final networkCaller = NetworkCaller();
      final response = await networkCaller.deleteRequest(
        Endpoints.deleteAccount,
        AuthService.token,
      );

      if (response.isSuccess) {
        Get.back();
        Get.snackbar(
          'Success',
          'Your account has been deleted successfully.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await AuthService.logoutUser();
        Get.offAllNamed(AppRoute.loginScreen);
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to delete account. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  void logout() {
    AuthService.logoutUser();
    Get.offAllNamed(AppRoute.loginScreen);
  }

  @override
  void onClose() {
    deleteConfirmController.dispose();
    super.onClose();
  }
}