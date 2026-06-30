import 'package:clause_verify/core/common/widgets/app_bar.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/auth/controller/reset_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  static Gradient linearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF212121), Color(0xFF000000)],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            /// ------------------ App Bar ------------------
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 24.w),
              child: CustomAppBar(title: 'otpVerification'.tr, centerTitle: true,),
            ),

            /// ------------------ Gradient Container ------------------
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: linearGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    /// 🔹 Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16.h),
                            
                            Text(
                              'createNewPassword'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'chooseAStrongNewPasswordForYourAccountMakeSureItsUniqueAndDifferentFromYourPreviousPasswordsToKeepYourAccountSecure'.tr,
                              style: TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 14.sp,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            
                            /// Password Field
                            Text(
                              'password'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Obx(
                              () => TextField(
                                controller: controller.passwordController,
                                focusNode: controller.passwordFocusNode,
                                obscureText: controller.isPasswordHidden.value,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                ),
                                decoration: InputDecoration(
                                  hintText: '***********',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF757575),
                                    fontSize: 15.sp,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 14.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD4AF37),
                                      width: 2.w,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isPasswordHidden.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.grey[600],
                                      size: 20.sp,
                                    ),
                                    onPressed: controller.togglePasswordVisibility,
                                  ),
                                ),
                              ),
                            ),
                            
                            /// Password Error Message
                            Obx(() {
                              final error = controller.passwordError.value;
                              final hasStartedTyping = controller.hasStartedTypingPassword.value;
                              return error.isNotEmpty && hasStartedTyping
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Text(
                                        error,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            }),
                            
                            SizedBox(height: 16.h),
                            
                            /// Confirm Password Field
                            Text(
                              'confirmPassword'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Obx(
                              () => TextField(
                                controller: controller.confirmPasswordController,
                                focusNode: controller.confirmPasswordFocusNode,
                                obscureText: controller.isConfirmPasswordHidden.value,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'passwordDotDotDot'.tr,
                                  hintStyle: TextStyle(
                                    color: Color(0xFF757575),
                                    fontSize: 15.sp,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 14.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD4AF37),
                                      width: 2.w,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isConfirmPasswordHidden.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.grey[600],
                                      size: 20.sp,
                                    ),
                                    onPressed: controller.toggleConfirmPasswordVisibility,
                                  ),
                                ),
                              ),
                            ),
                            
                            /// Confirm Password Error Message
                            Obx(() {
                              final error = controller.confirmPasswordError.value;
                              final hasStartedTyping = controller.hasStartedTypingConfirmPassword.value;
                              return error.isNotEmpty && hasStartedTyping
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Text(
                                        error,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            }),
                            
                            SizedBox(height: 80.h), // button overlap avoid
                          ],
                        ),
                      ),
                    ),

                    /// 🔹 Fixed Bottom Button
                    Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Obx(() {
                        return SizedBox(
                          width: double.infinity,
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value ? null : controller.resetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4AF37),
                              elevation: 0,
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: controller.isLoading.value
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.w,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'continue'.tr,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        Icons.arrow_forward, 
                                        color: Colors.black,
                                        size: 20.sp,
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}