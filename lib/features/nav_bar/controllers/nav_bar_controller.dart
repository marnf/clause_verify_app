import 'package:flutter_extension/features/history/controller/history_controller.dart';
import 'package:flutter_extension/features/history/screen/history_screen.dart';
import 'package:flutter_extension/features/home/controllers/home_controller.dart';
import 'package:flutter_extension/features/profile/screen/profile_screen.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../home/presentaion/screens/home_screen.dart';

class NavBarController extends GetxController {
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
  }

  void changeIndex(int index) {
    final previousIndex = selectedIndex.value;
    selectedIndex.value = index;
    
    // ✅ Home tab (index 0) refresh
    if (index == 0 && previousIndex != 0) {
      try {
        final homeController = Get.find<HomeController>();
        Future.delayed(Duration(milliseconds: 100), () {
          homeController.refreshData();
        });
      } catch (e) {
        print('⚠️ HomeController not found: $e');
      }
    }
    
    // ✅ History tab (index 1) refresh
    else if (index == 1 && previousIndex != 1) {
      try {
        final historyController = Get.find<HistoryController>();
        Future.delayed(Duration(milliseconds: 100), () {
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