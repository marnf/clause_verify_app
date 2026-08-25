// import 'package:clause_verify/core/common/widgets/custom_text_field.dart';
// import 'package:clause_verify/core/utils/constants/app_colors.dart';
// import 'package:clause_verify/core/utils/constants/app_sizer.dart';
// import 'package:clause_verify/routes/app_routes.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:clause_verify/features/auth/controller/registration_controller.dart';

// class RegistrationScreen extends StatelessWidget {
//   RegistrationScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(RegistrationController());

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 40.h),

//               // Title
//               Text(
//                 'joinUsToday'.tr,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 28.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 12.h),

//               // Subtitle
//               Text(
//                 'createYourAccountInAFewSimpleStepsAndUnlockAccessToExclusiveFeatures'.tr,
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 14.sp,
//                   height: 1.5,
//                 ),
//               ),
//               SizedBox(height: 60.h),

//               // First Name & Last Name Row
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'firstName'.tr,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14.sp,
//                           ),
//                         ),
//                         SizedBox(height: 8.h),
//                         CustomTextField(
//                           controller: controller.firstNameController,
//                           hintText: 'firstNamePlaceholder'.tr,
//                           containerColor: Colors.white,
//                           hintTextColor: Colors.grey[400],
//                           radius: 12,
//                         ),
//                         // First Name Error Message - HIDDEN
//                         SizedBox.shrink(),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 16.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'lastName'.tr,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14.sp,
//                           ),
//                         ),
//                         SizedBox(height: 8.h),
//                         CustomTextField(
//                           controller: controller.lastNameController,
//                           hintText: 'lastNamePlaceholder'.tr,
//                           containerColor: Colors.white,
//                           hintTextColor: Colors.grey[400],
//                           radius: 12,
//                         ),
//                         // Last Name Error Message - HIDDEN
//                         SizedBox.shrink(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16.h),

//               // Email
//               Text(
//                 'email'.tr,
//                 style: TextStyle(color: Colors.white, fontSize: 14.sp),
//               ),
//               SizedBox(height: 8.h),
//               CustomTextField(
//                 controller: controller.emailController,
//                 hintText: 'yourEmail'.tr,
//                 keyboardType: TextInputType.emailAddress,
//                 containerColor: Colors.white,
//                 hintTextColor: Colors.grey[400],
//                 radius: 12,
//               ),
//               // Email Error Message - শুধু যখন user টাইপ করবে
//               Obx(() {
//                 final error = controller.emailError.value;
//                 final hasStartedTyping = controller.hasStartedTypingEmail.value;
//                 return error.isNotEmpty && hasStartedTyping
//                     ? Padding(
//                         padding: EdgeInsets.only(top: 4.h),
//                         child: Text(
//                           error,
//                           style: TextStyle(color: Colors.red, fontSize: 12.sp),
//                         ),
//                       )
//                     : SizedBox.shrink();
//               }),
//               SizedBox(height: 16.h),

//               // Password
//               Text(
//                 'password'.tr,
//                 style: TextStyle(color: Colors.white, fontSize: 14.sp),
//               ),
//               SizedBox(height: 8.h),
//               Obx(
//                 () => CustomTextField(
//                   controller: controller.passwordController,
//                   hintText: 'yourPassword'.tr,
//                   obscureText: controller.isPasswordHidden.value,
//                   containerColor: Colors.white,
//                   hintTextColor: Colors.grey[400],
//                   radius: 12,
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       controller.isPasswordHidden.value
//                           ? Icons.visibility_outlined
//                           : Icons.visibility_off_outlined,
//                       color: Colors.grey[600],
//                     ),
//                     onPressed: controller.togglePasswordVisibility,
//                   ),
//                 ),
//               ),
//               // Password Error Message - শুধু যখন user টাইপ করবে
//               Obx(() {
//                 final error = controller.passwordError.value;
//                 final hasStartedTyping =
//                     controller.hasStartedTypingPassword.value;
//                 return error.isNotEmpty && hasStartedTyping
//                     ? Padding(
//                         padding: EdgeInsets.only(top: 4.h),
//                         child: Text(
//                           error,
//                           style: TextStyle(color: Colors.red, fontSize: 12.sp),
//                         ),
//                       )
//                     : SizedBox.shrink();
//               }),
//               SizedBox(height: 16.h),

