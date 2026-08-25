import 'package:clause_verify/core/models/response_data.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clause_verify/core/utils/validators/app_validator.dart';

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
        "full_name": firstNameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text,
        "confirm_password": confirmPasswordController.text,
        "user_type": "user",
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

        final successMsg = response.responseData?['success'];
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
        final errorMsg = response.responseData?['error'] ?? response.errorMessage;

        Get.snackbar(
          'error'.tr,
          errorMsg.toString(),
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