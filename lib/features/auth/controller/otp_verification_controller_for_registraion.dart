import 'dart:async';
import 'package:clause_verify/core/common/widgets/custom_modal.dart';
import 'package:clause_verify/core/models/response_data.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/core/utils/constants/icon_path.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerificationControllerForRegistraion extends GetxController {
  final TextEditingController otpTEController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  RxString otp = ''.obs;
  RxInt secondsRemaining = 30.obs;
  RxBool isClickable = false.obs;
  RxBool isLoading = false.obs;

  late String email;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;
    if (arguments != null && arguments['email'] != null) {
      email = arguments['email'] as String;
    } else {
      email = '';
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
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (email.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'Email not found. Please try registering again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final Map<String, dynamic> otpData = {
        "otp": otp.value,
        "email": email,
      };

      final NetworkCaller networkCaller = NetworkCaller();
      final ResponseData response = await networkCaller.postRequest(
        Endpoints.verifyOtp,
        body: otpData,
        requiresAuth: false,
      );

      if (response.isSuccess) {
        _cleanup();

        final successMsg = response.responseData?['success']?.toString() ??
            'Registration successful!';

        showCustomDialogGetX(
          imagePath: IconPath.successIcon,
          title: 'Registration Successful',
          subtitle: successMsg,
          buttonText: 'Continue',
          onButtonPressed: () {
            Get.offNamed(AppRoute.loginScreen);
          },
        );
      } else {
        final errorMsg = response.responseData?['error']?.toString() ??
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
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!isClickable.value) return;
    if (email.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'Email not found',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final Map<String, dynamic> resendData = {
        "email": email,
      };

      final NetworkCaller networkCaller = NetworkCaller();
      final ResponseData response = await networkCaller.postRequest(
        Endpoints.resendOtp,
        body: resendData,
        requiresAuth: false,
      );

      if (response.isSuccess) {
        otpTEController.clear();
        otp.value = '';
        secondsRemaining.value = 30;
        isClickable.value = false;
        startTimer();

        final successMsg = response.responseData?['success']?.toString() ??
            'OTP sent successfully';

        Get.snackbar(
          'success'.tr,
          successMsg,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final errorMsg = response.responseData?['error']?.toString() ??
            response.errorMessage;

        Get.snackbar(
          'error'.tr,
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
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
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
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