
import 'package:flutter_extension/core/localization/localization_controller.dart';
import 'package:flutter_extension/core/services/Auth_service.dart';
import 'package:flutter_extension/core/services/endpoints.dart';
import 'package:flutter_extension/core/services/iap_service.dart';
import 'package:flutter_extension/core/services/network_caller.dart';
import 'package:flutter_extension/routes/app_routes.dart';
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
  final isAppleLoading = false.obs; // ✅ নতুন

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

      print('🔍 Login API Response:');
      print('   - isSuccess: ${response.isSuccess}');
      print('   - statusCode: ${response.statusCode}');
      print('   - has responseData: ${response.responseData != null}');

      if (response.isSuccess && response.responseData != null) {
        print('✅ Login successful, saving data...');
        print('Response data keys: ${response.responseData!.keys.toList()}');

        await AuthService.saveLoginData(response.responseData!);
        await _fetchAndSaveUserProfile();
        await AuthService.testDataPersistence();

        // ✅ RevenueCat এ user identify করো
        final iapService = IAPService();
        await iapService.initialize();
        await iapService.loginUser(email);
        print('✅ RevenueCat user identified: $email');

        final localizationController = Get.find<LocalizationController>();
        await localizationController.syncLanguageToServer();
        Get.offNamed(AppRoute.termsAndCondition);
      } else {
        print('❌ Login failed: ${response.errorMessage}');
        Get.snackbar(
          'Login Failed',
          response.errorMessage ?? 'Invalid email or password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Exception during login: $e');
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchAndSaveUserProfile() async {
    try {
      final networkCaller = NetworkCaller();
      final response = await networkCaller.getRequest(
        Endpoints.user,
        token: AuthService.token,
      );
      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData!['data'] as Map<String, dynamic>;
        await AuthService.saveUserData(data);
        print('✅ User profile saved after login');
      }
    } catch (e) {
      print('⚠️ Could not fetch user profile: $e');
    }
  }

  void loginWithGoogle() async {
    if (isGoogleLoading.value == true) return;

    print('🔵 Login with Google started...');
    isGoogleLoading.value = true;

    try {
      final success = await AuthService.signInWithGoogle();

      if (success == true) {
        print('✅ Google login successful!');

        final userEmail = AuthService.userEmail;
        if (userEmail != null && userEmail.isNotEmpty) {
          final iapService = IAPService();
          await iapService.initialize();
          await iapService.loginUser(userEmail);
          print('✅ RevenueCat user identified (Google): $userEmail');
        }

        Get.snackbar(
          'Success',
          'Google login successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        try {
          final localizationController = Get.find<LocalizationController>();
          await localizationController.syncLanguageToServer();
        } catch (e) {
          print('⚠️ Language sync failed (continuing anyway): $e');
        }

        await Future.delayed(Duration(milliseconds: 500));

        final shouldShowTerms = await AuthService.shouldShowTerms();
        if (shouldShowTerms == true) {
          print('📋 Navigating to Terms & Conditions...');
          Get.offNamed(AppRoute.termsAndCondition);
        } else {
          print('🏠 Navigating to Home (Navbar)...');
          Get.offNamed(AppRoute.navBar);
        }
      } else {
        print('❌ Google login failed');
        Get.snackbar(
          'Login Failed',
          'Google login was cancelled or failed. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Google login error: $e');
      Get.snackbar(
        'Error',
        'An error occurred during Google login: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

  void loginWithApple() async {
    if (isAppleLoading.value) return; // ✅

    print('🍎 Login with Apple started...');
    isAppleLoading.value = true; // ✅

    try {
      final success = await AuthService.signInWithApple();

      if (success == true) {
        print('✅ Apple login successful!');

        final userEmail = AuthService.userEmail;
        if (userEmail != null && userEmail.isNotEmpty) {
          final iapService = IAPService();
          await iapService.initialize();
          await iapService.loginUser(userEmail);
          print('✅ RevenueCat user identified (Apple): $userEmail');
        }

        Get.snackbar(
          'Success',
          'Apple login successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        try {
          final localizationController = Get.find<LocalizationController>();
          await localizationController.syncLanguageToServer();
        } catch (e) {
          print('⚠️ Language sync failed (continuing anyway): $e');
        }

        await Future.delayed(Duration(milliseconds: 500));

        final shouldShowTerms = await AuthService.shouldShowTerms();
        if (shouldShowTerms == true) {
          Get.offNamed(AppRoute.termsAndCondition);
        } else {
          Get.offNamed(AppRoute.navBar);
        }
      } else {
        print('❌ Apple login failed');
        Get.snackbar(
          'Login Failed',
          'Apple login was cancelled or failed. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Apple login error: $e');
      Get.snackbar(
        'Error',
        'An error occurred during Apple login: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isAppleLoading.value = false; // ✅
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

  Future<void> afterSuccessfulLogin() async {
    try {
      final localizationController = Get.find<LocalizationController>();
      final synced = await localizationController.syncLanguageToServer();
      if (synced == true) {
        print('✅ Language preference synced to server');
      } else {
        print('⚠️ Failed to sync language preference (continuing anyway)');
      }
    } catch (e) {
      print('❌ Error in post-login sync: $e');
    }
  }
}