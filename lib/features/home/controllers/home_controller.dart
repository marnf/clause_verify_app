import 'dart:async';

import 'package:clause_verify/core/services/auth_service.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/timezone_helper.dart';
import 'package:clause_verify/features/analysis/model/analysis_result_model.dart';
import 'package:clause_verify/features/home/model/home_model.dart';
import 'package:clause_verify/features/home/model/scan_job_status_model.dart';
import 'package:clause_verify/features/home/widget/bottomsheet.dart';
import 'package:clause_verify/features/home/widget/no_scan_modal.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final Rx<HomeModel> home = HomeModel.empty().obs;
  final RxBool isLoading = false.obs;

  /// Data ekbar load hoye gele true (local cache ba API theke).
  final RxBool isLoaded = false.obs;

  // Purchase-er por polling cholche kina (ekbar-e ekta polling chalabo)
  bool _isPolling = false;

  // ══════════ Latest scan job (home card) ══════════
  /// null = card dekhabo na
  final Rxn<ScanJobStatus> jobStatus = Rxn<ScanJobStatus>();

  /// Completed card-e tap korar por result load hocche
  final RxBool isOpeningResult = false.obs;

  Timer? _jobTimer;
  bool _jobRequestRunning = false;
  bool _inForeground = true;

  /// COMPLETED + is_read true dekhle true hoy -> polling bondho.
  /// Notun kore _startJobPolling() call holei abar false hoy.
  bool _jobFinished = false;

  static const int _activePollSeconds = 3; // QUEUED / ANALYZING
  static const int _idlePollSeconds = 10; // baki shob obostha

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
    _jobTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _inForeground = true;
      loadUserProfile();
      _startJobPolling(); // app abar khulle ekbar hit hobei
    } else if (state == AppLifecycleState.paused) {
      // background-e giye polling bondho
      _inForeground = false;
      _jobTimer?.cancel();
    }
  }

  Future<void> _initializeAndLoad() async {
    await AuthService.init();
    _loadFromLocal();
    loadUserProfile();
    _startJobPolling(); // token ready howar por
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

      // Phone-এর timezone (Asia/Dhaka, Europe/Paris ইত্যাদি) — প্রতিবার API call-এ header-এ যাবে
      final timezone = await getUserTimezone();

      final response = await NetworkCaller().getRequest(
        Endpoints.userProfile,
        token: AuthService.token,
        headers: {'X-Timezone': timezone},
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

  // ══════════ Latest job polling ══════════

  /// Home screen-e ashle (tab change / notun kore build) eta call hobe.
  /// COMPLETED + is_read thakle o ekbar hit kore dekhbe, notun scan hoyeche kina.
  void onHomeVisible() => _startJobPolling();

  /// Timer reset kore sathe sathe ekbar fetch kore, tarpor nijer theke schedule hoy
  void _startJobPolling() {
    _jobFinished = false;
    _inForeground = true;
    _jobTimer?.cancel();
    _pollJob();
  }

  Future<void> _pollJob() async {
    if (_jobRequestRunning) return; // cholche thakle seta-i porer ta schedule korbe
    _jobRequestRunning = true;
    try {
      await _fetchLatestJobStatus();
    } finally {
      _jobRequestRunning = false;
    }
    _scheduleNextPoll();
  }

  void _scheduleNextPoll() {
    _jobTimer?.cancel();
    if (isClosed || !_inForeground) return;

    // COMPLETED + is_read true -> ar hit korbo na
    if (_jobFinished) return;

    final active = jobStatus.value?.isActive ?? false;
    _jobTimer = Timer(
      Duration(seconds: active ? _activePollSeconds : _idlePollSeconds),
      _pollJob,
    );
  }

  Future<void> _fetchLatestJobStatus() async {
    try {
      final response = await NetworkCaller().getRequest(
        Endpoints.latestScanStatus,
        token: AuthService.token,
      );

      // network/server error hole ager obostha-i thakuk (card jeno blink na kore)
      if (!response.isSuccess) return;

      final previous = jobStatus.value;
      final next = ScanJobStatus.fromResponse(response.responseData);

      // Job shesh holo -> scan count ekhon update hoyeche, profile refresh
      final wasActive = previous?.isActive ?? false;
      if (wasActive && next != null && !next.isActive) {
        loadUserProfile();
      }

      if (next != null && next.isRejected) {
        // Contract na (REJECTED / NOT_A_CONTRACT): card dekhabo na.
        // Polling cholbe, karon user sathe sathe notun contract upload korte pare.
        jobStatus.value = null;
      } else if (next != null && next.isCompletedAndRead) {
        // user age dekhe felechhe: card lukao + polling bondho
        _jobFinished = true;
        jobStatus.value = null;
      } else {
        // null hole card lukiye jabe, baki obosthay card dekhabe
        jobStatus.value = next;
      }
    } catch (_) {
      // ignore, porer poll-e abar chesta hobe
    }
  }

  /// Completed card-e tap: analysis_id diye result load kore result screen-e jay
  Future<void> openJobResult() async {
    final job = jobStatus.value;
    if (job == null || !job.isCompleted) return;
    final analysisId = job.analysisId;
    if (analysisId == null || analysisId.isEmpty) return;
    if (isOpeningResult.value) return;

    isOpeningResult.value = true;
    try {
      final response = await NetworkCaller().getRequest(
        '${Endpoints.fileAnalysis}$analysisId/',
        token: AuthService.token,
      );

      if (!response.isSuccess || response.responseData == null) {
        _showResultError();
        return;
      }

      // { "data": {...} } ba direct {...} duto-i handle
      final body = response.responseData;
      Map<String, dynamic>? data;
      if (body is Map<String, dynamic>) {
        final inner = body['data'];
        data = inner is Map<String, dynamic> ? inner : body;
      }
      if (data == null) {
        _showResultError();
        return;
      }

      await Get.toNamed(
        AppRoute.analysisResultScreen,
        arguments: AnalysisResultModel.fromJson(data),
      );

      // result dekhe ferar por status abar niye ashi (is_read ekhon true howar kotha)
      _startJobPolling();
    } catch (_) {
      _showResultError();
    } finally {
      isOpeningResult.value = false;
    }
  }

  void _showResultError() {
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Text('resultLoadFailed'.tr,
          style: const TextStyle(color: AppColors.white)),
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
    );
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
    _startJobPolling(); // notun scan shuru hoye thakle sathe sathe card dekhabo
  }

  Future<void> navigateToCamera() async {
    if (isLocked) return NoScanModal.show();
    await Get.toNamed(AppRoute.cameraScreen);
    await loadUserProfile();
    _startJobPolling();
  }

  Future<void> navigateToPremium() async {
    await Get.toNamed(AppRoute.subscriptionScreen);
    await loadUserProfile();
    _startJobPolling();
  }

  /// Upore-r scan button e click korle
  void showScanDetails() => ScanDetailsBottomSheet.show();

  /// Locked box e tap korle
  void showNoScanModal() => NoScanModal.show();

  Future<void> refreshData() async => loadUserProfile();
}