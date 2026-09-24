import 'package:clause_verify/core/localization/localization_controller.dart';
import 'package:clause_verify/core/services/auth_service.dart';
import 'package:clause_verify/core/services/endpoints.dart';

import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final emailError = ''.obs;
  final isFormValid = false.obs;
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isAppleLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initAuthService();
    emailController.addListener(_checkFormValidity);
    passwordController.addListener(_checkFormValidity);
  }

  Future<void> _initAuthService() async {
    try {
      await AuthService.init();
    } catch (e) {
      print('Error initializing AuthService: $e');
    }
  }

  void _checkFormValidity() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    isFormValid.value = email.isNotEmpty && password.isNotEmpty;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      emailError.value = 'Please check the format and try again';
      return false;
    }
    emailError.value = '';
    return true;
  }

  Future<void> login() async {
    if (!isFormValid.value || isLoading.value) return;

    final email = emailController.text.trim();
    if (!validateEmail(email)) return;

    final password = passwordController.text.trim();
    isLoading.value = true;

    try {
      final body = {'email': email, 'password': password};
      final networkCaller = NetworkCaller();
      final response = await networkCaller.postRequest(
        Endpoints.login,
        body: body,
        requiresAuth: false,
      );

      if (response.isSuccess && response.responseData != null) {
        // Save all login data via AuthService
        // (RevenueCat login এখন AuthService.saveLoginData-এর ভেতরেই হয়)
        await AuthService.saveLoginData(response.responseData!);

        // Language sync
        try {
          final localizationController = Get.find<LocalizationController>();
          await localizationController.syncLanguageToServer();
        } catch (e) {
          print('⚠️ Language sync failed (continuing): $e');
        }

        Get.offNamed(AppRoute.navBar);
      } else {
        final errorMsg = response.responseData?['error']?.toString() ??
            response.errorMessage;

        Get.snackbar(
          'error'.tr,
          errorMsg,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

 void loginWithGoogle() async {
    if (isGoogleLoading.value) return;
    isGoogleLoading.value = true;

    try {
      final success = await AuthService.signInWithGoogle();

      if (success == true) {
        // (RevenueCat login এখন AuthService.saveGoogleLoginData-এর ভেতরেই হয়)

        try {
          final localizationController = Get.find<LocalizationController>();
          await localizationController.syncLanguageToServer();
        } catch (e) {
          print('⚠️ Language sync failed (continuing): $e');
        }

        await Future.delayed(const Duration(milliseconds: 500));

        final shouldShowTerms = await AuthService.shouldShowTerms();
        if (shouldShowTerms == true) {
          Get.offNamed(AppRoute.termsAndCondition);
        } else {
          Get.offNamed(AppRoute.navBar);
        }
      } else {
        Get.snackbar(
          'error'.tr,
          'Google login failed: ${AuthService.lastGoogleError ?? "unknown reason"}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 6),
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'An error occurred during Google login: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 6),
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

  void loginWithApple() async {
    if (isAppleLoading.value) return;
    isAppleLoading.value = true;

    try {
      final success = await AuthService.signInWithApple();

      if (success == true) {
        // (RevenueCat login এখন AuthService.saveGoogleLoginData-এর ভেতরেই হয়)

        try {
          final localizationController = Get.find<LocalizationController>();
          await localizationController.syncLanguageToServer();
        } catch (e) {
          print('⚠️ Language sync failed (continuing): $e');
        }

        await Future.delayed(const Duration(milliseconds: 500));

        final shouldShowTerms = await AuthService.shouldShowTerms();
        if (shouldShowTerms == true) {
          Get.offNamed(AppRoute.termsAndCondition);
        } else {
          Get.offNamed(AppRoute.navBar);
        }
      } else {
        Get.snackbar(
          'error'.tr,
          'Apple login was cancelled or failed. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'An error occurred during Apple login: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isAppleLoading.value = false;
    }
  }

  void forgotPassword() {
    Get.toNamed(AppRoute.emailVerificationScreen);
  }

  void navigateToRegister() {
    Get.toNamed(AppRoute.registrationScreen);
  }

  @override
  void onClose() {
    emailController.removeListener(_checkFormValidity);
    passwordController.removeListener(_checkFormValidity);
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}