//               // Confirm Password
//               Text(
//                 'confirmPassword'.tr,
//                 style: TextStyle(color: Colors.white, fontSize: 14.sp),
//               ),
//               SizedBox(height: 8.h),
//               Obx(
//                 () => CustomTextField(
//                   controller: controller.confirmPasswordController,
//                   hintText: 'confirmYourPassword'.tr,
//                   obscureText: controller.isConfirmPasswordHidden.value,
//                   containerColor: Colors.white,
//                   hintTextColor: Colors.grey[400],
//                   radius: 12,
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       controller.isConfirmPasswordHidden.value
//                           ? Icons.visibility_outlined
//                           : Icons.visibility_off_outlined,
//                       color: Colors.grey[600],
//                     ),
//                     onPressed: controller.toggleConfirmPasswordVisibility,
//                   ),
//                 ),
//               ),
//               // Confirm Password Error Message - শুধু যখন user টাইপ করবে
//               Obx(() {
//                 final error = controller.confirmPasswordError.value;
//                 final hasStartedTyping =
//                     controller.hasStartedTypingConfirmPassword.value;
//                 return error.isNotEmpty && hasStartedTyping
//                     ? Padding(
//                         padding: EdgeInsets.only(top: 4.h),
//                         child: Text(
//                           error,
//                           style: TextStyle(color: Colors.red, fontSize: 12.sp),
//                         ),
//                       )
//                     : SizedBox.shrink();
//               }),
//               SizedBox(height: 40.h),

//               // Terms & Conditions
//               Center(
//                 child: RichText(
//                   textAlign: TextAlign.center,
//                   text: TextSpan(
//                     text: 'byRegisteringYouAgreeTo'.tr + '\n',
//                     style: TextStyle(color: Colors.white70, fontSize: 12.sp),
//                     children: [
//                       TextSpan(
//                         text: 'termsConditions'.tr,
//                         style: TextStyle(
//                           color: Colors.amber[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                              Get.toNamed(AppRoute.termsAndCondition);
//                           },
//                       ),
//                       TextSpan(text: 'and'.tr),
//                       TextSpan(
//                         text: 'privacyPolicy'.tr,
//                         style: TextStyle(
//                           color: Colors.amber[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                            Get.toNamed(AppRoute.termsAndCondition);
//                           },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 28.h),

//               // Next Button
//               Obx(
//                 () => SizedBox(
//                   width: double.infinity,
//                   height: 56.h,
//                   child: Material(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       side: BorderSide(color: Colors.black, width: 1.5.w),
//                     ),
//                     child: ElevatedButton(
//                       onPressed: controller.isFormValid.value
//                           ? controller.onNextPressed
//                           : null,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: controller.isFormValid.value
//                             ? AppColors.primaryColor
//                             : Color(0xBD282111),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 0,
//                         disabledBackgroundColor: Color(0xBD282111),
//                       ),
//                       child: controller.isLoading.value
//                           ? CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2.w,
//                             )
//                           : Text(
//                               'next'.tr,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 28.h),

