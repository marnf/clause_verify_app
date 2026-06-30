import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/core/utils/constants/image_path.dart';
import 'package:clause_verify/features/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!controller.isImageLoaded.value) {
          return Container(color: Colors.black);
        }

        return Stack(
          children: [
            // First Background Image (will slide left)
            Positioned.fill(
              child: SlideTransition(
                position: controller.firstImageSlideAnimation,
                child: Image.asset(
                  controller.firstBackgroundImage.value,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.black);
                  },
                ),
              ),
            ),

            // Second Background Image (will slide from right)
            Positioned.fill(
              child: SlideTransition(
                position: controller.secondImageSlideAnimation,
                child: Image.asset(
                  controller.secondBackgroundImage.value,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.black);
                  },
                ),
              ),
            ),

            // Dark overlay
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),

            // Animated Content
            Center(
              child: SlideTransition(
                position: controller.slideAnimation,
                child: FadeTransition(
                  opacity: controller.opacityAnimation,
                  child: ScaleTransition(
                    scale: controller.scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo Container
                        Column(
                          children: [
                            Image.asset(ImagePath.logo, height: 100.h),

                            Image.asset(ImagePath.logo_name, height: 100.h),

                          ],
                        ),
                        SizedBox(height: 15.h),

                        // Subtitle
                        Text(
                          'Verify Your Contacts',
                          style: TextStyle(
                            fontSize: 13.sp,
                            letterSpacing: 2.sp,
                            color: const Color(0xFFD4AF37),
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Divider
                        Container(
                          width: 120.w,
                          height: 1.h,
                          color: const Color(0xFFD4AF37).withOpacity(0.5),
                        ),

                        SizedBox(height: 12.h),

                        // AI Text
                        Text(
                          'AI-Powered Contract Analysis',
                          style: TextStyle(
                            fontSize: 11.sp,
                            letterSpacing: 1.5.sp,
                            color: const Color(0xFFD4AF37),
                            fontWeight: FontWeight.w300,
                          ),
                        ),

                        SizedBox(height: 50.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Version text
            Positioned(
              bottom: 60.h,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Version 1.0',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white60,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
