import 'package:clause_verify/features/history/controller/history_controller.dart';
import 'package:clause_verify/features/history/screen/history_screen.dart';
import 'package:clause_verify/features/home/controllers/home_controller.dart';
import 'package:clause_verify/features/profile/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../home/presentaion/screens/home_screen.dart';

class NavBarController extends GetxController with WidgetsBindingObserver {
  var selectedIndex = 0.obs;

  int get currentIndex => selectedIndex.value;

  List screens = [
    HomeScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  void onInit() {
    super.onInit();
    AuthService.init();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      try {
        Get.find<HomeController>().loadUserProfile();
      } catch (e) {
        print('⚠️ HomeController not found on resume: $e');
      }
    }
  }

  void changeIndex(int index) {
    final previousIndex = selectedIndex.value;
    selectedIndex.value = index;

    if (index == 0 && previousIndex != 0) {
      try {
        final homeController = Get.find<HomeController>();
        Future.delayed(const Duration(milliseconds: 100), () {
          homeController.refreshData();
        });
      } catch (e) {
        print('⚠️ HomeController not found: $e');
      }
    } else if (index == 1 && previousIndex != 1) {
      try {
        final historyController = Get.find<HistoryController>();
        Future.delayed(const Duration(milliseconds: 100), () {
          historyController.refreshData();
        });
      } catch (e) {
        print('⚠️ HistoryController not found: $e');
      }
    }
  }

  void backToHome() {
    changeIndex(0);
  }
}