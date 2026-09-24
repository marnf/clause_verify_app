import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clause_verify/core/services/purchase_service.dart';
import 'package:clause_verify/features/nav_bar/controllers/nav_bar_controller.dart';
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

  // Entitlement identifier
  static const String monthlyEntitlement = 'monthly_access';
  static const String unlimitedEntitlement = 'unlimited_access';

  static const String playManageUrl =
      'https://play.google.com/store/account/subscriptions';
}

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

  bool get hasActivePlan =>
      activePlan.value == 'monthly' || activePlan.value == 'unlimited';

  // ✅ এখন ৫টা ভাষাতেই translate হয় (assets/language/*.json)
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

  // Google Play থেকে ফিরে এলে (cancel করার পর) status নিজে refresh হয়
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        !isPurchasing.value &&
        !isLoading.value) {
      refreshCustomerInfo(force: true);
    }
  }

  Future<void> loadAll() async {
    isLoading.value = true;
    errorMessage.value = null;

    if (!PurchaseService.isConfigured) {
      errorMessage.value = 'iapUnavailableMessage'.tr;
      isLoading.value = false;
      return;
    }

    await _loadOfferings();
    await refreshCustomerInfo();
    isLoading.value = false;
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      final offering =
          offerings.all[SubscriptionIds.offeringId] ?? offerings.current;

      if (offering == null) {
        errorMessage.value = 'plansUnavailableMessage'.tr;
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
      errorMessage.value = e.message ?? 'somethingWentWrong'.tr;
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
    } catch (_) {
      // নীরবে ব্যর্থ হলে আগের অবস্থাই থাকবে
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
  }

  bool isSubscriptionPackage(String id) =>
      id == SubscriptionIds.monthlyPackage ||
      id == SubscriptionIds.unlimitedPackage;

  bool isCurrentPlan(String id) {
    final plan = activePlan.value;
    return (id == SubscriptionIds.monthlyPackage && plan == 'monthly') ||
        (id == SubscriptionIds.unlimitedPackage && plan == 'unlimited');
  }

  /// কেনা সফল হলে true ফেরত দেয়। Screen ফেরার কাজ caller-এর।
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

    // দুটো subscription একসাথে কেনা আটকানো (টাকা দুবার কাটা ঠেকাতে)
    if (isSubscriptionPackage(packageId) && hasActivePlan) {
      _snack(
        'alreadyHavePlanTitle'.tr,
        'alreadyHavePlanBody'.tr,
        isError: true,
      );
      return false;
    }

    isPurchasing.value = true;
    purchasingId.value = packageId;
    bool success = false;

    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      _applyCustomerInfo(result.customerInfo);
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
    goHome();
    _snack('purchaseSuccessTitle'.tr, 'purchaseSuccessBody'.tr);
  }

  /// সব page বন্ধ করে প্রথম route-এ ফেরে, আর nav bar-এর Home tab খোলে।
  /// (আগে শুধু Get.until ছিল, তাই Profile থেকে এলে Profile tab-এ নামত)
  void goHome() {
    Get.until((route) => route.isFirst);
    if (Get.isRegistered<NavBarController>()) {
      Get.find<NavBarController>().backToHome();
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
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } on PlatformException catch (e) {
      _snack('restoreFailedTitle'.tr, e.message ?? 'somethingWentWrong'.tr,
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
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
    );
  }
}