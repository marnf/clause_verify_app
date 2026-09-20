import 'package:clause_verify/core/common/widgets/app_bar.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/auth/controller/terms_and_conditions_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAndCondition extends StatelessWidget {
  TermsAndCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsConditionsController());

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
                title: 'termsConditions'.tr,
                centerTitle: true,
                icon: Icons.arrow_back_rounded,
              ),
            ),

            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),

                    // ── Header ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF2E2E2E), width: 1),
                          ),
                          child: const Icon(
                            Icons.gavel_rounded,
                            color: Color(0xFFC9952A),
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'termsOfUseAiDisclaimer'.tr,
                            style: TextStyle(
                              color: const Color(0xFFC9952A),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    Text(
                      'pleaseReadCarefullyBeforeProceeding'.tr,
                      style: TextStyle(
                        color: const Color(0xFFB0A090),
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // ── Important Notice Box ──
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFFC9952A), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'importantNotice'.tr,
                            style: TextStyle(
                              color: const Color(0xFFC9952A),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'disclaimerNoticeBody'.tr,
                            style: TextStyle(
                              color: const Color(0xFFB0A090),
                              fontSize: 13.sp,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ── 1. Nature of the Service ──
                    _buildSectionTitle('disclaimerTitle1'.tr),
                    SizedBox(height: 10.h),
                    _buildBodyText('disclaimerBody1'.tr),
                    SizedBox(height: 20.h),

                    // ── 2. Not Legal Advice ──
                    _buildSectionTitle('disclaimerTitle2'.tr),
                    SizedBox(height: 10.h),
                    _buildBodyText('disclaimerBody2'.tr),
                    SizedBox(height: 20.h),

                    // ── 3. Limitations of AI Analysis ──
                    _buildSectionTitle('disclaimerTitle3'.tr),
                    SizedBox(height: 10.h),
                    _buildBodyText('disclaimerBody3'.tr),
                    SizedBox(height: 8.h),
                    _buildBulletPoint('disclaimerBullet3_1'.tr),
                    _buildBulletPoint('disclaimerBullet3_2'.tr),
                    _buildBulletPoint('disclaimerBullet3_3'.tr),
                    _buildBulletPoint('disclaimerBullet3_4'.tr),
                    SizedBox(height: 20.h),

                    // ── 4. No Warranties ──
                    _buildSectionTitle('disclaimerTitle4'.tr),
                    SizedBox(height: 10.h),
                    _buildBodyText('disclaimerBody4'.tr),
                    SizedBox(height: 20.h),

                    // ── 5. Limitation of Liability ──
                    _buildSectionTitle('disclaimerTitle5'.tr),
                    SizedBox(height: 10.h),
                    _buildBodyText('disclaimerBody5'.tr),
                    SizedBox(height: 20.h),

                    // ── 6. Consult a Lawyer ──
                    _buildSectionTitle('disclaimerTitle6'.tr),
                    SizedBox(height: 10.h),
                    _buildBodyText('disclaimerBody6'.tr),
                    SizedBox(height: 20.h),

                    // ── 7. Data & Privacy ──
                    _buildSectionTitle('disclaimerTitle7'.tr),
                    SizedBox(height: 10.h),
                    _buildBulletPoint('disclaimerBullet7_1'.tr),
                    _buildBulletPoint('disclaimerBullet7_2'.tr),
                    _buildBulletPoint('disclaimerBullet7_3'.tr),
                    _buildBulletPoint('disclaimerBullet7_4'.tr),
                    SizedBox(height: 20.h),

                    // ── 8. Acceptable Use ──
                    _buildSectionTitle('disclaimerTitle8'.tr),
                    SizedBox(height: 10.h),
                    _buildBodyText('disclaimerBody8'.tr),
                    SizedBox(height: 8.h),
                    _buildBulletPoint('disclaimerBullet8_1'.tr),
                    _buildBulletPoint('disclaimerBullet8_2'.tr),
                    _buildBulletPoint('disclaimerBullet8_3'.tr),
                    _buildBulletPoint('disclaimerBullet8_4'.tr),
                    _buildBulletPoint('disclaimerBullet8_5'.tr),
                    SizedBox(height: 20.h),

                    // ── 9. Governing Law ──
                    _buildSectionTitle('disclaimerTitle9'.tr),
                    SizedBox(height: 10.h),
                    _buildBodyText('disclaimerBody9'.tr),
                    SizedBox(height: 20.h),

                    // ── 10. Acceptance ──
                    _buildSectionTitle('disclaimerTitle10'.tr),
                    SizedBox(height: 10.h),
                    _buildBodyText('disclaimerBody10'.tr),
                    SizedBox(height: 28.h),

                    // ── Divider ──
                    const Divider(color: Color(0xFF2A2A2A), thickness: 1),
                    SizedBox(height: 24.h),

                    // ── Checkbox ──
                    Obx(
                      () => InkWell(
                        onTap: controller.toggleCheckbox,
                        borderRadius: BorderRadius.circular(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              margin: const EdgeInsets.only(top: 1),
                              decoration: BoxDecoration(
                                color: controller.isAgreed.value
                                    ? const Color(0xFFC9952A)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: controller.isAgreed.value
                                      ? const Color(0xFFC9952A)
                                      : const Color(0xFF6E6E6E),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: controller.isAgreed.value
                                  ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 15,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                'iHaveReadAndAgreeToTheTermsOfUseAiDisclaimer'.tr,
                                style: TextStyle(
                                  color: const Color(0xFFB0A090),
                                  fontSize: 14.sp,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ── Accept Button ──
                   Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: ElevatedButton(
                          onPressed: controller.isAgreed.value
                              ? controller.onAcceptPressed
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC9952A),
                            disabledBackgroundColor:
                                const Color(0xFFC9952A).withOpacity(0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0), 
                          ),
                          child: FittedBox( 
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'acceptContinue'.tr,
                              style: TextStyle(
                                color: controller.isAgreed.value
                                    ? Colors.white
                                    : Colors.white38,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // ── Footer ──
                    Center(
                      child: Text(
                        'Qlox Inc. • Ontario, Canada • Qloxinc@gmail.com',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF6E6E6E),
                          fontSize: 11.sp,
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFB0A090),
        fontSize: 13,
        height: 1.6,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xFFC9952A),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFB0A090),
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}