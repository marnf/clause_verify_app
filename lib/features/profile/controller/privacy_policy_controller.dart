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
      title: 'privacyTitle1'.tr,
      content: [
        'privacyContent1_1'.tr,
        'privacyContent1_2'.tr,
        'privacyContent1_3'.tr,
        'privacyContent1_4'.tr,
        'privacyContent1_5'.tr,
      ],
    ),
    PrivacySection(
      title: 'privacyTitle2'.tr,
      content: [
        'privacyContent2_1'.tr,
      ],
    ),
    PrivacySection(
      title: 'privacyTitle3'.tr,
      content: [
        'privacyContent3_1'.tr,
      ],
    ),
    PrivacySection(
      title: 'privacyTitle4'.tr,
      content: [
        'privacyContent4_1'.tr,
        'privacyContent4_2'.tr,
      ],
    ),
    PrivacySection(
      title: 'privacyTitle5'.tr,
      content: [
        'privacyContent5_1'.tr,
      ],
    ),
    PrivacySection(
      title: 'privacyTitle6'.tr,
      content: [
        'privacyContent6_1'.tr,
      ],
    ),
  ];
}