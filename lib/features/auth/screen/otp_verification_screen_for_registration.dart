

import 'package:clause_verify/core/common/widgets/app_bar.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/core/utils/constants/icon_path.dart';
import 'package:clause_verify/features/auth/controller/otp_verification_controller_for_registraion.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreenForRegistration extends StatelessWidget {
  final OtpVerificationControllerForRegistraion controller = Get.put(
    OtpVerificationControllerForRegistraion(),
  );

  @override
  Widget build(BuildContext context) {
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
        border: Border.all(
            color: const Color(0xFFC9952A).withOpacity(0.5), width: 1),
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
              padding:
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
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
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Center(
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