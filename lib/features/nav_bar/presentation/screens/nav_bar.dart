import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/icon_path.dart';
import '../../controllers/nav_bar_controller.dart';

class NavBar extends GetView<NavBarController> {
  NavBar({super.key});

  final NavBarController controller = Get.put(NavBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textSecondary,
      body: Obx(() => controller.screens[controller.currentIndex]),
      bottomNavigationBar: Container(
        height: 110.h,
        color:  AppColors.secondary,
        child: Obx(
          () => BottomNavigationBar(

            currentIndex: controller.currentIndex,
            onTap: controller.changeIndex,

            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: AppColors.navUnselectedColor,

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
              _buildNavItem(iconPath: IconPath.home, label: 'Home'.tr),
              _buildNavItem(iconPath: IconPath.history, label: 'History'.tr),
              // _buildNavItem(iconPath: IconPath.premium, label: 'Premium'.tr),
              _buildNavItem(iconPath: IconPath.user, label: 'Profile'.tr),
              
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
      // For Svg
      // ------------------
      // activeIcon: SvgPicture.asset(
      //   iconPath,
      //   width: 25,
      //   height: 25,
      //   colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
      // ),
      // icon: SvgPicture.asset(
      // iconPath,
      // width: 20,
      // height: 20,
      // colorFilter: ColorFilter.mode(
      //   AppColors.navUnselectedColor,
      //   BlendMode.srcIn,
      // ),
      // ),

      // For Images
      // ------------------
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
        color: AppColors.greyColor,
      ),

      label: label,
    );
  }
}
