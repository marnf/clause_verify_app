import 'package:get/get.dart';

class FaqItem {
  final String question;
  final String answer;
  RxBool isExpanded;

  FaqItem({
    required this.question,
    required this.answer,
    bool expanded = false,
  }) : isExpanded = expanded.obs;
}

class FaqSection {
  final String title;
  final List<FaqItem> items;

  FaqSection({required this.title, required this.items});
}

class HelpFaqController extends GetxController {
  List<FaqSection> get sections => [
    FaqSection(
      title: 'Getting Started'.tr,
      items: [
        FaqItem(
          question: 'What is clauseverify?'.tr,
          answer: 'clauseverify is a mobile application that uses AI-powered technology to verify the authenticity and production date of watches, helping collectors and buyers make informed decisions.'.tr,
        ),
        FaqItem(
          question: 'How do I create an account?'.tr,
          answer: 'Tap "Sign Up" on the login screen. Enter your email, create a password, and verify your email address via the link sent to your inbox.'.tr,
        ),
        FaqItem(
          question: 'Is clauseverify free to use?'.tr,
          answer: 'You can download and register for free. Certain advanced features, like detailed verification reports or unlimited scans, may require a Premium subscription. Check the "Premium" section in the app for details.'.tr,
        ),
      ],
    ),
    FaqSection(
      title: 'Using the App & AI Verification'.tr,
      items: [
        FaqItem(
          question: 'How does the verification process work?'.tr,
          answer: '• Use the in-app camera to capture clear photos of the watch (dial, case back, movement if visible).\n• Our AI analyzes specific markers, engravings, and craftsmanship details.\n• You receive an instant authenticity probability score and a detailed report with supporting evidence.'.tr,
        ),
        FaqItem(
          question: 'What parts of the watch should I photograph?'.tr,
          answer: 'For best results, provide clear, well-lit images of:\n• The watch face (dial)\n• The case back\n• The Bracelet & Clasp'.tr,
        ),
        FaqItem(
          question: 'How accurate is the AI verification?'.tr,
          answer: 'Our AI is trained on extensive datasets and provides a high-confidence analysis. Important: The result is an assistive tool and probability assessment, not a 100% guaranteed certification. For high-value transactions, we recommend consulting a certified professional.'.tr,
        ),
        FaqItem(
          question: 'The AI can\'t identify my watch. What should I do?'.tr,
          answer: 'Ensure photos are clear and not blurry. Try different angles and lighting. If the problem persists, the model might not yet be in our database.'.tr,
        ),
      ],
    ),
    FaqSection(
      title: 'Account & Subscription'.tr,
      items: [
        FaqItem(
          question: 'How do I reset my password?'.tr,
          answer: 'On the login screen, tap "Forgot Password." Enter your email to receive a reset link.'.tr,
        ),
        FaqItem(
          question: 'How do I upgrade to Premium?'.tr,
          answer: 'Go to your Profile → "Upgrade to Premium" or "Subscription." Select your plan and follow the payment instructions.'.tr,
        ),
        FaqItem(
          question: 'How do I cancel my subscription?'.tr,
          answer: 'Subscriptions are managed through your device\'s store (Google Play Store or Apple App Store). Go to your store account settings → Subscriptions to cancel.'.tr,
        ),
        FaqItem(
          question: 'What happens to my data if I delete my account?'.tr,
          answer: 'All your personal data and scan history will be permanently deleted from our servers. This action cannot be undone.'.tr,
        ),
      ],
    ),
    FaqSection(
      title: 'Technical Support'.tr,
      items: [
        FaqItem(
          question: 'The app crashes or freezes. What can I do?'.tr,
          answer: '• Ensure you have the latest version of the app installed.\n• Restart the app and your phone.\n• Check your internet connection.'.tr,
        ),
        FaqItem(
          question: 'I\'m having trouble with the camera scan.'.tr,
          answer: '• Grant the necessary camera permissions in your phone settings.\n• Clean your phone\'s camera lens.\n• Avoid scanning in dark or reflective environments.'.tr,
        ),
      ],
    ),
    FaqSection(
      title: 'Privacy & Security'.tr,
      items: [
        FaqItem(
          question: 'Is my data and photo library secure?'.tr,
          answer: 'Yes. We take privacy seriously. All images and data are encrypted and processed securely. We do not share your personal data with third parties without your consent. For details, please read our Privacy Policy.'.tr,
        ),
        FaqItem(
          question: 'Does clauseverify sell my data?'.tr,
          answer: 'No. We do not sell, trade, or rent your personal identification information. Data is used solely to provide and improve the verification service.'.tr,
        ),
      ],
    ),
  ];

  void toggleItem(FaqItem item) {
    item.isExpanded.value = !item.isExpanded.value;
  }
}