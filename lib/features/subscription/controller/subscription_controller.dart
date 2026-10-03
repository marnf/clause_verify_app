
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clause_verify/core/services/purchase_service.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/features/home/controllers/home_controller.dart';
import 'package:clause_verify/features/nav_bar/controllers/nav_bar_controller.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// RevenueCat dashboard-এর সাথে মিলিয়ে রাখা নাম
class SubscriptionIds {
  static const String offeringId = 'default';

  // Package identifier (Offering-এর ভেতরে)
  static const String monthlyPackage = r'$rc_monthly';
  static const String unlimitedPackage = 'unlimited';
  static const String scanSinglePackage = 'scan_single';
  static const String pdfReportPackage = 'pdf_report';

  // Entitlement identifier — এগুলো RevenueCat dashboard-এর
  // Entitlements-এর identifier-এর সাথে অক্ষরে অক্ষরে (case-sensitive) মিলতে হবে
  static const String monthlyEntitlement = 'monthly_access';
  static const String unlimitedEntitlement = 'unlimited_access';

  static const String playManageUrl =
      'https://play.google.com/store/account/subscriptions';
}

/// Subscription plan change-এর ধরন
enum PlanChangeType { upgrade, downgrade }

class SubscriptionController extends GetxController
    with WidgetsBindingObserver {
  final isLoading = true.obs;
  final isRestoring = false.obs;
  final isPurchasing = false.obs;
  final purchasingId = ''.obs; // এখন কোন package কেনা হচ্ছে
  final errorMessage = RxnString();

  /// package identifier -> Package
  final RxMap<String, Package> packages = <String, Package>{}.obs;

  /// 'free' | 'monthly' | 'unlimited'
  final activePlan = 'free'.obs;
  final Rxn<DateTime> planExpiresAt = Rxn<DateTime>();
  final willRenew = true.obs;

  /// বর্তমান active subscription-এর store product id (Google-এর জন্য
  /// base plan বাদ দিয়ে শুধু subscription id)। Plan change-এ লাগে।
  String? _activeProductId;

  /// শেষ purchase-টা deferred downgrade ছিল কিনা
  bool _lastPurchaseWasDeferred = false;

  // কেনার পরপরই lifecycle-resume এসে ভুলভাবে "খালি" দেখানো ঠেকাতে এই cooldown।
  DateTime? _lastPurchaseAt;
  static const Duration _postPurchaseCooldown = Duration(seconds: 10);

  bool get hasActivePlan =>
      activePlan.value == 'monthly' || activePlan.value == 'unlimited';

  String get planLabel {
    switch (activePlan.value) {
      case 'monthly':
        return 'monthlyPlanLabelFull'.tr;
      case 'unlimited':
        return 'unlimitedPlanLabelFull'.tr;
      default:
        return 'freePlanLabel'.tr;
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadAll();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (isPurchasing.value || isLoading.value) return;

    final lastPurchase = _lastPurchaseAt;
    if (lastPurchase != null &&
        DateTime.now().difference(lastPurchase) < _postPurchaseCooldown) {
      return; // এইমাত্র কেনা হয়েছে, local ফলাফলই বিশ্বাসযোগ্য
    }

    refreshCustomerInfo(force: true);
  }

  Future<void> loadAll() async {
    isLoading.value = true;
    errorMessage.value = null;

    if (!PurchaseService.isConfigured) {
      errorMessage.value = 'iapUnavailableMessage'.tr;
      isLoading.value = false;
      _debugLog('PurchaseService.isConfigured == false — RevenueCat '
          'configure হয়নি, তাই কোনো plan/entitlement দেখানো যাবে না।');
      return;
    }

    await _debugLogIdentity();
    await _loadOfferings();

    final withinPostPurchaseCooldown = _lastPurchaseAt != null &&
        DateTime.now().difference(_lastPurchaseAt!) < _postPurchaseCooldown;
    await refreshCustomerInfo(force: !withinPostPurchaseCooldown);

    isLoading.value = false;
  }

  /// ── DEBUG: root cause বের করার জন্য সাময়িক log ──
  Future<void> _debugLogIdentity() async {
    if (!kDebugMode) return;
    try {
      final appUserId = await Purchases.appUserID;
      final isAnon = await Purchases.isAnonymous;
      debugPrint(
        '🔍 [Subscription] RevenueCat app_user_id = "$appUserId" '
        '(anonymous: $isAnon)',
      );
    } catch (e) {
      debugPrint('🔍 [Subscription] app_user_id পড়তে সমস্যা: $e');
    }
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      final offering =
          offerings.all[SubscriptionIds.offeringId] ?? offerings.current;

      if (offering == null) {
        errorMessage.value = 'plansUnavailableMessage'.tr;
        _debugLog('Offering "${SubscriptionIds.offeringId}" পাওয়া যায়নি, '
            'আর current offering-ও null। RevenueCat → Offerings চেক করো।');
        return;
      }

      final map = <String, Package>{};
      for (final p in offering.availablePackages) {
        map[p.identifier] = p;
      }
      packages.assignAll(map);

      if (map.isEmpty) {
        errorMessage.value = 'plansUnavailableMessage'.tr;
      }
    } on PlatformException catch (e) {
      errorMessage.value = e.message ?? 'genericErrorBody'.tr;
    } catch (e) {
      errorMessage.value = 'plansUnavailableMessage'.tr;
    }
  }

  Future<void> refreshCustomerInfo({bool force = false}) async {
    if (!PurchaseService.isConfigured) return;
    try {
      if (force) {
        await Purchases.invalidateCustomerInfoCache();
      }
      final info = await Purchases.getCustomerInfo();
      _applyCustomerInfo(info);
    } catch (e) {
      _debugLog('getCustomerInfo ব্যর্থ হলো: $e');
    }
  }

  void _applyCustomerInfo(CustomerInfo info) {
    final active = info.entitlements.active;
    final unlimited = active[SubscriptionIds.unlimitedEntitlement];
    final monthly = active[SubscriptionIds.monthlyEntitlement];
    final entitlement = unlimited ?? monthly;

    activePlan.value = unlimited != null
        ? 'unlimited'
        : (monthly != null ? 'monthly' : 'free');

    willRenew.value = entitlement?.willRenew ?? true;

    final expiry = entitlement?.expirationDate;
    planExpiresAt.value =
        expiry != null ? DateTime.tryParse(expiry)?.toLocal() : null;

    // Google Play-তে productIdentifier "subId:basePlanId" আকারে আসতে পারে।
    // Plan change-এর জন্য শুধু subscription id (colon-এর আগের অংশ) লাগে।
    final rawProductId = entitlement?.productIdentifier;
    _activeProductId = (rawProductId == null || rawProductId.isEmpty)
        ? null
        : rawProductId.split(':').first;

    if (kDebugMode) {
      debugPrint('🔍 [Subscription] active entitlements = '
          '${active.keys.toList()}');
      debugPrint('🔍 [Subscription] all entitlements (active+inactive) = '
          '${info.entitlements.all.keys.toList()}');
      debugPrint('🔍 [Subscription] expected identifiers = '
          '["${SubscriptionIds.monthlyEntitlement}", '
          '"${SubscriptionIds.unlimitedEntitlement}"] → resolved plan = '
          '${activePlan.value}, activeProductId = $_activeProductId');
    }
  }

  void _debugLog(String message) {
    if (kDebugMode) debugPrint('🔍 [Subscription] $message');
  }

  bool isSubscriptionPackage(String id) =>
      id == SubscriptionIds.monthlyPackage ||
      id == SubscriptionIds.unlimitedPackage;

  /// এই মুহূর্তে চালু থাকা plan-টাই কিনা
  bool isCurrentPlan(String id) {
    final plan = activePlan.value;
    return (id == SubscriptionIds.monthlyPackage && plan == 'monthly') ||
        (id == SubscriptionIds.unlimitedPackage && plan == 'unlimited');
  }

  int _packageRank(String id) {
    if (id == SubscriptionIds.unlimitedPackage) return 2;
    if (id == SubscriptionIds.monthlyPackage) return 1;
    return 0;
  }

  int _currentRank() {
    switch (activePlan.value) {
      case 'unlimited':
        return 2;
      case 'monthly':
        return 1;
      default:
        return 0;
    }
  }

  /// Active subscription থাকা অবস্থায় অন্য subscription package-এ গেলে
  /// সেটা upgrade নাকি downgrade। অন্য ক্ষেত্রে null।
  PlanChangeType? planChangeType(String id) {
    if (!isSubscriptionPackage(id) || !hasActivePlan || isCurrentPlan(id)) {
      return null;
    }
    return _packageRank(id) > _currentRank()
        ? PlanChangeType.upgrade
        : PlanChangeType.downgrade;
  }

  /// Android-এ plan change করতে Google-কে পুরোনো product জানাতে হয়।
  /// - Upgrade: সাথে সাথে, বাকি সময়ের proration সহ
  /// - Downgrade: বর্তমান period শেষ হলে (deferred)
  GoogleProductChangeInfo? _buildChangeInfo(String newPackageId) {
    if (!Platform.isAndroid) return null; // iOS-এ subscription group handle করে
    final type = planChangeType(newPackageId);
    final oldProductId = _activeProductId;
    if (type == null || oldProductId == null) return null;

    return GoogleProductChangeInfo(
      oldProductId,
      prorationMode: type == PlanChangeType.upgrade
          ? GoogleProrationMode.immediateWithTimeProration
          : GoogleProrationMode.deferred,
    );
  }

  /// কেনা সফল হলে true ফেরত দেয়। Screen ফেরার কাজ caller-এর।
  ///
  /// - Monthly ⇄ Unlimited যেকোনো সময় change করা যাবে।
  /// - Single scan ও PDF যেকোনো সময় কেনা যাবে।
  Future<bool> buy(String packageId) async {
    if (isPurchasing.value) return false;

    if (!PurchaseService.isConfigured) {
      _snack('errorTitle'.tr, 'iapUnavailableMessage'.tr, isError: true);
      return false;
    }

    final package = packages[packageId];
    if (package == null) {
      _snack('errorTitle'.tr, 'plansUnavailableMessage'.tr, isError: true);
      return false;
    }

    // একই plan যেটা এখন active সেটাই আবার কেনার চেষ্টা: কিছু করার নেই
    if (isCurrentPlan(packageId)) {
      return false;
    }

    final changeType = planChangeType(packageId);
    final changeInfo = _buildChangeInfo(packageId);

    isPurchasing.value = true;
    purchasingId.value = packageId;
    _lastPurchaseWasDeferred = false;
    bool success = false;

    try {
      final params = changeInfo != null
          ? PurchaseParams.package(package, googleProductChangeInfo: changeInfo)
          : PurchaseParams.package(package);

      final result = await Purchases.purchase(params);
      _applyCustomerInfo(result.customerInfo);
      _lastPurchaseAt = DateTime.now();
      _lastPurchaseWasDeferred = changeType == PlanChangeType.downgrade;
      success = true;
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        // user নিজে cancel করেছে, কিছু দেখানোর দরকার নেই
      } else if (code == PurchasesErrorCode.productAlreadyPurchasedError) {
        _snack('alreadyPurchasedTitle'.tr, 'alreadyPurchasedBody'.tr,
            isError: true);
      } else if (code == PurchasesErrorCode.paymentPendingError) {
        _snack('paymentPendingTitle'.tr, 'paymentPendingBody'.tr);
      } else {
        _snack('purchaseFailedTitle'.tr,
            e.message ?? 'purchaseFailedGenericBody'.tr,
            isError: true);
      }
    } catch (e) {
      _snack(
        'purchaseFailedTitle'.tr,
        'purchaseErrorBody'.trParams({'error': e.toString()}),
        isError: true,
      );
    } finally {
      isPurchasing.value = false;
      purchasingId.value = '';
    }

    return success;
  }

  /// Subscription page থেকে কেনার পর Home-এ ফেরা
  Future<void> buyAndGoHome(String packageId) async {
    final ok = await buy(packageId);
    if (!ok) return;

    // Downgrade: plan এখনই বদলায় না, বর্তমান period শেষে বদলাবে।
    // তাই Home-এ না গিয়ে এখানেই বুঝিয়ে দেওয়া হয়।
    if (_lastPurchaseWasDeferred) {
      final expiry = planExpiresAt.value;
      final body = expiry != null
          ? 'planChangeScheduledBody'
              .trParams({'date': formatDate(expiry)})
          : 'planChangeScheduledBodyNoDate'.tr;
      _snack('planChangeScheduledTitle'.tr, body);
      return;
    }

    goHome();
    _snack('purchaseSuccessTitle'.tr, 'purchaseSuccessBody'.tr);
  }

  /// ✅ FIX: আগে `route.isFirst` পর্যন্ত pop হতো — stack-এর প্রথম route
  /// Login হলে কেনার পর Login-এ চলে যেত।
  /// এখন NavBar (বা Home) route পর্যন্তই pop করা হয়। যদি stack-এ
  /// NavBar/Home না-ই থাকে, তাহলে stack পরিষ্কার করে সরাসরি NavBar-এ যায়।
  void goHome() {
    bool _isHomeRoute(String? name) =>
        name == AppRoute.navBar || name == AppRoute.homeScreen;

    Get.until((route) => _isHomeRoute(route.settings.name) || route.isFirst);

    // pop করার পরেও NavBar/Home-এ না পৌঁছালে (মানে stack-এ ছিলই না)
    // Login-এ না গিয়ে সরাসরি NavBar-এ পাঠাও
    if (!_isHomeRoute(Get.currentRoute)) {
      Get.offAllNamed(AppRoute.navBar);
    }

    if (Get.isRegistered<NavBarController>()) {
      Get.find<NavBarController>().backToHome();
    }

    // backend webhook update হওয়া পর্যন্ত poll করে Home refresh
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().refreshAfterPurchase();
    }
  }

  Future<void> restorePurchases() async {
    if (isRestoring.value) return;

    if (!PurchaseService.isConfigured) {
      _snack('errorTitle'.tr, 'iapUnavailableMessage'.tr, isError: true);
      return;
    }

    isRestoring.value = true;
    try {
      final info = await Purchases.restorePurchases();
      _applyCustomerInfo(info);

      if (hasActivePlan) {
        _snack('restoredTitle'.tr, 'restoredBody'.tr);
      } else {
        Get.snackbar(
          'nothingToRestoreTitle'.tr,
          'nothingToRestoreBody'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.warning,
          colorText: AppColors.white,
        );
      }
    } on PlatformException catch (e) {
      _snack('restoreFailedTitle'.tr, e.message ?? 'genericErrorBody'.tr,
          isError: true);
    } catch (e) {
      _snack(
        'restoreFailedTitle'.tr,
        'purchaseErrorBody'.trParams({'error': e.toString()}),
        isError: true,
      );
    } finally {
      isRestoring.value = false;
    }
  }

  /// Google Play-র subscription page খোলে (cancel সেখান থেকেই হয়)
  Future<void> openCancelSubscription() async {
    try {
      String url = SubscriptionIds.playManageUrl;

      if (PurchaseService.isConfigured) {
        final info = await Purchases.getCustomerInfo();
        url = info.managementURL ?? SubscriptionIds.playManageUrl;
      }

      final launched = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        _snack('errorTitle'.tr, 'couldNotOpenPlayBody'.tr, isError: true);
      }
    } catch (e) {
      try {
        await launchUrl(
          Uri.parse(SubscriptionIds.playManageUrl),
          mode: LaunchMode.externalApplication,
        );
      } catch (_) {
        _snack('errorTitle'.tr, 'couldNotOpenPlayBody'.tr, isError: true);
      }
    }
  }

  String formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  void _snack(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? AppColors.error : AppColors.success,
      colorText: AppColors.white,
    );
  }
}