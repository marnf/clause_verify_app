// import 'package:flutter_extension/core/common/widgets/app_bar.dart';
// import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
// import 'package:flutter_extension/core/utils/constants/icon_path.dart';
// import 'package:flutter_extension/features/auth/controller/otp_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pinput/pinput.dart';

// class OtpVerificationScreen extends StatelessWidget {
//   final OtpController controller = Get.put(OtpController());

//   static Gradient linearGradient = LinearGradient(
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//     colors: [Color(0xFF212121), Color(0xFF000000)],
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             /// ------------------ App Bar ------------------
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 24.w),
//               child: CustomAppBar(
//                 title: 'otpVerification'.tr,
//                 centerTitle: true,
//               ),
//             ),

//             /// ------------------ Gradient Container ------------------
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   gradient: linearGradient,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(32),
//                     topRight: Radius.circular(32),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     /// 🔹 Scrollable content
//                     Expanded(
//                       child: SingleChildScrollView(
//                         padding: EdgeInsets.all(24.w),
//                         child: Column(
//                           children: [
//                             SizedBox(height: 32.h),

//                             /// Icon
//                             Container(
//                               child: Image.asset(
//                                 IconPath.otp,
//                                 width: 80.w,
//                                 height: 80.h,
//                               ),
//                             ),

//                             SizedBox(height: 24.h),

//                             Text(
//                               'otpVerification'.tr,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 25.sp,
//                               ),
//                             ),

//                             SizedBox(height: 14.h),

//                             Text(
//                               'enterTheOTPSentToYourEmailToVerifyYourIdentityOnceVerifiedYouCanProceedToSignIn'
//                                   .tr,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.grey[400],
//                                 fontSize: 13.sp,
//                               ),
//                             ),

//                             SizedBox(height: 32.h),

//                             /// OTP Input
//                             Pinput(
//                               length: 6,
//                               controller: controller.otpTEController,
//                               focusNode: controller.focusNode,
//                               onChanged: controller.updateOtpValue,
//                               onCompleted: (_) => controller.verifyOtp,
//                               defaultPinTheme: PinTheme(
//                                 width: 48.w,
//                                 height: 48.h,
//                                 textStyle: TextStyle(
//                                   fontSize: 22.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               separatorBuilder: (_) => SizedBox(width: 8.w),
//                             ),

//                             SizedBox(height: 24.h),

//                             /// Resend Widget - ঠিক করা
//                             Obx(() {
//                               final minutes =
//                                   controller.secondsRemaining.value ~/ 60;
//                               final seconds =
//                                   controller.secondsRemaining.value % 60;

//                               return Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     controller.isClickable.value
//                                         ? "haventReceivedTheCode".tr
//                                         : "resendIn".tr +
//                                               " ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} ",
//                                     style: TextStyle(
//                                       color: Colors.grey[400],
//                                       fontSize: 14.sp,
//                                     ),
//                                   ),
//                                   if (controller.isClickable.value)
//                                     GestureDetector(
//                                       onTap: controller.resendOtp,
//                                       child: Text(
//                                         'resend'.tr,
//                                         style: TextStyle(
//                                           color: Color(0xFFD4AF37),
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14.sp,
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               );
//                             }),

//                             SizedBox(height: 80.h),
//                           ],
//                         ),
//                       ),
//                     ),

//                     /// 🔹 Fixed Bottom Button
//                     Padding(
//                       padding: EdgeInsets.all(24.w),
//                       child: Obx(() {
//                         return SizedBox(
//                           width: double.infinity,
//                           height: 56.h,
//                           child: ElevatedButton(
//                             onPressed: controller.isLoading.value
//                                 ? null
//                                 : controller.verifyOtp,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xFFD4AF37),
//                               disabledBackgroundColor: Colors.grey[600],
//                               elevation: 0,
//                               side: BorderSide.none,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               padding: EdgeInsets.symmetric(
//                                 vertical: 0,
//                                 horizontal: 16.w,
//                               ),
//                               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                               visualDensity: VisualDensity.compact,
//                             ),
//                             child: controller.isLoading.value
//                                 ? SizedBox(
//                                     width: 20.w,
//                                     height: 20.h,
//                                     child: CircularProgressIndicator(
//                                       color: Colors.white,
//                                       strokeWidth: 2.w,
//                                     ),
//                                   )
//                                 : Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text(
//                                         'verify'.tr,
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 16.sp,
//                                           fontWeight: FontWeight.bold,
//                                           height: 1.2,
//                                         ),
//                                       ),
//                                       SizedBox(width: 4.w),
//                                       Icon(
//                                         Icons.arrow_forward,
//                                         color: Colors.black,
//                                         size: 18.sp,
//                                       ),
//                                     ],
//                                   ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter_extension/core/common/widgets/app_bar.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/core/utils/constants/icon_path.dart';
import 'package:flutter_extension/features/auth/controller/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatelessWidget {
  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    // ── Pinput themes ──
    final defaultPinTheme = PinTheme(
      width: 52.w,
      height: 52.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2E2E2E), width: 1),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFC9952A), width: 1.5),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFC9952A).withOpacity(0.5), width: 1),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── App Bar ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: CustomAppBar(
                title: 'otpVerification'.tr,
                centerTitle: true,
                icon: Icons.arrow_back_rounded,
              ),
            ),

            // ── Body ──
            Expanded(
              child: Column(
                children: [
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 40.h),

                          // OTP icon
                          Container(
                            width: 120.w,
                            height: 120.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF2E2E2E),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                IconPath.otp,
                                width: 80.w,
                                height: 80.h,
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Title
                          Text(
                            'otpVerification'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 22.sp,
                              letterSpacing: 0.3,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // Subtitle
                          Text(
                            'enterTheOTPSentToYourEmailToVerifyYourIdentityOnceVerifiedYouCanProceedToSignIn'
                                .tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFB0A090),
                              fontSize: 13.sp,
                              height: 1.6,
                            ),
                          ),

                          SizedBox(height: 36.h),

                          // OTP Pinput
                          Pinput(
                            length: 6,
                            controller: controller.otpTEController,
                            focusNode: controller.focusNode,
                            onChanged: controller.updateOtpValue,
                            onCompleted: (_) => controller.verifyOtp,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: submittedPinTheme,
                            separatorBuilder: (_) => SizedBox(width: 10.w),
                          ),

                          SizedBox(height: 28.h),

                          // Resend row
                          Obx(() {
                            final minutes =
                                controller.secondsRemaining.value ~/ 60;
                            final seconds =
                                controller.secondsRemaining.value % 60;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.isClickable.value
                                      ? "haventReceivedTheCode".tr + "  "
                                      : "resendIn".tr +
                                          "  ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}  ",
                                  style: TextStyle(
                                    color: const Color(0xFF6E6E6E),
                                    fontSize: 13.sp,
                                  ),
                                ),
                                if (controller.isClickable.value)
                                  GestureDetector(
                                    onTap: controller.resendOtp,
                                    child: Text(
                                      'resend'.tr,
                                      style: TextStyle(
                                        color: const Color(0xFFC9952A),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // ── Fixed Bottom Button ──
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Obx(() {
                      return SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC9952A),
                            disabledBackgroundColor:
                                const Color(0xFFC9952A).withOpacity(0.45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                'verify'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}