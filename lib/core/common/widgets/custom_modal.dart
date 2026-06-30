import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // IMPORTANT: Blur er jonno import korte hobe
import 'package:get/get.dart';

class CustomDialog extends StatelessWidget {
  final String? imagePath; // Image asset path (optional)
  final Widget? customIcon; // Custom icon widget (optional)
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Color? buttonColor;
  final Color? backgroundColor;

  const CustomDialog({
    Key? key,
    this.imagePath,
    this.customIcon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
    this.buttonColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Blurred Background with White Tint
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.white.withOpacity(0.1), // White tint layer
                ),
              ),
            ),
          ),
          
          // Dialog Content
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon/Image Section
                Container(
                  child: Center(
                    child: Container(
                      child: customIcon ??
                          (imagePath != null
                              ? Image.asset(
                                  imagePath!,
                                  width: 160.w,
                                  height: 160.h,
                                  fit: BoxFit.contain,
                                )
                              : Icon(
                                  Icons.safety_check,
                                  color: Colors.white,
                                  size: 160.sp,
                                )),
                    ),
                  ),
                ),

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),

                // Subtitle
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),

                // Button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: onButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      elevation: 0,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          buttonText,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// GetX version helper (if using GetX)
void showCustomDialogGetX({
  String? imagePath,
  Widget? customIcon,
  required String title,
  required String subtitle,
  required String buttonText,
  required VoidCallback onButtonPressed,
  Color? buttonColor,
  Color? backgroundColor,
  bool barrierDismissible = false,
  double blurAmount = 10, // Increased blur for better effect
}) {
  Get.dialog(
    BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
      child: Container(
        color: Colors.white10.withOpacity(0.1), // White tint for background
        child: CustomDialog(
          imagePath: imagePath,
          customIcon: customIcon,
          title: title,
          subtitle: subtitle,
          buttonText: buttonText,
          onButtonPressed: onButtonPressed,
          buttonColor: buttonColor,
          backgroundColor: backgroundColor,
        ),
      ),
    ),
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withOpacity(0.5),
  );
}