import 'package:get/get.dart';

class TermsSection {
  final String title;
  final String content;

  TermsSection({required this.title, required this.content});
}

class TermsOfUseController extends GetxController {
  List<TermsSection> get sections => [
    TermsSection(
      title: 'termsTitle1'.tr,
      content: 'termsContent1'.tr,
    ),
    TermsSection(
      title: 'termsTitle2'.tr,
      content: 'termsContent2'.tr,
    ),
    TermsSection(
      title: 'termsTitle3'.tr,
      content: 'termsContent3'.tr,
    ),
    TermsSection(
      title: 'termsTitle4'.tr,
      content: 'termsContent4'.tr,
    ),
    TermsSection(
      title: 'termsTitle5'.tr,
      content: 'termsContent5'.tr,
    ),
    TermsSection(
      title: 'termsTitle6'.tr,
      content: 'termsContent6'.tr,
    ),
    TermsSection(
      title: 'termsTitle7'.tr,
      content: 'termsContent7'.tr,
    ),
    TermsSection(
      title: 'termsTitle8'.tr,
      content: 'termsContent8'.tr,
    ),
    TermsSection(
      title: 'termsTitle9'.tr,
      content: 'termsContent9'.tr,
    ),
    TermsSection(
      title: 'termsTitle10'.tr,
      content: 'termsContent10'.tr,
    ),
    TermsSection(
      title: 'termsTitle11'.tr,
      content: 'termsContent11'.tr,
    ),
  ];
}