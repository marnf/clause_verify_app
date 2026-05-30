import 'package:get/get.dart';

class TermsSection {
  final String title;
  final String content;

  TermsSection({required this.title, required this.content});
}

class TermsOfUseController extends GetxController {
  List<TermsSection> get sections => [
    TermsSection(
      title: '1. Service Description'.tr,
      content: 'ChronoVerify provides an AI-based watch pre-expertise service allowing users to upload images of watches in order to receive an AI Pre-Expertise Report.\n\nThe Service is designed to provide informational insights only, based on automated artificial intelligence analysis.'.tr,
    ),
    TermsSection(
      title: '2. Acceptance of Disclaimer (REFERENCE)'.tr,
      content: 'Use of the Service is subject to acceptance of the AI Disclaimer, which explains the nature, scope, and limitations of AI-based analysis.\n\nThe Disclaimer is presented during account registration and must be accepted.\n\nFailure to accept the Disclaimer prevents access to the analysis service.'.tr,
    ),
    TermsSection(
      title: '3. User Eligibility'.tr,
      content: '• Users must be 18 years or older\n• By using ChronoVerify, you confirm you have legal capacity and authority to use the Service'.tr,
    ),
    TermsSection(
      title: '4. User Responsibilities'.tr,
      content: 'You agree to:\n• Upload only images you own or are authorized to use\n• Use the Service lawfully and in good faith\n• Respect usage limits and plan restrictions\n• Not attempt to abuse, overload, or bypass the system\n• Not use the Service for fraudulent or misleading purposes\n\nViolations may result in account suspension or termination without refund.'.tr,
    ),
    TermsSection(
      title: '5. Usage Limits & Fair Use Policy'.tr,
      content: 'ChronoVerify applies a fair-use policy to ensure platform stability and cost control.\n\n• Usage limits vary by plan (Free / Premium)\n• Excessive or abnormal usage may be restricted\n\nWe reserve the right to:\n• Throttle access\n• Reduce quotas\n• Suspend accounts showing abusive patterns'.tr,
    ),
    TermsSection(
      title: '6. Payments & Subscriptions'.tr,
      content: '• Payments are processed via secure third-party providers\n• Subscription fees are non-refundable\n• Plan limits, pricing, and features may evolve over time\n• Abuse or misuse voids refund eligibility'.tr,
    ),
    TermsSection(
      title: '7. AI Pre-Expertise Report Generation'.tr,
      content: '• Reports are not guaranteed to be stored permanently\n• Users are responsible for saving their reports\n• ChronoVerify is not liable for lost or deleted reports'.tr,
    ),
    TermsSection(
      title: '8. Intellectual Property'.tr,
      content: 'All intellectual property related to the Application, including:\n• Branding\n• Interface\n• AI workflows\n• Reports format\n\nremains the exclusive property of ChronoVerify. Unauthorized copying, resale, or redistribution is prohibited.'.tr,
    ),
    TermsSection(
      title: '9. Limitation of Liability'.tr,
      content: 'To the maximum extent permitted by law, ChronoVerify shall not be liable for:\n• Decisions made based on AI results\n• Financial losses\n• Disputes related to watch authenticity\n• Indirect or consequential damages\n\nUse of the Service is at your own risk.'.tr,
    ),
    TermsSection(
      title: '10. Account Suspension & Termination'.tr,
      content: 'ChronoVerify reserves the right to suspend or terminate access:\n• For violations of these Terms\n• For abusive or abnormal usage\n• To protect platform integrity\n\nTermination does not entitle the user to refunds.'.tr,
    ),
    TermsSection(
      title: '11. Governing Law'.tr,
      content: 'These Terms are governed by the laws of Canada.'.tr,
    ),
  ];
}