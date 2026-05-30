// import 'package:flutter_extension/core/models/response_data.dart';
// import 'package:flutter_extension/core/services/endpoints.dart';
// import 'package:flutter_extension/core/services/network_caller.dart';
// import 'package:flutter_extension/core/utils/constants/app_colors.dart';
// import 'package:flutter_extension/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_extension/core/utils/validators/app_validator.dart';

// class RegistrationController extends GetxController {
//   // Text Controllers
//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   // Error Messages - প্রথমে সবাই empty
//   final firstNameError = RxString('');
//   final lastNameError = RxString('');
//   final emailError = RxString('');
//   final passwordError = RxString('');
//   final confirmPasswordError = RxString('');

//   // Track if user has started typing
//   final hasStartedTypingEmail = false.obs;
//   final hasStartedTypingPassword = false.obs;
//   final hasStartedTypingConfirmPassword = false.obs;

//   // UI States
//   final isPasswordHidden = true.obs;
//   final isConfirmPasswordHidden = true.obs;
//   final isLoading = false.obs;
//   final isFormValid = false.obs;

//   @override
//   void onInit() {
//     super.onInit();

//     // Setup listeners for all controllers
//     _setupListeners();

//     // Initial validation
//     _validateForm();
//   }

//   void _setupListeners() {
//     // First Name listener
//     firstNameController.addListener(() {
//       _validateForm();
//     });

//     // Last Name listener
//     lastNameController.addListener(() {
//       _validateForm();
//     });

//     // Email listener
//     emailController.addListener(() {
//       if (emailController.text.isNotEmpty) {
//         hasStartedTypingEmail.value = true;
//       }
//       _validateForm();
//     });

//     // Password listener
//     passwordController.addListener(() {
//       if (passwordController.text.isNotEmpty) {
//         hasStartedTypingPassword.value = true;
//       }
//       _validateForm();
//     });

//     // Confirm Password listener
//     confirmPasswordController.addListener(() {
//       if (confirmPasswordController.text.isNotEmpty) {
//         hasStartedTypingConfirmPassword.value = true;
//       }
//       _validateForm();
//     });
//   }

//   @override
//   void onClose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.onClose();
//   }

//   // Form validation method
//   void _validateForm() {
//     // First Name validation - শুধু internal validation, UI তে error show করবে না
//     if (firstNameController.text.trim().isEmpty) {
//       firstNameError.value = 'First name is required';
//     } else {
//       firstNameError.value = '';
//     }

//     // Last Name validation - শুধু internal validation, UI তে error show করবে না
//     if (lastNameController.text.trim().isEmpty) {
//       lastNameError.value = 'Last name is required';
//     } else {
//       lastNameError.value = '';
//     }

//     // Email validation - শুধু যখন user টাইপ করবে তখন validation
//     if (!hasStartedTypingEmail.value) {
//       emailError.value = ''; // প্রথমে error দেখাবে না
//     } else if (emailController.text.trim().isEmpty) {
//       emailError.value = 'Email is required';
//     } else if (!GetUtils.isEmail(emailController.text.trim())) {
//       emailError.value = 'Please enter a valid email';
//     } else {
//       emailError.value = '';
//     }

//     // Password validation - শুধু যখন user টাইপ করবে তখন validation
//     if (!hasStartedTypingPassword.value) {
//       passwordError.value = ''; // প্রথমে error দেখাবে না
//     } else {
//       final passwordValidation = AppValidator.validatePassword(
//         passwordController.text,
//       );
//       if (passwordValidation != null) {
//         passwordError.value = passwordValidation;
//       } else {
//         passwordError.value = '';
//       }
//     }

//     // Confirm Password validation - শুধু যখন user টাইপ করবে তখন validation
//     if (!hasStartedTypingConfirmPassword.value) {
//       confirmPasswordError.value = ''; // প্রথমে error দেখাবে না
//     } else if (confirmPasswordController.text.isEmpty) {
//       confirmPasswordError.value = 'Please confirm your password';
//     } else if (confirmPasswordController.text != passwordController.text) {
//       confirmPasswordError.value = 'Passwords do not match';
//     } else {
//       confirmPasswordError.value = '';
//     }

//     // Update form validity
//     isFormValid.value =
//         firstNameController.text.trim().isNotEmpty &&
//         lastNameController.text.trim().isNotEmpty &&
//         emailController.text.trim().isNotEmpty &&
//         GetUtils.isEmail(emailController.text.trim()) &&
//         passwordController.text.isNotEmpty &&
//         AppValidator.validatePassword(passwordController.text) == null &&
//         confirmPasswordController.text.isNotEmpty &&
//         confirmPasswordController.text == passwordController.text;
//   }

//   // Toggle password visibility
//   void togglePasswordVisibility() {
//     isPasswordHidden.value = !isPasswordHidden.value;
//   }

//   // Toggle confirm password visibility
//   void toggleConfirmPasswordVisibility() {
//     isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
//   }

//   // Next button pressed
//   Future<void> onNextPressed() async {
//     if (!isFormValid.value) return;

//     isLoading.value = true;

//     try {
//       final Map<String, dynamic> registrationData = {
//         "first_name": firstNameController.text.trim(),
//         "last_name": lastNameController.text.trim(),
//         "email": emailController.text.trim(),
//         "password": passwordController.text,
//         "confirm_password": confirmPasswordController.text,
//       };

