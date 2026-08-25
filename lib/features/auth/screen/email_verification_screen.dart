import 'package:clause_verify/core/common/widgets/app_bar.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/auth/controller/email_verification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerificationScreen extends StatelessWidget {
  final EmailVerificationController controller = Get.put(
    EmailVerificationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── App Bar ──
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 16.h,
              ),
              child: CustomAppBar(
                title: 'emailVerification'.tr,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 32.h),

                          // Title
                          Text(
                            'enterYourEmail'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // Subtitle
                          Text(
                            'pleaseEnterTheEmailAddressAssociatedWithYourAccountWellSendYouALinkToResetYourPasswordAndRegainAccess'
                                .tr,
                            style: TextStyle(
                              color: const Color(0xFFB0A090),
                              fontSize: 14.sp,
                              height: 1.6,
                            ),
                          ),
                          SizedBox(height: 32.h),

                          // Email label
                          Text(
                            'emailAddress'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // Email TextField
                          Obx(() {
                            final hasError =
                                controller.emailError.value.isNotEmpty &&
                                    controller.hasStartedTypingEmail.value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: controller.emailTEController,
                                  focusNode: controller.focusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'johndoeExampleCom'.tr,
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF6E6E6E),
                                    ),
                                    filled: true,
                                    fillColor: hasError
                                        ? const Color(0xFF2A1010)
                                        : const Color(0xFF1A1A1A),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: hasError
                                            ? Colors.redAccent
                                            : const Color(0xFF2E2E2E),
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
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 16.h,
                                    ),
                                  ),
                                ),

                                // Error message
                                if (hasError)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 6.h, left: 4.w),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.redAccent,
                                          size: 14.sp,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          controller.emailError.value,
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
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
                    child: Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: ElevatedButton(
                          onPressed: controller.isFormValid.value &&
                                  !controller.isLoading.value
                              ? controller.verifyEmail
                              : null,
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
                                'continue'.tr,
                                style: TextStyle(
                                  color: controller.isFormValid.value
                                      ? Colors.white
                                      : Colors.white70,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                        ),
                      ),
                    ),
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