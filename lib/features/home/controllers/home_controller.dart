
import 'package:clause_verify/core/services/auth_service.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/features/home/model/home_model.dart';
import 'package:clause_verify/features/home/widget/bottomsheet.dart';
import 'package:clause_verify/features/home/widget/no_scan_modal.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final Rx<HomeModel> home = HomeModel.empty().obs;
  final RxBool isLoading = false.obs;

  /// Data ekbar load hoye gele true (local cache ba API theke).
  final RxBool isLoaded = false.obs;

  // Purchase-er por polling cholche kina (ekbar-e ekta polling chalabo)
  bool _isPolling = false;

  // ── Convenience getters ──
  String get userName => home.value.userData.fullName;
  bool get isPremiumUser => home.value.isPremium;
  int get totalScans => home.value.totalScans;
  int get scanLimit => home.value.planLimit.scanLimit;
  int get monthlyPackage => home.value.planLimit.monthlyPackage;
  int get unlimitedPackage => home.value.planLimit.unlimitedPackage;

  /// Total scan 0 hole Upload & Scan card lock
  bool get isLocked => isLoaded.value && totalScans <= 0;

  /// Scan/plan data change hoyeche kina bujhar jonno ekta "signature"
  String get _signature =>
      '$scanLimit|$monthlyPackage|$unlimitedPackage|${home.value.userData.userStatus}';

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initializeAndLoad();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) loadUserProfile();
  }

  Future<void> _initializeAndLoad() async {
    await AuthService.init();
    _loadFromLocal();
    loadUserProfile();
  }

  void _loadFromLocal() {
    home.value = HomeModel.fromLocal(
      AuthService.userData,
      AuthService.userPlanLimit,
    );
    if (AuthService.userData != null) isLoaded.value = true;
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

        home.value = HomeModel.fromJson(data);
        isLoaded.value = true;

        await AuthService.saveUserData(
          (data['user_data'] as Map<String, dynamic>?) ?? {},
        );
        await AuthService.saveUserPlanLimit(
          (data['user_plan_limit'] as Map<String, dynamic>?) ?? {},
        );
      } else {
        _loadFromLocal();
      }
    } catch (e) {
      _loadFromLocal();
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Subscription / single scan kena hole eta call hobe.
  /// Backend webhook update hote kichu second lage, tai data change na hoya
  /// porjonto 2 second por por abar fetch kore (max 8 bar ≈ 16 second).
  Future<void> refreshAfterPurchase() async {
    if (_isPolling) return;
    _isPolling = true;

    try {
      final before = _signature;

      for (int i = 0; i < 8; i++) {
        await loadUserProfile();
        if (_signature != before) break; // notun data peye gechi
        await Future.delayed(const Duration(seconds: 2));
      }
    } finally {
      _isPolling = false;
    }
  }

  // ── Navigation ──
  Future<void> navigateToUpload() async {
    if (isLocked) return NoScanModal.show();
    await Get.toNamed(AppRoute.uploadScreen);
    await loadUserProfile();
  }

  Future<void> navigateToCamera() async {
    if (isLocked) return NoScanModal.show();
    await Get.toNamed(AppRoute.cameraScreen);
    await loadUserProfile();
  }

  Future<void> navigateToPremium() async {
    await Get.toNamed(AppRoute.subscriptionScreen);
    await loadUserProfile();
  }

  /// Upore-r scan button e click korle
  void showScanDetails() => ScanDetailsBottomSheet.show();

  /// Locked box e tap korle
  void showNoScanModal() => NoScanModal.show();

  Future<void> refreshData() async => loadUserProfile();
}