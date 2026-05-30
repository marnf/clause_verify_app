import 'package:flutter_extension/core/models/response_data.dart';
import 'package:flutter_extension/core/services/endpoints.dart';
import 'package:flutter_extension/core/services/network_caller.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/routes/app_routes.dart';
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
    // শুধু যখন user টাইপ করবে তখন validation
    if (!hasStartedTypingEmail.value) {
      emailError.value = ''; // প্রথমে error দেখাবে না
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

    // Update form validity
    isFormValid.value = 
        emailTEController.text.trim().isNotEmpty &&
        GetUtils.isEmail(emailTEController.text.trim());
  }

  Future<void> verifyEmail() async {
    // Force validation check on button press
    hasStartedTypingEmail.value = true;
    _validateForm();
    
    if (emailError.value.isNotEmpty || !isFormValid.value) {
      return;
    }

    isLoading.value = true;

    try {
      final Map<String, dynamic> requestData = {
        "email": emailTEController.text.trim(),
      };

      final NetworkCaller networkCaller = NetworkCaller();
      final ResponseData response = await networkCaller.postRequest(
        Endpoints.forgotPassword, 
        body: requestData,
        requiresAuth: false,
      );

      // Check if API call was successful
      if (response.isSuccess) {
        // SUCCESS - Get email from controller
        final String email = emailTEController.text.trim();
        
        // Navigate to OTP screen with email
        Get.toNamed(
          AppRoute.otpVerificationScreen,
          arguments: {'email': email},
        );

        // Show success message from backend if exists
        final successMsg = response.responseData?['message'];
        if (successMsg != null) {
          Get.snackbar(
            'success'.tr,
            successMsg.toString(),
            backgroundColor: AppColors.primaryColor,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
        }
      } else {
        // ERROR - Show error message
        String errorMessage = response.responseData?['message'];

        // If no message from backend, use NetworkCaller's error message
        if (errorMessage == null || errorMessage.isEmpty) {
          errorMessage = response.errorMessage;
        }

        // Show in snackbar
        Get.snackbar(
          'error'.tr,
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
        );
      }
    } catch (e) {
      // Network or other exceptions
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

  @override
  void onClose() {
    emailTEController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}