

import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'dart:async';
import 'package:clause_verify/core/models/response_data.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final TextEditingController otpTEController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  RxString otp = ''.obs;
  RxInt secondsRemaining = 30.obs;
  RxBool isClickable = false.obs;
  RxBool isLoading = false.obs;

  late String email;
  late String forgotPasswordToken;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      email = arguments['email']?.toString() ?? '';
      forgotPasswordToken =
          arguments['forgot_password_token']?.toString() ?? '';
    } else {
      email = '';
      forgotPasswordToken = '';
    }
    startTimer();
  }

  void updateOtpValue(String value) {
    otp.value = value;
  }

  Future<void> verifyOtp() async {
    if (otp.value.length != 6) {
      Get.snackbar(
        'error'.tr,
        'Please enter a valid 6-digit OTP',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    if (email.isEmpty || forgotPasswordToken.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'Required information missing. Please start again.',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final NetworkCaller networkCaller = NetworkCaller();
      final ResponseData response = await networkCaller.postRequest(
        Endpoints.forgotPassOtpVerify,
        body: {
          "otp": otp.value,
          "email": email,
          "forgot_password_token": forgotPasswordToken,
        },
        requiresAuth: false,
      );

      if (response.isSuccess) {
        // Token same থাকে, আবার পাঠাচ্ছি
        final String tokenFromResponse =
            response.responseData?['forgot_password_token']?.toString() ??
            forgotPasswordToken;

        _cleanup();

        Get.offNamed(
          AppRoute.resetPasswordScreen,
          arguments: {
            'email': email,
            'forgot_password_token': tokenFromResponse,
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

  Future<void> resendOtp() async {
    if (!isClickable.value || email.isEmpty) return;

    isLoading.value = true;

    try {
      final NetworkCaller networkCaller = NetworkCaller();
      final ResponseData response = await networkCaller.postRequest(
        Endpoints.forgotPassword,
        body: {"email": email},
        requiresAuth: false,
      );

      if (response.isSuccess) {
        // নতুন token update করো
        final newToken =
            response.responseData?['forgot_password_token']?.toString();
        if (newToken != null && newToken.isNotEmpty) {
          forgotPasswordToken = newToken;
        }

        otpTEController.clear();
        otp.value = '';
        startTimer();

        Get.snackbar(
          'success'.tr,
          response.responseData?['message']?.toString() ?? 'OTP sent successfully',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
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

  void startTimer() {
    _timer?.cancel();
    secondsRemaining.value = 30;
    isClickable.value = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 1) {
        secondsRemaining.value--;
      } else {
        secondsRemaining.value = 0;
        isClickable.value = true;
        timer.cancel();
        _timer = null;
      }
    });
  }

  void _cleanup() {
    otpTEController.clear();
    if (focusNode.hasFocus) focusNode.unfocus();
    _timer?.cancel();
    _timer = null;
  }

  @override
  void onClose() {
    _cleanup();
    otpTEController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}