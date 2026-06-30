import 'package:clause_verify/core/services/auth_service.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> opacityAnimation;
  late Animation<Offset> slideAnimation;

  // Background sliding animations
  late Animation<Offset> firstImageSlideAnimation;
  late Animation<Offset> secondImageSlideAnimation;

  final List<String> backgroundImages = [
    'assets/images/bg1.png',
    'assets/images/bg2.png',
    'assets/images/bg3.png',
    'assets/images/bg4.png',
    'assets/images/bg5.png',
  ];

  RxInt currentImageIndex = 0.obs;
  RxString firstBackgroundImage = 'assets/images/bg1.png'.obs;
  RxString secondBackgroundImage = 'assets/images/bg2.png'.obs;
  RxBool isImageLoaded = false.obs;
  RxBool startBackgroundAnimation = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
    _initializeSplash();
  }

  void _setupAnimations() {
    // Single animation controller for all animations
    animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Logo scale animation
    scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    // Logo opacity animation
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // Logo slide animation
    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.9), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
          ),
        );

    // First background image slide (left direction)
    firstImageSlideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-1.0, 0.0)).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
          ),
        );

    // Second background image slide (from right)
    secondImageSlideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
          ),
        );
  }

  Future<void> _initializeSplash() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get saved index from SharedPreferences or use 0
      currentImageIndex.value = prefs.getInt('bgImageIndex') ?? 0;

      // Validate index
      if (currentImageIndex.value >= backgroundImages.length) {
        currentImageIndex.value = 0;
      }

      // Set first and second background images
      firstBackgroundImage.value = backgroundImages[currentImageIndex.value];

      int nextIndex = (currentImageIndex.value + 1) % backgroundImages.length;
      secondBackgroundImage.value = backgroundImages[nextIndex];

      // Mark images as loaded
      isImageLoaded.value = true;

      // Update index for next launch (skip 2 images)
      int futureIndex = (currentImageIndex.value + 2) % backgroundImages.length;
      await prefs.setInt('bgImageIndex', futureIndex);

      // Wait for frame to build
      await Future.delayed(const Duration(milliseconds: 100));

      // Start all animations together
      animationController.forward();

      // Navigate to next screen after animation completes
      Future.delayed(const Duration(milliseconds: 3200), () {
        // Get.offAllNamed(AppRoute.onboardingScreen);

        if (AuthService.isLoggedIn) {
  
          Get.offAllNamed(AppRoute.navBar);
        } else {
       
          Get.offAllNamed(AppRoute.onboardingScreen);
        }
      });
    } catch (e) {
      print('Error initializing splash: $e');
      // Fallback
      firstBackgroundImage.value = backgroundImages[0];
      secondBackgroundImage.value = backgroundImages[1];
      isImageLoaded.value = true;

      Future.delayed(const Duration(milliseconds: 100), () {
        animationController.forward();
      });
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
