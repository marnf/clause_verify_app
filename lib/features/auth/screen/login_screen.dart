
// import 'dart:io';
// import 'package:clause_verify/core/utils/constants/app_colors.dart';
// import 'package:clause_verify/core/utils/constants/app_sizer.dart';
// import 'package:clause_verify/core/utils/constants/image_path.dart';
// import 'package:clause_verify/features/auth/controller/login_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   late final LoginController controller;

//   @override
//   void initState() {
//     super.initState();

//     if (Get.isRegistered<LoginController>()) {
//       Get.delete<LoginController>(force: true);
//     }
//     controller = LoginController();
//     controller.onInit();
//   }

//   @override
//   void dispose() {
//     controller.onClose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               minHeight: MediaQuery.of(context).size.height -
//                   MediaQuery.of(context).padding.top -
//                   MediaQuery.of(context).padding.bottom,
//             ),
//             child: IntrinsicHeight(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(
//                       top: 30.h,
//                       left: 24.w,
//                       right: 24.w,
//                       bottom: 28.h,
//                     ),
//                     child: Column(
//                       children: [
//                         Image.asset(
//                           ImagePath.logo,
//                           height: 100.h,
//                         ),
//                         Image.asset(
//                           ImagePath.logo_name,
//                           height: 100.h,
//                         ),
//                         Text(
//                           'welcomeBack'.tr,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: AppColors.textSubtle,
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w400,
//                             letterSpacing: 0.3,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 24.w),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'email'.tr,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w600,
//                               letterSpacing: 0.2,
//                             ),
//                           ),
//                           SizedBox(height: 8.h),
//                           Obx(
//                             () => Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 _buildTextField(
//                                   controller: controller.emailController,
//                                   hintText: 'enterYourEmail'.tr,
//                                   hasError:
//                                       controller.emailError.value.isNotEmpty,
//                                   onChanged: (value) {
//                                     if (controller
//                                         .emailError.value.isNotEmpty) {
//                                       controller.validateEmail(value);
//                                     }
//                                   },
//                                 ),
//                                 if (controller.emailError.value.isNotEmpty)
//                                   Padding(
//                                     padding:
//                                         EdgeInsets.only(top: 6.h, left: 4.w),
//                                     child: Row(
//                                       children: [
//                                         Icon(
//                                           Icons.error_outline,
//                                           color: Colors.redAccent,
//                                           size: 14.sp,
//                                         ),
//                                         SizedBox(width: 4.w),
//                                         Text(
//                                           controller.emailError.value,
//                                           style: TextStyle(
//                                             color: Colors.redAccent,
//                                             fontSize: 12.sp,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 20.h),
//                           Text(
//                             'password'.tr,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w600,
//                               letterSpacing: 0.2,
//                             ),
//                           ),
//                           SizedBox(height: 8.h),
//                           Obx(
//                             () => _buildTextField(
//                               controller: controller.passwordController,
//                               hintText: 'password'.tr,
//                               obscureText:
//                                   !controller.isPasswordVisible.value,
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   controller.isPasswordVisible.value
//                                       ? Icons.visibility_outlined
//                                       : Icons.visibility_off_outlined,
//                                   color: AppColors.textMuted,
//                                   size: 20.sp,
//                                 ),
//                                 onPressed:
//                                     controller.togglePasswordVisibility,
//                               ),
//                             ),
//                           ),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: TextButton(
//                               onPressed: controller.forgotPassword,
//                               child: Text(
//                                 'forgotPassword'.tr,
//                                 style: TextStyle(
//                                   color: AppColors.primaryColor,
//                                   fontSize: 13.sp,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 12.h),
//                           Obx(
//                             () => SizedBox(
//                               width: double.infinity,
//                               height: 54.h,
//                               child: ElevatedButton(
//                                 onPressed: controller.isFormValid.value &&
//                                         !controller.isLoading.value
//                                     ? controller.login
//                                     : null,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: AppColors.primaryColor,
//                                   disabledBackgroundColor: AppColors.primaryColor
//                                       .withOpacity(0.45),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   elevation: 0,
//                                   padding: EdgeInsets.zero,
//                                   minimumSize: Size.zero,
//                                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                                 ),
//                                 child: Center(
//                                   child: controller.isLoading.value
//                                       ? const SizedBox(
//                                           width: 22,
//                                           height: 22,
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 2,
//                                             valueColor:
//                                                 AlwaysStoppedAnimation<Color>(
//                                                     Colors.white),
//                                           ),
//                                         )
//                                       : Text(
//                                           'login'.tr,
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 16.sp,
//                                             fontWeight: FontWeight.w700,
//                                             letterSpacing: 0.5,
//                                           ),
//                                         ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 28.h),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Divider(
//                                   color: AppColors.divider,
//                                   thickness: 1,
//                                 ),
//                               ),
//                               Padding(
//                                 padding:
//                                     EdgeInsets.symmetric(horizontal: 14.w),
//                                 child: Text(
//                                   'orContinueWith'.tr,
//                                   style: TextStyle(
//                                     color: AppColors.textMuted,
//                                     fontSize: 13.sp,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Divider(
//                                   color: AppColors.divider,
//                                   thickness: 1,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 22.h),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Obx(
//                                 () => _buildSocialButton(
//                                   onTap: controller.isGoogleLoading.value
//                                       ? null
//                                       : controller.loginWithGoogle,
//                                   isLoading: controller.isGoogleLoading.value,
//                                   child: Image.asset(
//                                     'assets/icons/google.png',
//                                     width: 26.w,
//                                     height: 26.h,
//                                   ),
//                                   loadingColor: AppColors.primaryColor,
//                                 ),
//                               ),
//                               if (Platform.isIOS) ...[
//                                 SizedBox(width: 16.w),
//                                 Obx(
//                                   () => _buildSocialButton(
//                                     onTap: controller.isAppleLoading.value
//                                         ? null
//                                         : controller.loginWithApple,
//                                     isLoading: controller.isAppleLoading.value,
//                                     child: Icon(
//                                       Icons.apple,
//                                       size: 28.sp,
//                                       color: Colors.white,
//                                     ),
//                                     loadingColor: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ],
//                           ),
//                           SizedBox(height: 32.h),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "dontHaveAnAccount".tr,
//                                 style: TextStyle(
//                                   color: AppColors.textSubtle,
//                                   fontSize: 14.sp,
//                                 ),
//                               ),
//                               SizedBox(width: 4.w),
//                               GestureDetector(
//                                 onTap: controller.navigateToRegister,
//                                 child: Text(
//                                   'register'.tr,
//                                   style: TextStyle(
//                                     color: AppColors.primaryColor,
//                                     fontSize: 14.sp,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 32.h),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     bool obscureText = false,
//     bool hasError = false,
//     Widget? suffixIcon,
//     void Function(String)? onChanged,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       onChanged: onChanged,
//       style: const TextStyle(
//         color: Colors.white,
//         fontSize: 15,
//       ),
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: TextStyle(color: AppColors.textMuted),
//         filled: true,
//         fillColor:
//             hasError ? const Color(0xFF2A1010) : AppColors.surfaceLight,
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(
//             color: hasError ? Colors.redAccent : AppColors.cardBorder,
//             width: 1,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(
//             color: AppColors.primaryColor,
//             width: 1.5,
//           ),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 16,
//         ),
//         suffixIcon: suffixIcon,
//       ),
//     );
//   }

//   Widget _buildSocialButton({
//     required VoidCallback? onTap,
//     required bool isLoading,
//     required Widget child,
//     required Color loadingColor,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(32),
//       child: Container(
//         width: 56.w,
//         height: 56.h,
//         decoration: BoxDecoration(
//           color: AppColors.surfaceLight,
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: AppColors.cardBorder,
//             width: 1,
//           ),
//         ),
//         child: Center(
//           child: isLoading
//               ? SizedBox(
//                   width: 22.w,
//                   height: 22.h,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor:
//                         AlwaysStoppedAnimation<Color>(loadingColor),
//                   ),
//                 )
//               : child,
//         ),
//       ),
//     );
//   }
// }





import 'dart:io';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/core/utils/constants/image_path.dart';
import 'package:clause_verify/features/auth/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginController controller;

  @override
  void initState() {
    super.initState();

    if (Get.isRegistered<LoginController>()) {
      Get.delete<LoginController>(force: true);
    }
    controller = LoginController();
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 30.h,
                      left: 24.w,
                      right: 24.w,
                      bottom: 28.h,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          ImagePath.logo,
                          height: 100.h,
                        ),
                        Image.asset(
                          ImagePath.logo_name,
                          height: 100.h,
                        ),
                        Text(
                          'welcomeBack'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'email'.tr,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTextField(
                                  controller: controller.emailController,
                                  hintText: 'enterYourEmail'.tr,
                                  hasError:
                                      controller.emailError.value.isNotEmpty,
                                  onChanged: (value) {
                                    if (controller
                                        .emailError.value.isNotEmpty) {
                                      controller.validateEmail(value);
                                    }
                                  },
                                ),
                                if (controller.emailError.value.isNotEmpty)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 6.h, left: 4.w),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: AppColors.error,
                                          size: 14.sp,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          controller.emailError.value,
                                          style: TextStyle(
                                            color: AppColors.error,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'password'.tr,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Obx(
                            () => _buildTextField(
                              controller: controller.passwordController,
                              hintText: 'password'.tr,
                              obscureText:
                                  !controller.isPasswordVisible.value,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.textMuted,
                                  size: 20.sp,
                                ),
                                onPressed:
                                    controller.togglePasswordVisibility,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: controller.forgotPassword,
                              child: Text(
                                'forgotPassword'.tr,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 54.h,
                              child: ElevatedButton(
                                onPressed: controller.isFormValid.value &&
                                        !controller.isLoading.value
                                    ? controller.login
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  disabledBackgroundColor: AppColors.primaryColor
                                      .withOpacity(0.45),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Center(
                                  child: controller.isLoading.value
                                      ? SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    AppColors.black),
                                          ),
                                        )
                                      : Text(
                                          'login'.tr,
                                          style: TextStyle(
                                            color: AppColors.black,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 28.h),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: AppColors.divider,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 14.w),
                                child: Text(
                                  'orContinueWith'.tr,
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: AppColors.divider,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 22.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(
                                () => _buildSocialButton(
                                  onTap: controller.isGoogleLoading.value
                                      ? null
                                      : controller.loginWithGoogle,
                                  isLoading: controller.isGoogleLoading.value,
                                  child: Image.asset(
                                    'assets/icons/google.png',
                                    width: 26.w,
                                    height: 26.h,
                                  ),
                                  loadingColor: AppColors.primaryColor,
                                ),
                              ),
                              if (Platform.isIOS) ...[
                                SizedBox(width: 16.w),
                                Obx(
                                  () => _buildSocialButton(
                                    onTap: controller.isAppleLoading.value
                                        ? null
                                        : controller.loginWithApple,
                                    isLoading: controller.isAppleLoading.value,
                                    child: Icon(
                                      Icons.apple,
                                      size: 28.sp,
                                      color: AppColors.white,
                                    ),
                                    loadingColor: AppColors.white,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 32.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "dontHaveAnAccount".tr,
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              GestureDetector(
                                onTap: controller.navigateToRegister,
                                child: Text(
                                  'register'.tr,
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    bool hasError = false,
    Widget? suffixIcon,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      style: TextStyle(
        color: AppColors.white,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.surfaceLight,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: hasError ? AppColors.error : AppColors.cardBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback? onTap,
    required bool isLoading,
    required Widget child,
    required Color loadingColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 22.w,
                  height: 22.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(loadingColor),
                  ),
                )
              : child,
        ),
      ),
    );
  }
}