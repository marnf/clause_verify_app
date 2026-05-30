import 'package:flutter_extension/core/common/widgets/app_bar.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/features/auth/controller/terms_and_conditions_controller.dart';
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
                title: 'Terms & Conditions',
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
                            'Terms of Use & AI Disclaimer',
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
                      'Please read carefully before proceeding.',
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
                            'Important Notice',
                            style: TextStyle(
                              color: const Color(0xFFC9952A),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'ClauseVerify analyses contract language using artificial intelligence. Results do not constitute legal counsel and should not be relied upon as a substitute for advice from a qualified lawyer. Qlox Inc. accepts no liability for decisions made based on this analysis.',
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
                    _buildSectionTitle('1. Nature of the Service'),
                    SizedBox(height: 10.h),
                    _buildBodyText(
                      'ClauseVerify is an AI-powered contract analysis tool operated by Qlox Inc. (Ontario, Canada). The application uses artificial intelligence to read, parse, and annotate contract documents. The output produced by ClauseVerify is generated automatically and has not been reviewed by a lawyer or legal professional.',
                    ),
                    SizedBox(height: 20.h),

                    // ── 2. Not Legal Advice ──
                    _buildSectionTitle('2. Not Legal Advice'),
                    SizedBox(height: 10.h),
                    _buildBodyText(
                      'The analysis, reports, scores, flags, and recommendations provided by ClauseVerify are for informational purposes only. They do not constitute legal advice, legal opinion, or legal counsel of any kind. ClauseVerify is not a law firm and does not provide legal services.',
                    ),
                    SizedBox(height: 20.h),

                    // ── 3. Limitations of AI Analysis ──
                    _buildSectionTitle('3. Limitations of AI Analysis'),
                    SizedBox(height: 10.h),
                    _buildBodyText(
                      'The identification of clauses as abusive, unusual, risky, or non-compliant is based on automated AI analysis and may be:',
                    ),
                    SizedBox(height: 8.h),
                    _buildBulletPoint('Incomplete — not all clauses may be identified or analysed'),
                    _buildBulletPoint('Inaccurate — AI interpretation may differ from legal interpretation'),
                    _buildBulletPoint('Not applicable — results may not reflect your specific jurisdiction, province, or local laws'),
                    _buildBulletPoint('Out of date — laws and regulations change and the AI may not reflect the most current legal standards'),
                    SizedBox(height: 20.h),

                    // ── 4. No Warranties ──
                    _buildSectionTitle('4. No Warranties'),
                    SizedBox(height: 10.h),
                    _buildBodyText(
                      'Qlox Inc. makes no representations or warranties, express or implied, as to the accuracy, completeness, reliability, or fitness for purpose of any analysis produced by ClauseVerify.',
                    ),
                    SizedBox(height: 20.h),

                    // ── 5. Limitation of Liability ──
                    _buildSectionTitle('5. Limitation of Liability'),
                    SizedBox(height: 10.h),
                    _buildBodyText(
                      'Qlox Inc. shall not be liable for any loss, damage, financial consequence, or legal outcome arising directly or indirectly from reliance on any analysis, report, score, or recommendation produced by ClauseVerify.',
                    ),
                    SizedBox(height: 20.h),

                    // ── 6. Consult a Lawyer ──
                    _buildSectionTitle('6. Consult a Lawyer'),
                    SizedBox(height: 10.h),
                    _buildBodyText(
                      'If you have questions about a contract, its terms, or your legal rights and obligations, you should consult a licensed legal professional in your jurisdiction before signing or acting on any contract.',
                    ),
                    SizedBox(height: 20.h),

                    // ── Data & Privacy ──
                    _buildSectionTitle('7. Data & Privacy'),
                    SizedBox(height: 10.h),
                    _buildBulletPoint('Your uploaded documents are automatically deleted from our servers within 48 hours of the scan.'),
                    _buildBulletPoint('We do not share your data with third parties without consent.'),
                    _buildBulletPoint('You retain full ownership of your uploaded content.'),
                    _buildBulletPoint('Documents are processed by AI only and are never read by any human employee.'),
                    SizedBox(height: 20.h),

                    // ── 8. Acceptable Use ──
                    _buildSectionTitle('8. Acceptable Use'),
                    SizedBox(height: 10.h),
                    _buildBodyText('You agree not to:'),
                    SizedBox(height: 8.h),
                    _buildBulletPoint('Use the App for any unlawful purpose'),
                    _buildBulletPoint('Upload documents containing content that violates the rights of any third party'),
                    _buildBulletPoint('Attempt to reverse-engineer, decompile, or extract the source code of the App'),
                    _buildBulletPoint('Use automated tools to access the App in a manner that exceeds normal usage'),
                    _buildBulletPoint('Impersonate any person or entity or misrepresent your affiliation'),
                    SizedBox(height: 20.h),

                    // ── 9. Governing Law ──
                    _buildSectionTitle('9. Governing Law'),
                    SizedBox(height: 10.h),
                    _buildBodyText(
                      'These Terms shall be governed by and construed in accordance with the laws of the Province of Ontario and the federal laws of Canada. Any dispute arising under these Terms shall be subject to the exclusive jurisdiction of the courts of Ontario.',
                    ),
                    SizedBox(height: 20.h),

                    // ── 10. Acceptance ──
                    _buildSectionTitle('10. Acceptance'),
                    SizedBox(height: 10.h),
                    _buildBodyText(
                      'By checking the box below and continuing, you acknowledge that you have read, understood, and agree to these Terms. You understand that the AI analysis is for informational purposes and that you are solely responsible for any decisions made based on the results.',
                    ),
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
                                'I have read and agree to the Terms of Use & AI Disclaimer.',
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
                          ),
                          child: Text(
                            'Accept & Continue',
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