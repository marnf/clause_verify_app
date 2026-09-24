import 'package:clause_verify/core/services/auth_service.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxBool isPremiumUser = false.obs;
  final RxBool isLoading = false.obs;
  final RxString userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAndLoad();
  }

  Future<void> _initializeAndLoad() async {
    await AuthService.init();
    _loadFromLocal();
    loadUserProfile();
  }

  void _loadFromLocal() {
    userName.value = AuthService.userName ?? '';
    isPremiumUser.value = AuthService.isPremium;
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      final response = await NetworkCaller().getRequest(
        Endpoints.userProfile,
        token: AuthService.token,
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData as Map<String, dynamic>;
        await AuthService.saveUserData(data);
        isPremiumUser.value = AuthService.isPremium;
        userName.value = AuthService.userName ?? '';
      } else {
        _loadFromLocal();
      }
    } catch (e) {
      _loadFromLocal();
    } finally {
      isLoading.value = false;
    }
  }

  // Scan আটকানোর সিদ্ধান্ত এখন backend-এর (402)। App শুধু page খোলে।
  Future<void> navigateToUpload() async {
    await Get.toNamed(AppRoute.uploadScreen);
    await loadUserProfile();
  }

  Future<void> navigateToCamera() async {
    await Get.toNamed(AppRoute.cameraScreen);
    await loadUserProfile();
  }

  Future<void> navigateToPremium() async {
    await Get.toNamed(AppRoute.subscriptionScreen);
    await loadUserProfile();
  }

  Future<void> refreshData() async {
    await loadUserProfile();
  }
}