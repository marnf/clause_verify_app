// import 'package:clause_verify/core/common/widgets/custom_modal.dart';
// import 'package:clause_verify/core/models/response_data.dart';
// import 'package:clause_verify/core/services/endpoints.dart';
// import 'package:clause_verify/core/services/network_caller.dart';
// import 'package:clause_verify/core/utils/constants/icon_path.dart';
// import 'package:clause_verify/core/utils/validators/app_validator.dart';
// import 'package:clause_verify/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ResetPasswordController extends GetxController {
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//   final FocusNode passwordFocusNode = FocusNode();
//   final FocusNode confirmPasswordFocusNode = FocusNode();
  
//   final passwordError = ''.obs;
//   final confirmPasswordError = ''.obs;
//   final hasStartedTypingPassword = false.obs;
//   final hasStartedTypingConfirmPassword = false.obs;
  
//   final isPasswordHidden = true.obs;
//   final isConfirmPasswordHidden = true.obs;
//   final isLoading = false.obs;

//   // Variables to store data from arguments
//   String email = '';
//   String otp = '';

//   @override
//   void onInit() {
//     super.onInit();
    
//     // Get data from arguments
//     final arguments = Get.arguments;
//     if (arguments != null && arguments is Map<String, dynamic>) {
//       email = arguments['email']?.toString() ?? '';
//       otp = arguments['otp']?.toString() ?? '';
      
//       print('📧 Received Email: $email');
//       print('🔢 Received OTP: $otp');
//     }
    
//     _setupListeners();
//   }

//   void _setupListeners() {
//     // Password listener
//     passwordController.addListener(() {
//       if (passwordController.text.isNotEmpty) {
//         hasStartedTypingPassword.value = true;
//       }
//       _validatePassword();
//       // Revalidate confirm password when password changes
//       if (hasStartedTypingConfirmPassword.value) {
//         _validateConfirmPassword();
//       }
//     });
    
//     // Confirm Password listener
//     confirmPasswordController.addListener(() {
//       if (confirmPasswordController.text.isNotEmpty) {
//         hasStartedTypingConfirmPassword.value = true;
//       }
//       _validateConfirmPassword();
//     });
//   }

//   void _validatePassword() {
//     // শুধু যখন user টাইপ করবে তখন validation
//     if (!hasStartedTypingPassword.value) {
//       passwordError.value = '';
//       return;
//     }

//     final password = passwordController.text;
    
//     if (password.isEmpty) {
//       passwordError.value = 'Password is required';
//     } else {
//       final passwordValidation = AppValidator.validatePassword(password);
//       if (passwordValidation != null) {
//         passwordError.value = passwordValidation;
//       } else {
//         passwordError.value = '';
//       }
//     }
//   }

//   void _validateConfirmPassword() {
//     // শুধু যখন user টাইপ করবে তখন validation
//     if (!hasStartedTypingConfirmPassword.value) {
//       confirmPasswordError.value = '';
//       return;
//     }

//     final confirmPassword = confirmPasswordController.text;
    
//     if (confirmPassword.isEmpty) {
//       confirmPasswordError.value = 'Please confirm your password';
//     } else if (confirmPassword != passwordController.text) {
//       confirmPasswordError.value = 'Passwords do not match';
//     } else {
//       confirmPasswordError.value = '';
//     }
//   }

//   void togglePasswordVisibility() {
//     isPasswordHidden.value = !isPasswordHidden.value;
//   }

//   void toggleConfirmPasswordVisibility() {
//     isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
//   }

//   Future<void> resetPassword() async {
//     // Force validation check on button press
//     hasStartedTypingPassword.value = true;
//     hasStartedTypingConfirmPassword.value = true;
//     _validatePassword();
//     _validateConfirmPassword();
    
//     if (passwordError.value.isNotEmpty || confirmPasswordError.value.isNotEmpty) {
//       return;
//     }

//     // Check if we have required data
//     if (email.isEmpty || otp.isEmpty) {
//       Get.snackbar(
//         'error'.tr,
//         'Required information is missing. Please try again from the beginning.',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     isLoading.value = true;

//     try {
//       // Prepare API data
//       final Map<String, dynamic> resetData = {
//         "email": email,
//         "otp": otp,
//         "new_password": passwordController.text,
//         "confirm_password": confirmPasswordController.text,
//       };

//       // Call API
//       final NetworkCaller networkCaller = NetworkCaller();
//       final ResponseData response = await networkCaller.postRequest(
//         Endpoints.resetPassword,
//         body: resetData,
//         requiresAuth: false,
//       );

//       if (response.isSuccess) {
//         // Clear controllers BEFORE showing dialog
//         passwordController.clear();
//         confirmPasswordController.clear();
        
//         // Show success dialog
//         showCustomDialogGetX(
//           imagePath: IconPath.successIcon,
//           title: 'Password Changed!',
//           subtitle: response.responseData?['message']?.toString() ??
//               'Thanks for changing your password, now we are going to redirect you to login screen, and then please login',
//           buttonText: 'Continue',
//           onButtonPressed: () {
//             // Close dialog first
//             Get.back();
//             // Then navigate to login screen, removing all previous routes
//             Get.offNamed(AppRoute.loginScreen);
//           },
//         );
//       } else {
//         // Show error message
//         String errorMessage = response.responseData?['message']?.toString() ??
//             response.errorMessage ??
//             'Failed to reset password. Please try again.';
            
//         Get.snackbar(
//           'error'.tr,
//           errorMessage,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           duration: Duration(seconds: 3),
//         );
//       }
//     } catch (e) {
//       // Network or other errors
//       Get.snackbar(
//         'error'.tr,
//         'network_error'.tr,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: Duration(seconds: 3),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   @override
//   void onClose() {
//     // Remove listeners before disposing
//     passwordController.removeListener(_validatePassword);
//     confirmPasswordController.removeListener(_validateConfirmPassword);
    
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     passwordFocusNode.dispose();
//     confirmPasswordFocusNode.dispose();
//     super.onClose();
//   }
// }


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
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }
}