import 'package:clause_verify/core/models/response_data.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerificationController extends GetxController {
  final TextEditingController emailTEController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final emailError = ''.obs;
  final hasStartedTypingEmail = false.obs;
  final isLoading = false.obs;
  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setupListener();
  }

  void _setupListener() {
    emailTEController.addListener(() {
      if (emailTEController.text.isNotEmpty) {
        hasStartedTypingEmail.value = true;
      }
      _validateForm();
    });
  }

  void _validateForm() {
    if (!hasStartedTypingEmail.value) {
      emailError.value = '';
    } else {
      final email = emailTEController.text.trim();
      if (email.isEmpty) {
        emailError.value = 'Email is required';
      } else if (!GetUtils.isEmail(email)) {
        emailError.value = 'Please enter a valid email';
      } else {
        emailError.value = '';
      }
    }
    isFormValid.value =
        emailTEController.text.trim().isNotEmpty &&
        GetUtils.isEmail(emailTEController.text.trim());
  }

  Future<void> verifyEmail() async {
    hasStartedTypingEmail.value = true;
    _validateForm();

    if (emailError.value.isNotEmpty || !isFormValid.value) return;

    isLoading.value = true;

    try {
      final NetworkCaller networkCaller = NetworkCaller();
      final ResponseData response = await networkCaller.postRequest(
        Endpoints.forgotPassword,
        body: {"email": emailTEController.text.trim()},
        requiresAuth: false,
      );

      if (response.isSuccess) {
        final String email = emailTEController.text.trim();
        // Response থেকে forgot_password_token নিয়ে নিচ্ছি
        final String forgotPasswordToken =
            response.responseData?['forgot_password_token']?.toString() ?? '';

        Get.toNamed(
          AppRoute.otpVerificationScreen,
          arguments: {
            'email': email,
            'forgot_password_token': forgotPasswordToken,
          },
        );
      } else {
        final errorMsg = response.responseData?['error']?.toString() ??
            response.responseData?['message']?.toString() ??
            response.errorMessage;

        Get.snackbar(
          'error'.tr,
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'network_error'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailTEController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}