// import 'package:get/get.dart';

// class PrivacySection {
//   final String title;
//   final List<String> content;

//   PrivacySection({required this.title, required this.content});
// }

// class PrivacyPolicyController extends GetxController {
//   final RxDouble scrollOffset = 0.0.obs;

//   final List<PrivacySection> sections = [
//     PrivacySection(
//       title: '1. Information We Collect',
//       content: [
//         'We may collect the following information:',
//         'a) User Information\n• Email address (for account creation and access)\n• Subscription status (Free or Premium)',
//         'b) Uploaded Content\n• Images of watches uploaded by users for AI analysis\n• Optional metadata related to the watch (model, brand, accessories)',
//         'c) Usage Data\n• Number of analyses performed\n• Dates and times of usage\n• Application interactions (for performance and abuse prevention)',
//         'd) Payment Information\n• Payments are processed securely via third-party providers (e.g., Stripe)\n• clauseverify does not store credit card details',
//       ],
//     ),
//     PrivacySection(
//       title: '2. How We Use Your Information',
//       content: [
//         'Your information is used strictly to:\n• Provide AI-based pre-expertise analysis of watches\n• Generate AI Pre-Expertise Reports\n• Manage user accounts and subscriptions\n• Monitor usage limits and prevent abuse\n• Improve application performance and reliability\n• Ensure platform security and cost control',
//       ],
//     ),
//     PrivacySection(
//       title: '3. Data Storage & Retention',
//       content: [
//         '• Uploaded images may be processed temporarily for analysis purposes\n• AI Pre-Expertise Reports may be generated once and not permanently stored\n• Minimal metadata (report ID, scores, date) may be retained for verification and security purposes\n• Data is retained only as long as necessary to provide the service',
//       ],
//     ),
//     PrivacySection(
//       title: '4. Data Sharing',
//       content: [
//         'We do not sell or rent your personal data.',
//         'Data may be shared only with:\n• Trusted third-party service providers (AI APIs, hosting, payment processing)\n• Legal authorities if required by law\n\nAll third parties are required to comply with strict data protection standards.',
//       ],
//     ),
//     PrivacySection(
//       title: '5. Security Measures',
//       content: [
//         'We implement appropriate technical and organizational measures to protect your data, including:\n• Secure API communication\n• Encrypted data transmission\n• Access controls and monitoring\n• Abuse detection and usage limits\n\nHowever, no system can be 100% secure.',
//       ],
//     ),
//     PrivacySection(
//       title: '6. User Responsibilities',
//       content: [
//         'By using clauseverify, you agree:\n• To upload only images you have the right to use\n• Not to misuse the platform or attempt to bypass usage limits\n• To accept that AI-based results are informational only',
//       ],
//     ),
//   ];
// }




import 'package:get/get.dart';

class PrivacySection {
  final String title;
  final List<String> content;

  PrivacySection({required this.title, required this.content});
}

class PrivacyPolicyController extends GetxController {
  final RxDouble scrollOffset = 0.0.obs;

 List<PrivacySection> get sections => [
    PrivacySection(
      title: '1. Information We Collect'.tr,
      content: [
        'We may collect the following information:'.tr,
        'a) User Information\n• Email address (for account creation and access)\n• Subscription status (Free or Premium)'.tr,
        'b) Uploaded Content\n• Images of watches uploaded by users for AI analysis\n• Optional metadata related to the watch (model, brand, accessories)'.tr,
        'c) Usage Data\n• Number of analyses performed\n• Dates and times of usage\n• Application interactions (for performance and abuse prevention)'.tr,
        'd) Payment Information\n• Payments are processed securely via third-party providers (e.g., Stripe)\n• clauseverify does not store credit card details'.tr,
      ],
    ),
    PrivacySection(
      title: '2. How We Use Your Information'.tr,
      content: [
        'Your information is used strictly to:\n• Provide AI-based pre-expertise analysis of watches\n• Generate AI Pre-Expertise Reports\n• Manage user accounts and subscriptions\n• Monitor usage limits and prevent abuse\n• Improve application performance and reliability\n• Ensure platform security and cost control'.tr,
      ],
    ),
    PrivacySection(
      title: '3. Data Storage & Retention'.tr,
      content: [
        '• Uploaded images may be processed temporarily for analysis purposes\n• AI Pre-Expertise Reports may be generated once and not permanently stored\n• Minimal metadata (report ID, scores, date) may be retained for verification and security purposes\n• Data is retained only as long as necessary to provide the service'.tr,
      ],
    ),
    PrivacySection(
      title: '4. Data Sharing'.tr,
      content: [
        'We do not sell or rent your personal data.'.tr,
        'Data may be shared only with:\n• Trusted third-party service providers (AI APIs, hosting, payment processing)\n• Legal authorities if required by law\n\nAll third parties are required to comply with strict data protection standards.'.tr,
      ],
    ),
    PrivacySection(
      title: '5. Security Measures'.tr,
      content: [
        'We implement appropriate technical and organizational measures to protect your data, including:\n• Secure API communication\n• Encrypted data transmission\n• Access controls and monitoring\n• Abuse detection and usage limits\n\nHowever, no system can be 100% secure.'.tr,
      ],
    ),
    PrivacySection(
      title: '6. User Responsibilities'.tr,
      content: [
        'By using clauseverify, you agree:\n• To upload only images you have the right to use\n• Not to misuse the platform or attempt to bypass usage limits\n• To accept that AI-based results are informational only'.tr,
      ],
    ),
  ];
}