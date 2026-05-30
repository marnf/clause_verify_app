// import 'package:flutter_extension/core/common/widgets/language_modal.dart';
// import 'package:flutter_extension/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class OnboardingController extends GetxController {
//   final currentPage = 0.obs;
//   final PageController pageController = PageController();
//   RxBool hasShownLanguageModal = false.obs;
//   RxBool isLanguageModalShowing = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     // Controller initialize howar shathe shathe call hobe
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _checkAndShowLanguageModal();
//     });
//   }

//    Future<void> _checkAndShowLanguageModal() async {
//   try {
//     // যদি ইতিমধ্যে showing থাকে অথবা আগে দেখানো হয়ে থাকে, return
//     if (isLanguageModalShowing.value || hasShownLanguageModal.value) return;

//     final prefs = await SharedPreferences.getInstance();
//     bool languageSelected = prefs.getBool('languageSelected') ?? false;

//     print('Language selected: $languageSelected');

//     // যদি language selected না হয়ে থাকে
//     if (!languageSelected) {
//       // Flag গুলো set করুন
//       hasShownLanguageModal.value = true;
//       isLanguageModalShowing.value = true;

//       print('Showing language modal...');

//       // Wait for screen to fully render
//       await Future.delayed(const Duration(milliseconds: 300));

//       // Show modal
//       await Get.dialog(
//         const LanguageModal(isOnboarding: true),
//         barrierDismissible: false,
//       );

//       // Modal বন্ধ হওয়ার পর save করুন
//       await prefs.setBool('languageSelected', true);
//       isLanguageModalShowing.value = false;
      
//       print('Language selection saved to SharedPreferences');
//     }
//   } catch (e) {
//     print('Error showing language modal: $e');
//     isLanguageModalShowing.value = false;
//   }
// }

//   void nextPage() {
//     if (currentPage.value < 3) {
//       currentPage.value++;
//       pageController.animateToPage(
//         currentPage.value,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       // Navigate to login screen
//       Get.offNamed(AppRoute.loginScreen);
//     }
//   }

//   // Method to manually reset language selection (for testing)
//   Future<void> resetLanguageSelection() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('languageSelected', false);
//     hasShownLanguageModal.value = false;
//   }







//   @override
//   void onClose() {
//     pageController.dispose();
//     super.onClose();
//   }
// }


import 'package:flutter_extension/core/common/widgets/language_modal.dart';
import 'package:flutter_extension/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  final currentPage = 0.obs;
  final PageController pageController = PageController();
  RxBool hasShownLanguageModal = false.obs;
  RxBool isLanguageModalShowing = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Controller initialize howar shathe shathe call hobe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowLanguageModal();
    });
  }

  Future<void> _checkAndShowLanguageModal() async {
    try {
      // যদি ইতিমধ্যে showing থাকে অথবা আগে দেখানো হয়ে থাকে, return
      if (isLanguageModalShowing.value || hasShownLanguageModal.value) return;

      final prefs = await SharedPreferences.getInstance();
      bool languageSelected = prefs.getBool('languageSelected') ?? false;

      print('Language selected: $languageSelected');

      // যদি language selected না হয়ে থাকে
      if (!languageSelected) {
        // Flag গুলো set করুন
        hasShownLanguageModal.value = true;
        isLanguageModalShowing.value = true;

        print('Showing language modal...');

        // Wait for screen to fully render
        await Future.delayed(const Duration(milliseconds: 300));

        // Show modal
        await Get.dialog(
          const LanguageModal(isOnboarding: true),
          barrierDismissible: false,
        );

        // Modal বন্ধ হওয়ার পর save করুন
        await prefs.setBool('languageSelected', true);
        isLanguageModalShowing.value = false;
        
        print('Language selection saved to SharedPreferences');
      }
    } catch (e) {
      print('Error showing language modal: $e');
      isLanguageModalShowing.value = false;
    }
  }

  void nextPage() {
    // Changed from 3 to 2 since we now have 3 pages (index 0,1,2)
    if (currentPage.value < 2) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login screen
      Get.offNamed(AppRoute.loginScreen);
    }
  }

  // Method to manually reset language selection (for testing)
  Future<void> resetLanguageSelection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('languageSelected', false);
    hasShownLanguageModal.value = false;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}