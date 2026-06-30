// import 'dart:async';
// import 'package:clause_verify/core/models/response_data.dart';
// import 'package:clause_verify/core/services/endpoints.dart';
// import 'package:clause_verify/core/services/network_caller.dart';
// import 'package:clause_verify/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class OtpController extends GetxController {
//   final TextEditingController otpTEController = TextEditingController();
//   final FocusNode focusNode = FocusNode();

//   RxString otp = ''.obs;
//   RxInt secondsRemaining = 30.obs;
//   RxBool isClickable = false.obs;
//   RxBool isLoading = false.obs;

//   late String email;
//   Timer? _timer;

//   @override
//   void onInit() {
//     super.onInit();

//     final arguments = Get.arguments;
//     if (arguments != null && arguments['email'] != null) {
//       email = arguments['email'] as String;
//     } else {
//       email = '';
//     }

//     startTimer();
//   }

//   void updateOtpValue(String value) {
//     otp.value = value;
//   }

//  Future<void> verifyOtp() async {
//   // Validate OTP
//   if (otp.value.length != 6) {
//     Get.snackbar(
//       'error'.tr,
//       'Please enter a valid 6-digit OTP',
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//     return;
//   }

//   if (email.isEmpty) {
//     Get.snackbar(
//       'error'.tr,
//       'Email not found. Please try registering again.',
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//     return;
//   }

//   isLoading.value = true;

//   try {
//     final Map<String, dynamic> otpData = {"email": email, "otp": otp.value};

//     final NetworkCaller networkCaller = NetworkCaller();
//     final ResponseData response = await networkCaller.postRequest(
//       Endpoints.forgotPassOtpVerify, // Updated to correct endpoint
//       body: otpData,
//       requiresAuth: false,
//     );

//     if (response.isSuccess) {
//       // Get data from response
//       final responseData = response.responseData;
//       final otpDataFromResponse = responseData?['data'] ?? {};
//       final verifiedEmail = otpDataFromResponse['email'] ?? email;
//       final verifiedOtp = otpDataFromResponse['otp'] ?? otp.value;

//       // Clear before navigation
//       _cleanup();

//       // Navigate to reset password screen with data
//       Get.offNamed(
//         AppRoute.resetPasswordScreen,
//         arguments: {
//           'email': verifiedEmail,
//           'otp': verifiedOtp,
//         },
//       );
      
//       // Optional: Show success message
//       Get.snackbar(
//         'success'.tr,
//         response.responseData?['message'] ?? 'OTP verified successfully',
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         duration: Duration(seconds: 2),
//       );
//     } else {
//       String errorMessage =
//           response.responseData?['message']?.toString() ??
//           response.errorMessage ??
//           'OTP verification failed';

//       Get.snackbar(
//         'error'.tr,
//         errorMessage,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: Duration(seconds: 3),
//       );
//     }
//   } catch (e) {
//     Get.snackbar(
//       'error'.tr,
//       'network_error'.tr,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//       duration: Duration(seconds: 3),
//     );
//   } finally {
//     isLoading.value = false;
//   }
// }

//   Future<void> resendOtp() async {
//     if (!isClickable.value) return;
//     if (email.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Email not found',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     isLoading.value = true;

//     try {
//       final Map<String, dynamic> resendData = {"email": email};

//       final NetworkCaller networkCaller = NetworkCaller();
//       final ResponseData response = await networkCaller.postRequest(
//         Endpoints.resendOtp,
//         body: resendData,
//         requiresAuth: false,
//       );

//       if (response.isSuccess) {
//         // Reset timer
//         otpTEController.clear();
//         secondsRemaining.value = 30;
//         isClickable.value = false;
//         startTimer();

//         Get.snackbar(
//           'success'.tr,
//           response.responseData?['message']?.toString() ??
//               'OTP sent successfully',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       } else {
//         String errorMessage =
//             response.responseData?['message']?.toString() ??
//             response.errorMessage ??
//             'Failed to resend OTP';

//         Get.snackbar(
//           'error'.tr,
//           errorMessage,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'error'.tr,
//         'network_error'.tr,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void startTimer() {
//     // Stop existing timer
//     _timer?.cancel();

//     // Reset values
//     secondsRemaining.value = 30;
//     isClickable.value = false;

//     // Start new timer
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (secondsRemaining.value > 1) {
//         secondsRemaining.value--;
//       } else {
//         // When timer reaches 0
//         secondsRemaining.value = 0;
//         isClickable.value = true;
//         timer.cancel();
//         _timer = null;
//       }
//     });
//   }

//   void _cleanup() {
//     // Clear controllers
//     otpTEController.clear();

//     // Unfocus
//     if (focusNode.hasFocus) {
//       focusNode.unfocus();
//     }

//     // Cancel timer
//     _timer?.cancel();
//     _timer = null;
//   }

//   @override
//   void onClose() {
//     _cleanup();
//     super.onClose();
//   }
// }



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
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (email.isEmpty || forgotPasswordToken.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'Required information missing. Please start again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
          backgroundColor: Colors.green,
          colorText: Colors.white,
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