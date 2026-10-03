

import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/common/widgets/custom_modal.dart';
import 'package:clause_verify/core/models/response_data.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/core/utils/constants/icon_path.dart';
import 'package:clause_verify/core/utils/validators/app_validator.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  final passwordError = ''.obs;
  final confirmPasswordError = ''.obs;
  final hasStartedTypingPassword = false.obs;
  final hasStartedTypingConfirmPassword = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  String email = '';
  // forgot_password_token আর লাগবে না reset এ, কিন্তু রেখে দিচ্ছি ভবিষ্যতের জন্য
  String forgotPasswordToken = '';

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      email = arguments['email']?.toString() ?? '';
      forgotPasswordToken =
          arguments['forgot_password_token']?.toString() ?? '';
    }
    _setupListeners();
  }

  void _setupListeners() {
    passwordController.addListener(() {
      if (passwordController.text.isNotEmpty) {
        hasStartedTypingPassword.value = true;
      }
      _validatePassword();
      if (hasStartedTypingConfirmPassword.value) _validateConfirmPassword();
    });

    confirmPasswordController.addListener(() {
      if (confirmPasswordController.text.isNotEmpty) {
        hasStartedTypingConfirmPassword.value = true;
      }
      _validateConfirmPassword();
    });
  }

  void _validatePassword() {
    if (!hasStartedTypingPassword.value) {
      passwordError.value = '';
      return;
    }
    final password = passwordController.text;
    if (password.isEmpty) {
      passwordError.value = 'Password is required';
    } else {
      final result = AppValidator.validatePassword(password);
      passwordError.value = result ?? '';
    }
  }

  void _validateConfirmPassword() {
    if (!hasStartedTypingConfirmPassword.value) {
      confirmPasswordError.value = '';
      return;
    }
    final confirm = confirmPasswordController.text;
    if (confirm.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
    } else if (confirm != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
    } else {
      confirmPasswordError.value = '';
    }
  }

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  Future<void> resetPassword() async {
    hasStartedTypingPassword.value = true;
    hasStartedTypingConfirmPassword.value = true;
    _validatePassword();
    _validateConfirmPassword();

    if (passwordError.value.isNotEmpty || confirmPasswordError.value.isNotEmpty) return;

    if (email.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'Required information is missing. Please start again.',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final NetworkCaller networkCaller = NetworkCaller();
      final ResponseData response = await networkCaller.postRequest(
        Endpoints.resetPassword,
        body: {
          "email": email,
          "new_password": passwordController.text,
          "confirm_new_password": confirmPasswordController.text,
        },
        requiresAuth: false,
      );

      if (response.isSuccess) {
        passwordController.clear();
        confirmPasswordController.clear();

        showCustomDialogGetX(
          imagePath: IconPath.successIcon,
          title: 'Password Changed!',
          subtitle: response.responseData?['success']?.toString() ??
              'Your password has been changed successfully. Please login with your new password.',
          buttonText: 'Continue',
          onButtonPressed: () {
            Get.back();
            Get.offAllNamed(AppRoute.loginScreen);
          },
        );
      } else {
        final errorMsg = response.responseData?['error']?.toString() ??
            response.responseData?['message']?.toString() ??
            response.errorMessage;

        Get.snackbar(
          'error'.tr,
          errorMsg,
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'network_error'.tr,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }
}