//       final NetworkCaller networkCaller = NetworkCaller();
//       final ResponseData response = await networkCaller.postRequest(
//         Endpoints.register,
//         body: registrationData,
//         requiresAuth: false,
//       );

//       // Check if API call was successful
//         if (response.isSuccess) {
//       // SUCCESS - Get email from controller
//       final String email = emailController.text.trim();
      
//       // Navigate to OTP screen with email
//       Get.toNamed(
//         AppRoute.otpVerificationScreenForRegistraion,
//         arguments: {'email': email},
//       );

//         // Show success message from backend if exists
//         final successMsg = response.responseData?['message'];
//         if (successMsg != null) {
//           Get.snackbar(
//             'success'.tr,
//             successMsg.toString(),
//             backgroundColor: AppColors.primaryColor,
//             colorText: Colors.white,
//             duration: Duration(seconds: 2),
//           );
//         }
//       } else {
//         // ERROR - Show error message
//         // First try to get message from backend response
//         String errorMessage = response.responseData?['message'];

//         // If no message from backend, use NetworkCaller's error message
//         if (errorMessage == null || errorMessage.isEmpty) {
//           errorMessage = response.errorMessage;
//         }

//         // Show in snackbar
//         Get.snackbar(
//           'error'.tr,
//           errorMessage,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           duration: Duration(seconds: 4),
//         );
//       }
//     } catch (e) {
//       // Network or other exceptions
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

//   // Navigate to login screen
//   void navigateToLogin() {
//     Get.toNamed(AppRoute.loginScreen);
//   }
// }



import 'package:flutter_extension/core/models/response_data.dart';
import 'package:flutter_extension/core/services/endpoints.dart';
import 'package:flutter_extension/core/services/network_caller.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_extension/core/utils/validators/app_validator.dart';

class RegistrationController extends GetxController {
  // Text Controllers
  final firstNameController = TextEditingController(); // used as full "name"
  final lastNameController = TextEditingController();  // kept for API compat, not shown in UI
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Error Messages
  final firstNameError = RxString('');
  final lastNameError = RxString('');
  final emailError = RxString('');
  final passwordError = RxString('');
  final confirmPasswordError = RxString('');

  // Track if user has started typing
  final hasStartedTypingEmail = false.obs;
  final hasStartedTypingPassword = false.obs;
  final hasStartedTypingConfirmPassword = false.obs;

  // UI States
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;
  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
    _validateForm();
  }

  void _setupListeners() {
    firstNameController.addListener(_validateForm);

    emailController.addListener(() {
      if (emailController.text.isNotEmpty) hasStartedTypingEmail.value = true;
      _validateForm();
    });

    passwordController.addListener(() {
      if (passwordController.text.isNotEmpty) hasStartedTypingPassword.value = true;
      _validateForm();
    });

    confirmPasswordController.addListener(() {
      if (confirmPasswordController.text.isNotEmpty) hasStartedTypingConfirmPassword.value = true;
      _validateForm();
    });
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void _validateForm() {
    // Name (firstNameController = full name field)
    if (firstNameController.text.trim().isEmpty) {
      firstNameError.value = 'Name is required';
    } else {
      firstNameError.value = '';
    }

    // Email validation
    if (!hasStartedTypingEmail.value) {
      emailError.value = '';
    } else if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email is required';
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email';
    } else {
      emailError.value = '';
    }

    // Password validation
    if (!hasStartedTypingPassword.value) {
      passwordError.value = '';
    } else {
      final passwordValidation = AppValidator.validatePassword(passwordController.text);
      passwordError.value = passwordValidation ?? '';
    }

    // Confirm Password validation
    if (!hasStartedTypingConfirmPassword.value) {
      confirmPasswordError.value = '';
    } else if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
    } else {
      confirmPasswordError.value = '';
    }

    // Form valid check
    isFormValid.value =
        firstNameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        GetUtils.isEmail(emailController.text.trim()) &&
        passwordController.text.isNotEmpty &&
        AppValidator.validatePassword(passwordController.text) == null &&
        confirmPasswordController.text.isNotEmpty &&
        confirmPasswordController.text == passwordController.text;
  }

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  Future<void> onNextPressed() async {
    if (!isFormValid.value) return;

    isLoading.value = true;

    try {
      final Map<String, dynamic> registrationData = {
        "name": firstNameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text,
        "confirm_password": confirmPasswordController.text,
      };

      final NetworkCaller networkCaller = NetworkCaller();
      final ResponseData response = await networkCaller.postRequest(
        Endpoints.register,
        body: registrationData,
        requiresAuth: false,
      );

      if (response.isSuccess) {
        final String email = emailController.text.trim();

        Get.toNamed(
          AppRoute.otpVerificationScreenForRegistraion,
          arguments: {'email': email},
        );

        final successMsg = response.responseData?['message'];
        if (successMsg != null) {
          Get.snackbar(
            'success'.tr,
            successMsg.toString(),
            backgroundColor: AppColors.primaryColor,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        String errorMessage = response.responseData?['message'] ?? '';
        if (errorMessage.isEmpty) errorMessage = response.errorMessage;

        Get.snackbar(
          'error'.tr,
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
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

  void navigateToLogin() {
    Get.toNamed(AppRoute.loginScreen);
  }
}