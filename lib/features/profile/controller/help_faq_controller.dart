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
      title: 'faqSection1Title'.tr,
      items: [
        FaqItem(
          question: 'faqQ1_1'.tr,
          answer: 'faqA1_1'.tr,
        ),
        FaqItem(
          question: 'faqQ1_2'.tr,
          answer: 'faqA1_2'.tr,
        ),
        FaqItem(
          question: 'faqQ1_3'.tr,
          answer: 'faqA1_3'.tr,
        ),
      ],
    ),
    FaqSection(
      title: 'faqSection2Title'.tr,
      items: [
        FaqItem(
          question: 'faqQ2_1'.tr,
          answer: 'faqA2_1'.tr,
        ),
        FaqItem(
          question: 'faqQ2_2'.tr,
          answer: 'faqA2_2'.tr,
        ),
        FaqItem(
          question: 'faqQ2_3'.tr,
          answer: 'faqA2_3'.tr,
        ),
        FaqItem(
          question: 'faqQ2_4'.tr,
          answer: 'faqA2_4'.tr,
        ),
      ],
    ),
    FaqSection(
      title: 'faqSection3Title'.tr,
      items: [
        FaqItem(
          question: 'faqQ3_1'.tr,
          answer: 'faqA3_1'.tr,
        ),
        FaqItem(
          question: 'faqQ3_2'.tr,
          answer: 'faqA3_2'.tr,
        ),
        FaqItem(
          question: 'faqQ3_3'.tr,
          answer: 'faqA3_3'.tr,
        ),
        FaqItem(
          question: 'faqQ3_4'.tr,
          answer: 'faqA3_4'.tr,
        ),
      ],
    ),
    FaqSection(
      title: 'faqSection4Title'.tr,
      items: [
        FaqItem(
          question: 'faqQ4_1'.tr,
          answer: 'faqA4_1'.tr,
        ),
        FaqItem(
          question: 'faqQ4_2'.tr,
          answer: 'faqA4_2'.tr,
        ),
      ],
    ),
    FaqSection(
      title: 'faqSection5Title'.tr,
      items: [
        FaqItem(
          question: 'faqQ5_1'.tr,
          answer: 'faqA5_1'.tr,
        ),
        FaqItem(
          question: 'faqQ5_2'.tr,
          answer: 'faqA5_2'.tr,
        ),
      ],
    ),
  ];

  void toggleItem(FaqItem item) {
    item.isExpanded.value = !item.isExpanded.value;
  }
}