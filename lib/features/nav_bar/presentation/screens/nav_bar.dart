import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/icon_path.dart';
import 'package:clause_verify/features/nav_bar/controllers/nav_bar_controller.dart';

class NavBar extends GetView<NavBarController> {
  NavBar({super.key});

  final NavBarController controller = Get.put(NavBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() => controller.screens[controller.currentIndex]),
      bottomNavigationBar: Container(
        height: 110.h,
        color: AppColors.surface,
        child: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentIndex,
            onTap: controller.changeIndex,

            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: AppColors.textMuted,

            selectedLabelStyle: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            unselectedLabelStyle: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            
            showUnselectedLabels: true,
            elevation: 0,
            items: [
              _buildNavItem(iconPath: IconPath.home, label: 'home'.tr),
              _buildNavItem(iconPath: IconPath.history, label: 'history'.tr),
              _buildNavItem(iconPath: IconPath.user, label: 'profile'.tr),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required String iconPath,
    required String label,
  }) {
    return BottomNavigationBarItem(
      activeIcon: Image.asset(
        iconPath,
        width: 25.w,
        height: 25.h,
        color: AppColors.primaryColor,
      ),
      icon: Image.asset(
        iconPath,
        width: 20.w,
        height: 20.h,
        color: AppColors.textMuted,
      ),
      label: label,
    );
  }
}