//               // Login Link
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "alreadyHaveAnAccount".tr,
//                     style: TextStyle(color: Colors.grey[400], fontSize: 15.sp),
//                   ),
//                   InkWell(
//                     onTap: controller.navigateToLogin,
//                     child: Text(
//                       'login'.tr,
//                       style: TextStyle(
//                         color: Color(0xFFD4AF37),
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clause_verify/features/auth/controller/registration_controller.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegistrationController());

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48.h),

              // ── Title ──
              Text(
                'joinUsToday'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 12.h),

              // ── Subtitle ──
              Text(
                'createYourAccountInAFewSimpleStepsAndUnlockAccessToExclusiveFeatures'
                    .tr,
                style: TextStyle(
                  color: const Color(0xFFB0A090),
                  fontSize: 14.sp,
                  height: 1.6,
                ),
              ),
              SizedBox(height: 36.h),

              // ── Name field ──
              Text(
                'name'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 8.h),
              _buildTextField(
                controller: controller.firstNameController,
                hintText: 'yourName'.tr,
              ),
              SizedBox(height: 20.h),

              // ── Email field ──
              Text(
                'email'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() {
                final hasError = controller.emailError.value.isNotEmpty &&
                    controller.hasStartedTypingEmail.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: controller.emailController,
                      hintText: 'yourEmail'.tr,
                      keyboardType: TextInputType.emailAddress,
                      hasError: hasError,
                    ),
                    if (hasError)
                      _buildErrorRow(controller.emailError.value),
                  ],
                );
              }),
              SizedBox(height: 20.h),

              // ── Password field ──
              Text(
                'password'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() {
                final hasError = controller.passwordError.value.isNotEmpty &&
                    controller.hasStartedTypingPassword.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: controller.passwordController,
                      hintText: 'yourPassword'.tr,
                      obscureText: controller.isPasswordHidden.value,
                      hasError: hasError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF6E6E6E),
                          size: 20,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                    if (hasError)
                      _buildErrorRow(controller.passwordError.value),
                  ],
                );
              }),
              SizedBox(height: 20.h),

              // ── Confirm Password field ──
              Text(
                'confirmPassword'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() {
                final hasError =
                    controller.confirmPasswordError.value.isNotEmpty &&
                        controller.hasStartedTypingConfirmPassword.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: controller.confirmPasswordController,
                      hintText: 'confirmYourPassword'.tr,
                      obscureText: controller.isConfirmPasswordHidden.value,
                      hasError: hasError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordHidden.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF6E6E6E),
                          size: 20,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                    if (hasError)
                      _buildErrorRow(controller.confirmPasswordError.value),
                  ],
                );
              }),

              SizedBox(height: 32.h),

              // ── Terms & Conditions ──
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'byRegisteringYouAgreeTo'.tr + '\n',
                    style: TextStyle(
                      color: const Color(0xFFB0A090),
                      fontSize: 12.sp,
                      height: 1.8,
                    ),
                    children: [
                      TextSpan(
                        text: 'termsConditions'.tr,
                        style: const TextStyle(
                          color: Color(0xFFC9952A),
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(AppRoute.termsAndCondition);
                          },
                      ),
                      TextSpan(
                        text: ' ${'and'.tr} ',
                        style: TextStyle(
                          color: const Color(0xFFB0A090),
                          fontSize: 12.sp,
                        ),
                      ),
                      TextSpan(
                        text: 'privacyPolicy'.tr,
                        style: const TextStyle(
                          color: Color(0xFFC9952A),
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(AppRoute.termsAndCondition);
                          },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              // ── Next Button ──
              Obx(
  () => SizedBox(
    width: double.infinity,
    height: 54.h,
    child: ElevatedButton(
      onPressed: controller.isFormValid.value &&
              !controller.isLoading.value
          ? controller.onNextPressed
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFC9952A),
        disabledBackgroundColor:
            const Color(0xFFC9952A).withOpacity(0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        padding: EdgeInsets.zero, // 👈 extra padding remove
        minimumSize: Size.zero,   // 👈 default min height constraint remove
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 👈 extra tap area padding remove
      ),
      child: Center( // 👈 vertical centering নিশ্চিত করে
        child: controller.isLoading.value
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'next'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    ),
  ),
),

              SizedBox(height: 24.h),

              // ── Login link ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'alreadyHaveAnAccount'.tr,
                    style: TextStyle(
                      color: const Color(0xFFB0A090),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  GestureDetector(
                    onTap: controller.navigateToLogin,
                    child: Text(
                      'login'.tr,
                      style: TextStyle(
                        color: const Color(0xFFC9952A),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  // ── Reusable dark text field ──
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    bool hasError = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF6E6E6E)),
        filled: true,
        fillColor: hasError ? const Color(0xFF2A1010) : const Color(0xFF1A1A1A),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: hasError ? Colors.redAccent : const Color(0xFF2E2E2E),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFC9952A),
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: suffixIcon,
      ),
    );
  }

  // ── Reusable error row ──
 // ── Reusable error row ──
Widget _buildErrorRow(String message) {
  return Padding(
    padding: const EdgeInsets.only(top: 6, left: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start, // ← Changed to start
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: const Icon(Icons.error_outline, color: Colors.redAccent, size: 14),
        ),
        const SizedBox(width: 4),
        Expanded(  // ← Wrap Text with Expanded
          child: Text(
            message,
            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            softWrap: true,  // ← Allow text wrapping
            overflow: TextOverflow.visible,  // ← Allow overflow to be visible (wrapping)
          ),
        ),
      ],
    ),
  );
}
}