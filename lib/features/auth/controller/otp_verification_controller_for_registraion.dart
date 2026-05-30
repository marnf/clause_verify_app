import 'dart:async';
import 'package:flutter_extension/core/common/widgets/custom_modal.dart';
import 'package:flutter_extension/core/models/response_data.dart';
import 'package:flutter_extension/core/services/endpoints.dart';
import 'package:flutter_extension/core/services/network_caller.dart';
import 'package:flutter_extension/core/utils/constants/icon_path.dart';
import 'package:flutter_extension/routes/app_routes.dart';
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
    // Validate OTP
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
        "email": email,
        "otp": otp.value,
      };

      final NetworkCaller networkCaller = NetworkCaller();
      final ResponseData response = await networkCaller.postRequest(
        Endpoints.verifyOtp,
        body: otpData,
        requiresAuth: false,
      );

      if (response.isSuccess) {
        // Clear before navigation
        _cleanup();
        
        showCustomDialogGetX(
          imagePath: IconPath.successIcon,
          title: 'Registration Successfully Complete',
          subtitle: 'Thanks for staying, now we are going to redirect you to login screen, and then please login',
          buttonText: 'Continue',
          onButtonPressed: () {
            // Use off() instead of offAllNamed()
            Get.offNamed(AppRoute.loginScreen);
          },
        );
      } else {
        String errorMessage = response.responseData?['message']?.toString() 
                             ?? response.errorMessage 
                             ?? 'OTP verification failed';
        
        Get.snackbar(
          'error'.tr,
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'network_error'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!isClickable.value) return;
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
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
        // Reset timer
        otpTEController.clear();
        secondsRemaining.value = 30;
        isClickable.value = false;
        startTimer();

        Get.snackbar(
          'success'.tr,
          response.responseData?['message']?.toString() ?? 'OTP sent successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String errorMessage = response.responseData?['message']?.toString() 
                             ?? response.errorMessage 
                             ?? 'Failed to resend OTP';
        
        Get.snackbar(
          'error'.tr,
          errorMessage,
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
  // Stop existing timer
  _timer?.cancel();
  
  // Reset values
  secondsRemaining.value = 30;
  isClickable.value = false;
  
  // Start new timer
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (secondsRemaining.value > 1) {
      secondsRemaining.value--;
    } else {
      // When timer reaches 0
      secondsRemaining.value = 0;
      isClickable.value = true;
      timer.cancel();
      _timer = null;
    }
  });
}

  void _cleanup() {
    // Clear controllers
    otpTEController.clear();
    
    // Unfocus
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
    
    // Cancel timer
    _timer?.cancel();
    _timer = null;
  }

  @override
  void onClose() {
    _cleanup();
    super.onClose();
  }
}