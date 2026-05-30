// import 'package:flutter/material.dart';
// import 'package:flutter_extension/core/services/auth_service.dart';
// import 'package:flutter_extension/core/services/endpoints.dart';
// import 'package:flutter_extension/core/services/iap_service.dart';
// import 'package:flutter_extension/core/services/network_caller.dart';
// import 'package:flutter_extension/features/pricing/model/plan_model.dart';
// import 'package:flutter_extension/routes/app_routes.dart';
// import 'package:get/get.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

// class SubscriptionController extends GetxController {
//   // ============================================================
//   // Observable Variables
//   // ============================================================
//   final RxString selectedPlan = 'free'.obs;
//   final RxBool isLoading = false.obs;
//   final RxList<PlanData> allPlans = <PlanData>[].obs;
//   final Rx<PricingOption?> selectedOption = Rx<PricingOption?>(null);

//   final Rx<PlanData?> freePlan = Rx<PlanData?>(null);
//   final Rx<PlanData?> standardPlan = Rx<PlanData?>(null);
//   final Rx<PlanData?> premiumPlan = Rx<PlanData?>(null);
//   final RxList<SubscriptionPlan> subscriptionPlans = <SubscriptionPlan>[].obs;

//   // One-time product prices from RevenueCat
//   final RxString _standardDisplayPrice = ''.obs;
//   final RxString _premiumDisplayPrice = ''.obs;
//   String get standardDisplayPrice => _standardDisplayPrice.value;
//   String get premiumDisplayPrice => _premiumDisplayPrice.value;

//   final Rx<Offerings?> _offerings = Rx<Offerings?>(null);

//   final IAPService _iapService = IAPService();
//   final NetworkCaller _networkCaller = NetworkCaller();

//   final RxBool isPricesLoading = true.obs;

//   // ============================================================
//   // Lifecycle
//   // ============================================================
//   @override
//   void onInit() {
//     super.onInit();
//     _initialize();
//   }

//   Future<void> _initialize() async {
//   await loadPlansFromAPI();
//   await _iapService.initialize();
//   isPricesLoading.value = true;
//   await _loadOfferings();
//   await _loadOneTimePrices();
//   isPricesLoading.value = false;
// }

//   @override
//   void onClose() {
//     allPlans.clear();
//     subscriptionPlans.clear();
//     super.onClose();
//   }

//   // ============================================================
//   // RevenueCat Offerings
//   // ============================================================
//   Future<void> _loadOfferings() async {
//     try {
//       final offerings = await _iapService.getOfferings();
//       _offerings.value = offerings;
//       _updatePricesFromOfferings();
//     } catch (e) {
//       debugPrint('❌ loadOfferings error: $e');
//     }
//   }

//   void _updatePricesFromOfferings() {
//     if (_offerings.value?.current == null) return;
//     final current = _offerings.value!.current!;

//     for (int i = 0; i < subscriptionPlans.length; i++) {
//       final plan = subscriptionPlans[i];
//       final updatedOptions = plan.pricingOptions.map((option) {
//         try {
//           final package = current.availablePackages.firstWhere(
//             (p) => p.identifier == option.id,
//           );
//           return option.copyWith(
//             displayPrice: package.storeProduct.priceString,
//           );
//         } catch (_) {
//           return option;
//         }
//       }).toList();

//       subscriptionPlans[i] = SubscriptionPlan(
//         id: plan.id,
//         name: plan.name,
//         description: plan.description,
//         icon: plan.icon,
//         pricingOptions: updatedOptions,
//         benefits: plan.benefits,
//       );
//     }
//     subscriptionPlans.refresh();
//   }

//   // One-time product prices load
//   Future<void> _loadOneTimePrices() async {
//     try {
//       final standardPrice = await _iapService.getProductPrice(
//         'standard_analysis',
//       );
//       final premiumPrice = await _iapService.getProductPrice(
//         'premium_analysis',
//       );

//       if (standardPrice != 'N/A') _standardDisplayPrice.value = standardPrice;
//       if (premiumPrice != 'N/A') _premiumDisplayPrice.value = premiumPrice;
//     } catch (e) {
//       debugPrint('❌ loadOneTimePrices error: $e');
//     }
//   }

//   // ============================================================
//   // API — Load Plans
//   // ============================================================
//   Future<void> loadPlansFromAPI({int retryCount = 0}) async {
//     try {
//       final response = await _networkCaller.getRequest(Endpoints.subscription);

//       if (response.isSuccess == true && response.responseData != null) {
//         final dynamic responseData = response.responseData;
//         List<dynamic> plansData = [];

//         if (responseData is Map && responseData['success'] == true) {
//           plansData = responseData['data'] ?? [];
//         } else if (responseData is List) {
//           plansData = responseData;
//         } else if (responseData is Map && responseData['data'] != null) {
//           plansData = responseData['data'] ?? [];
//         }

//         if (plansData.isNotEmpty) {
//           allPlans.value = plansData
//               .map((plan) => PlanData.fromJson(plan))
//               .toList();
//           _categorizePlans();
//           _buildSubscriptionPlans();
//         } else {
//           throw Exception('No plans available');
//         }
//       } else {
//         if (retryCount < 2) {
//           await Future.delayed(const Duration(seconds: 2));
//           return loadPlansFromAPI(retryCount: retryCount + 1);
//         } else {
//           throw Exception(response.errorMessage ?? 'Failed to load plans');
//         }
//       }
//     } catch (e) {
//       if (retryCount == 0) {
//         _showErrorSnackbar(
//           title: 'error'.tr,
//           message: 'Failed to load plans. Please check connection.',
//         );
//       }
//     }
//   }

//   void _categorizePlans() {
//     try {
//       freePlan.value = allPlans.firstWhere((p) => p.category == 'free');
//     } catch (_) {}
//     try {
//       standardPlan.value = allPlans.firstWhere(
//         (p) => p.category == 'pay_per_scan' && p.analysisType == 'standard',
//       );
//     } catch (_) {}
//     try {
//       premiumPlan.value = allPlans.firstWhere(
//         (p) => p.category == 'pay_per_scan' && p.analysisType == 'premium',
//       );
//     } catch (_) {}
//   }

//   void _buildSubscriptionPlans() {
//     final premiumPlans = allPlans
//         .where((p) => p.category == 'premium')
//         .toList();
//     final unlimitedPlans = allPlans
//         .where((p) => p.category == 'unlimited')
//         .toList();

//     subscriptionPlans.clear();

//     if (premiumPlans.isNotEmpty) {
//       PlanData? monthlyPlan;
//       PlanData? yearlyPlan;
//       try {
//         monthlyPlan = premiumPlans.firstWhere((p) => p.durationDays == 30);
//       } catch (_) {}
//       try {
//         yearlyPlan = premiumPlans.firstWhere((p) => p.durationDays == 365);
//       } catch (_) {}

//       if (monthlyPlan != null && yearlyPlan != null) {
//         subscriptionPlans.add(
//           _createSubscriptionPlan(
//             id: 'premium_subscription',
//             name: 'premiumSubscriptionPlanName',
//             description: 'premiumSubscriptionDescription',
//             monthlyPlan: monthlyPlan,
//             yearlyPlan: yearlyPlan,
//             // ✅ RevenueCat package identifier — offerings এ যা আছে
//             monthlyPackageId: r'$rc_monthly',
//             yearlyPackageId: r'$rc_annual',
//             // ✅ Google Play product ID — verify API এর জন্য
//             monthlyProductId: monthlyPlan.googleProductId ?? 'premium_monthly',
//             yearlyProductId: yearlyPlan.googleProductId ?? 'premium_yearly',
//             benefits: [
//               'upTo100AnalysesPerMonth',
//               'fullDetailedAiResults',
//               'priorityProcessing',
//               'noAds',
//               'unlimitedPdfReportsIncluded',
//               'viewPriceEstimation',
//             ],
//           ),
//         );
//       }
//     }

//     if (unlimitedPlans.isNotEmpty) {
//       PlanData? monthlyPlan;
//       PlanData? yearlyPlan;
//       try {
//         monthlyPlan = unlimitedPlans.firstWhere((p) => p.durationDays == 30);
//       } catch (_) {}
//       try {
//         yearlyPlan = unlimitedPlans.firstWhere((p) => p.durationDays == 365);
//       } catch (_) {}

//       if (monthlyPlan != null && yearlyPlan != null) {
//         subscriptionPlans.add(
//           _createSubscriptionPlan(
//             id: 'premium_unlimited',
//             name: 'premiumUnlimitedPlanName',
//             description: 'premiumUnlimitedDescription',
//             monthlyPlan: monthlyPlan,
//             yearlyPlan: yearlyPlan,
//             monthlyPackageId: 'unlimited_monthly',
//             yearlyPackageId: 'unlimited_yearly',
//             monthlyProductId:
//                 monthlyPlan.googleProductId ?? 'premium_unlimited_monthly',
//             yearlyProductId:
//                 yearlyPlan.googleProductId ?? 'premium_unlimited_yearly',
//             benefits: [
//               'unlimitedAIPoweredAnalysesFairUse',
//               'fullDetailedAiResults',
//               'priorityProcessing',
//               'noAds',
//               'unlimitedPdfReportsIncluded',
//               'viewPriceEstimation',
//             ],
//           ),
//         );
//       }
//     }

//     _setDefaultSelectedOption();
//   }

//   SubscriptionPlan _createSubscriptionPlan({
//     required String id,
//     required String name,
//     required String description,
//     required PlanData monthlyPlan,
//     required PlanData yearlyPlan,
//     required String monthlyPackageId,
//     required String yearlyPackageId,
//     required String monthlyProductId, // ✅ নতুন — Google Play product ID
//     required String yearlyProductId, // ✅ নতুন — Google Play product ID
//     required List<String> benefits,
//   }) {
//     final monthlyPrice = double.tryParse(monthlyPlan.price) ?? 0.0;
//     final yearlyPrice = double.tryParse(yearlyPlan.price) ?? 0.0;
//     final monthlyEquivalent = yearlyPrice / 12;
//     final savings = (monthlyPrice * 12) - yearlyPrice;

//     return SubscriptionPlan(
//       id: id,
//       name: name,
//       description: description,
//       icon: 'crown',
//       pricingOptions: [
//         PricingOption(
//           id: monthlyPackageId, // RevenueCat package identifier
//           productId: monthlyProductId, // ✅ Google Play product ID
//           type: 'monthly',
//           price: monthlyPrice,
//           currency: 'USD',
//           badge: null,
//           monthlyEquivalent: null,
//           savings: null,
//           isSelected: false,
//         ),
//         PricingOption(
//           id: yearlyPackageId, // RevenueCat package identifier
//           productId: yearlyProductId, // ✅ Google Play product ID
//           type: 'yearly',
//           price: yearlyPrice,
//           currency: 'USD',
//           badge: id == 'premium_subscription' ? 'mostPopular' : 'bestValue',
//           monthlyEquivalent: monthlyEquivalent,
//           savings: savings,
//           isSelected: true,
//         ),
//       ],
//       benefits: benefits,
//     );
//   }

//   // ============================================================
//   // Buy Methods — One Time Purchase
//   // ============================================================
//   void onBuyStandard() {
//     if (standardPlan.value == null) {
//       _showErrorSnackbar(
//         title: 'error'.tr,
//         message: 'standardPlanNotAvailable'.tr,
//       );
//       return;
//     }

//     _showPaymentDialog(
//       title: 'Purchase ${standardPlan.value!.name}',
//       price: _standardDisplayPrice.value.isNotEmpty
//           ? _standardDisplayPrice.value
//           : '\$${double.tryParse(standardPlan.value!.price)?.toStringAsFixed(2) ?? '2.49'}',
//       features: _getStandardFeatures(),
//       onConfirm: () async {
//         Get.back();
//         // ✅ Google Play product ID — 'standard_analysis'
//         final productId =
//             standardPlan.value?.googleProductId ?? 'standard_analysis';
//         await _buyOneTimeProduct(productId);
//       },
//       showBestBadge: false,
//     );
//   }

//   void onBuyPremium() {
//     if (premiumPlan.value == null) {
//       _showErrorSnackbar(
//         title: 'error'.tr,
//         message: 'premiumPlanNotAvailable'.tr,
//       );
//       return;
//     }

//     _showPaymentDialog(
//       title: 'Purchase ${premiumPlan.value!.name}',
//       price: _premiumDisplayPrice.value.isNotEmpty
//           ? _premiumDisplayPrice.value
//           : '\$${double.tryParse(premiumPlan.value!.price)?.toStringAsFixed(2) ?? '5.49'}',
//       features: _getPremiumFeatures(),
//       onConfirm: () async {
//         Get.back();
//         // ✅ Google Play product ID — 'premium_analysis'
//         final productId =
//             premiumPlan.value?.googleProductId ?? 'premium_analysis';
//         await _buyOneTimeProduct(productId);
//       },
//       showBestBadge: true,
//     );
//   }

//   // Future<void> _buyOneTimeProduct(String productId) async {
//   //   try {
//   //     isLoading.value = true;
//   //     final customerInfo = await _iapService.purchaseProduct(productId);
//   //     isLoading.value = false;

//   //     if (customerInfo != null) {
//   //       // ✅ productId directly pass করো — এটাই Google Play product ID
//   //       await _verifyWithBackend(
//   //         productId: productId,
//   //         customerInfo: customerInfo,
//   //         isSubscription: false,
//   //       );
//   //     }
//   //   } catch (e) {
//   //     isLoading.value = false;
//   //     final err = e.toString();
//   //     if (!err.contains('cancel') && !err.contains('1')) {
//   //       _showErrorSnackbar(title: 'Purchase Failed', message: err);
//   //     }
//   //   }
//   // }

//   Future<void> _buyOneTimeProduct(String productId) async {
//     try {
//       isLoading.value = true;
//       debugPrint('🛒 Buying product: $productId');
//       final customerInfo = await _iapService.purchaseProduct(productId);
//       isLoading.value = false;

//       debugPrint('👤 CustomerInfo: $customerInfo');
//       debugPrint('👤 CustomerInfo null? ${customerInfo == null}');

//       if (customerInfo != null) {
//         debugPrint('✅ Purchase successful, verifying with backend...');
//         await _verifyWithBackend(
//           productId: productId,
//           customerInfo: customerInfo,
//           isSubscription: false,
//         );
//       } else {
//         debugPrint('❌ CustomerInfo is null');
//       }
//     } catch (e) {
//       isLoading.value = false;
//       debugPrint('❌ Buy error: $e');
//       final err = e.toString();
//       if (!err.contains('cancel') && !err.contains('1')) {
//         _showErrorSnackbar(title: 'Purchase Failed', message: err);
//       }
//     }
//   }

//   // ============================================================
//   // Subscribe — Subscription Purchase
//   // ============================================================
//   Future<void> subscribe(SubscriptionPlan plan, PricingOption option) async {
//     if (isLoading.value) return;

//     if (_offerings.value?.current == null) {
//       _showErrorSnackbar(
//         title: 'Error',
//         message: 'Store not available. Please try again.',
//       );
//       await _loadOfferings();
//       return;
//     }

//     Package? targetPackage;
//     try {
//       // ✅ option.id = RevenueCat package identifier দিয়ে package খোঁজো
//       targetPackage = _offerings.value!.current!.availablePackages.firstWhere(
//         (p) => p.identifier == option.id,
//       );
//     } catch (_) {
//       _showErrorSnackbar(
//         title: 'Error',
//         message: 'Package not found: ${option.id}',
//       );
//       return;
//     }

//     try {
//       isLoading.value = true;
//       final customerInfo = await _iapService.purchasePackage(targetPackage);
//       isLoading.value = false;

//       if (customerInfo != null &&
//           customerInfo.entitlements.all['pro_access']?.isActive == true) {
//         // ✅ RevenueCat package থেকে actual Google Play product ID নাও
//         // storeProduct.identifier = Google Play Console এ যা আছে (যেমন: premium_yearly)
//         final googleProductId = targetPackage.storeProduct.identifier;

//         await _verifyWithBackend(
//           productId: googleProductId,
//           customerInfo: customerInfo,
//           isSubscription: true,
//         );
//       }
//     } catch (e) {
//       isLoading.value = false;
//       final err = e.toString();
//       if (!err.contains('cancel') && !err.contains('1')) {
//         _showErrorSnackbar(title: 'Purchase Failed', message: err);
//       }
//     }
//   }

//   // ============================================================
//   // Backend Verification — FIXED ✅
//   // ============================================================
//   Future<void> _verifyWithBackend({
//     required String productId, // Google Play product ID (যেমন: premium_yearly)
//     required CustomerInfo customerInfo,
//     bool isSubscription = false,
//   }) async {
//     try {
//       isLoading.value = true;

//       final token = AuthService.token;
//       if (token == null || token.isEmpty) {
//         isLoading.value = false;
//         _showErrorSnackbar(
//           title: 'Auth Error',
//           message: 'Session expired. Please login again.',
//         );
//         return;
//       }

//       // ✅ Backend শুধু এটুকুই চায়
//       final body = <String, dynamic>{
//         'platform': 'google',
//         'product_id': productId, // Google Play product ID
//       };

//       debugPrint('📤 Verify body: $body');

//       final response = await _networkCaller.postRequest(
//         Endpoints.revenueCatVerify,
//         body: body,
//       );

//       isLoading.value = false;

//       if (response.isSuccess == true) {
//         _showSuccessSnackbar(
//           title: isSubscription ? 'Subscribed! 🎉' : 'Purchase Successful! 🎉',
//           message: isSubscription
//               ? 'Your subscription has been activated.'
//               : 'Your plan has been activated.',
//         );
//         Get.offAllNamed(AppRoute.navBar);
//       } else {
//         throw Exception(response.errorMessage ?? 'Verification failed');
//       }
//     } catch (e) {
//       isLoading.value = false;
//       _showErrorSnackbar(title: 'Verification Failed', message: e.toString());
//     }
//   }

//   // ============================================================
//   // Free Plan & Restore
//   // ============================================================
//   void onContinueWithFreePlan() {
//     Get.offAllNamed(AppRoute.navBar);
//   }

//   Future<void> restorePurchases() async {
//     try {
//       isLoading.value = true;
//       final customerInfo = await _iapService.restorePurchases();
//       isLoading.value = false;

//       if (customerInfo?.entitlements.all['pro_access']?.isActive == true) {
//         _showSuccessSnackbar(
//           title: 'Restored!',
//           message: 'Your purchases have been restored.',
//         );
//         Get.offAllNamed(AppRoute.navBar);
//       } else {
//         _showErrorSnackbar(
//           title: 'No Purchases Found',
//           message: 'No active subscriptions found to restore.',
//         );
//       }
//     } catch (e) {
//       isLoading.value = false;
//       _showErrorSnackbar(title: 'Restore Failed', message: e.toString());
//     }
//   }

//   // ============================================================
//   // Pricing Option Selection
//   // ============================================================
//   void _setDefaultSelectedOption() {
//     if (subscriptionPlans.isNotEmpty) {
//       final firstPlan = subscriptionPlans.first;
//       try {
//         selectedOption.value = firstPlan.pricingOptions.firstWhere(
//           (o) => o.isSelected,
//         );
//       } catch (_) {
//         if (firstPlan.pricingOptions.isNotEmpty) {
//           selectedOption.value = firstPlan.pricingOptions.first;
//         }
//       }
//     }
//   }

//   void selectPricingOption(PricingOption option) {
//     selectedOption.value = option;
//   }

//   // ============================================================
//   // Features List
//   // ============================================================
//   List<String> _getStandardFeatures() {
//     final plan = standardPlan.value;
//     if (plan == null) return [];
//     final features = <String>[];
//     if (plan.basicAuthenticityCheck) features.add('basicAuthenticityCheck'.tr);
//     if (plan.fastProcessing) features.add('fastProcessing'.tr);
//     if (!plan.canDownloadPdf) features.add('noPdfReports'.tr);
//     return features;
//   }

//   List<String> _getPremiumFeatures() {
//     final plan = premiumPlan.value;
//     if (plan == null) return [];
//     final features = <String>[];
//     if (plan.showComponentBreakdown) features.add('detailedAiBreakdown'.tr);
//     if (plan.showComponentObservations)
//       features.add('allWatchComponentsEvaluated'.tr);
//     if (plan.canDownloadPdf) features.add('includesPDFReport'.tr);
//     if (plan.pdfIncludesStamps)
//       features.add('includesAuthenticWatchCheckerStamp'.tr);
//     return features;
//   }

//   // ============================================================
//   // Utility
//   // ============================================================
//   String getCurrentPlan() => selectedPlan.value;
//   bool hasActivePlan() => selectedPlan.value != 'free';
//   String formatPrice(double price) => '\$${price.toStringAsFixed(2)}';

//   String getMonthlyEquivalentText(PricingOption option) {
//     if (option.monthlyEquivalent != null) {
//       return '${'only'.tr} ${formatPrice(option.monthlyEquivalent!)} /month';
//     }
//     return '';
//   }

//   String getSavingsText(PricingOption option) {
//     if (option.savings != null && option.savings! > 0) {
//       return '${'save'.tr} ${formatPrice(option.savings!)}';
//     }
//     return '';
//   }

//   // ============================================================
//   // Dialog & Snackbar
//   // ============================================================
//   void _showPaymentDialog({
//     required String title,
//     required String price,
//     required List<String> features,
//     required VoidCallback onConfirm,
//     required bool showBestBadge,
//   }) {
//     Get.dialog(
//       AlertDialog(
//         backgroundColor: Colors.grey[900],
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: showBestBadge
//             ? Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       title,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.amber[700],
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: const Text(
//                       'Best',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             : Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               price,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             ...features.map(
//               (f) => Padding(
//                 padding: const EdgeInsets.only(bottom: 4),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.check_circle,
//                       color: Colors.amber,
//                       size: 16,
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         f,
//                         style: TextStyle(color: Colors.grey[300], fontSize: 13),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextButton(
//                   onPressed: () => Get.back(),
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(color: Colors.grey[400]),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: onConfirm,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.amber[700],
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     'Buy Now',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSuccessSnackbar({required String title, required String message}) {
//     Get.snackbar(
//       title,
//       message,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 3),
//     );
//   }

//   void _showErrorSnackbar({required String title, required String message}) {
//     Get.snackbar(
//       title,
//       message,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 3), 
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:flutter_extension/core/services/auth_service.dart';
import 'package:flutter_extension/core/services/endpoints.dart';
import 'package:flutter_extension/core/services/iap_service.dart';
import 'package:flutter_extension/core/services/network_caller.dart';
import 'package:flutter_extension/features/pricing/model/plan_model.dart';
import 'package:flutter_extension/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionController extends GetxController {
  // ============================================================
  // Observable Variables
  // ============================================================
  final RxString selectedPlan = 'free'.obs;
  final RxBool isLoading = false.obs;
  final RxList<PlanData> allPlans = <PlanData>[].obs;
  final Rx<PricingOption?> selectedOption = Rx<PricingOption?>(null);

  final Rx<PlanData?> freePlan = Rx<PlanData?>(null);
  final Rx<PlanData?> standardPlan = Rx<PlanData?>(null);
  final Rx<PlanData?> premiumPlan = Rx<PlanData?>(null);
  final RxList<SubscriptionPlan> subscriptionPlans = <SubscriptionPlan>[].obs;

  final RxString _standardDisplayPrice = ''.obs;
  final RxString _premiumDisplayPrice = ''.obs;
  String get standardDisplayPrice => _standardDisplayPrice.value;
  String get premiumDisplayPrice => _premiumDisplayPrice.value;

  final Rx<Offerings?> _offerings = Rx<Offerings?>(null);

  final IAPService _iapService = IAPService();
  final NetworkCaller _networkCaller = NetworkCaller();

  final RxBool isPricesLoading = true.obs;

  // ============================================================
  // Lifecycle
  // ============================================================
  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await loadPlansFromAPI();
    await _iapService.initialize();
    isPricesLoading.value = true;
    await _loadOfferings();
    await _loadOneTimePrices();
    isPricesLoading.value = false;
  }

  @override
  void onClose() {
    allPlans.clear();
    subscriptionPlans.clear();
    super.onClose();
  }

  // ============================================================
  // Error Message Parser
  // ============================================================
  String _parseErrorMessage(dynamic e) {
    final err = e.toString();

    if (err.contains('PlatformException')) {
      final messageMatch = RegExp(r'message:\s*([^,}]+)').firstMatch(err);
      if (messageMatch != null) {
        final msg = messageMatch.group(1)?.trim() ?? '';
        if (msg.isNotEmpty) return msg;
      }
    }

    final exceptionMatch = RegExp(
      r'Exception[:(]\s*"?([^")\n]+)"?\)?',
    ).firstMatch(err);
    if (exceptionMatch != null) {
      final msg = exceptionMatch.group(1)?.trim() ?? '';
      if (msg.isNotEmpty) return msg;
    }

    return err;
  }

  // ============================================================
  // RevenueCat Offerings
  // ============================================================
  Future<void> _loadOfferings() async {
    try {
      final offerings = await _iapService.getOfferings();
      _offerings.value = offerings;
      _updatePricesFromOfferings();
    } catch (e) {
      debugPrint('❌ loadOfferings error: $e');
    }
  }

  void _updatePricesFromOfferings() {
    if (_offerings.value?.current == null) return;
    final current = _offerings.value!.current!;

    for (int i = 0; i < subscriptionPlans.length; i++) {
      final plan = subscriptionPlans[i];
      final updatedOptions = plan.pricingOptions.map((option) {
        try {
          final package = current.availablePackages.firstWhere(
            (p) => p.identifier == option.id,
          );
          return option.copyWith(
            displayPrice: package.storeProduct.priceString,
          );
        } catch (_) {
          return option;
        }
      }).toList();

      subscriptionPlans[i] = SubscriptionPlan(
        id: plan.id,
        name: plan.name,
        description: plan.description,
        icon: plan.icon,
        pricingOptions: updatedOptions,
        benefits: plan.benefits,
      );
    }
    subscriptionPlans.refresh();
  }

  Future<void> _loadOneTimePrices() async {
    try {
      final standardPrice = await _iapService.getProductPrice(
        'standard_analysis',
      );
      final premiumPrice = await _iapService.getProductPrice(
        'premium_analysis',
      );

      if (standardPrice != 'N/A') _standardDisplayPrice.value = standardPrice;
      if (premiumPrice != 'N/A') _premiumDisplayPrice.value = premiumPrice;
    } catch (e) {
      debugPrint('❌ loadOneTimePrices error: $e');
    }
  }

  // ============================================================
  // API — Load Plans
  // ============================================================
  Future<void> loadPlansFromAPI({int retryCount = 0}) async {
    try {
      final response = await _networkCaller.getRequest(Endpoints.subscription);

      if (response.isSuccess == true && response.responseData != null) {
        final dynamic responseData = response.responseData;
        List<dynamic> plansData = [];

        if (responseData is Map && responseData['success'] == true) {
          plansData = responseData['data'] ?? [];
        } else if (responseData is List) {
          plansData = responseData;
        } else if (responseData is Map && responseData['data'] != null) {
          plansData = responseData['data'] ?? [];
        }

        if (plansData.isNotEmpty) {
          allPlans.value = plansData
              .map((plan) => PlanData.fromJson(plan))
              .toList();
          _categorizePlans();
          _buildSubscriptionPlans();
        } else {
          throw Exception('No plans available');
        }
      } else {
        if (retryCount < 2) {
          await Future.delayed(const Duration(seconds: 2));
          return loadPlansFromAPI(retryCount: retryCount + 1);
        } else {
          throw Exception(response.errorMessage ?? 'Failed to load plans');
        }
      }
    } catch (e) {
      if (retryCount == 0) {
        _showErrorSnackbar(
          title: 'error'.tr,
          message: 'failedToLoadPlansPleaseCheckConnection'.tr,
        );
      }
    }
  }

  void _categorizePlans() {
    try {
      freePlan.value = allPlans.firstWhere((p) => p.category == 'free');
    } catch (_) {}
    try {
      standardPlan.value = allPlans.firstWhere(
        (p) => p.category == 'pay_per_scan' && p.analysisType == 'standard',
      );
    } catch (_) {}
    try {
      premiumPlan.value = allPlans.firstWhere(
        (p) => p.category == 'pay_per_scan' && p.analysisType == 'premium',
      );
    } catch (_) {}
  }

  void _buildSubscriptionPlans() {
    final premiumPlans = allPlans
        .where((p) => p.category == 'premium')
        .toList();
    final unlimitedPlans = allPlans
        .where((p) => p.category == 'unlimited')
        .toList();

    subscriptionPlans.clear();

    if (premiumPlans.isNotEmpty) {
      PlanData? monthlyPlan;
      PlanData? yearlyPlan;
      try {
        monthlyPlan = premiumPlans.firstWhere((p) => p.durationDays == 30);
      } catch (_) {}
      try {
        yearlyPlan = premiumPlans.firstWhere((p) => p.durationDays == 365);
      } catch (_) {}

      if (monthlyPlan != null && yearlyPlan != null) {
        subscriptionPlans.add(
          _createSubscriptionPlan(
            id: 'premium_subscription',
            name: 'premiumSubscriptionPlanName',
            description: 'premiumSubscriptionDescription',
            monthlyPlan: monthlyPlan,
            yearlyPlan: yearlyPlan,
            monthlyPackageId: r'$rc_monthly',
            yearlyPackageId: r'$rc_annual',
            monthlyProductId: monthlyPlan.googleProductId ?? 'premium_monthly',
            yearlyProductId: yearlyPlan.googleProductId ?? 'premium_yearly',
            benefits: [
              'upTo100AnalysesPerMonth',
              'fullDetailedAiResults',
              'priorityProcessing',
              'noAds',
              'unlimitedPdfReportsIncluded',
              'viewPriceEstimation',
            ],
          ),
        );
      }
    }

    if (unlimitedPlans.isNotEmpty) {
      PlanData? monthlyPlan;
      PlanData? yearlyPlan;
      try {
        monthlyPlan = unlimitedPlans.firstWhere((p) => p.durationDays == 30);
      } catch (_) {}
      try {
        yearlyPlan = unlimitedPlans.firstWhere((p) => p.durationDays == 365);
      } catch (_) {}

      if (monthlyPlan != null && yearlyPlan != null) {
        subscriptionPlans.add(
          _createSubscriptionPlan(
            id: 'premium_unlimited',
            name: 'premiumUnlimitedPlanName',
            description: 'premiumUnlimitedDescription',
            monthlyPlan: monthlyPlan,
            yearlyPlan: yearlyPlan,
            monthlyPackageId: 'unlimited_monthly',
            yearlyPackageId: 'unlimited_yearly',
            monthlyProductId:
                monthlyPlan.googleProductId ?? 'premium_unlimited_monthly',
            yearlyProductId:
                yearlyPlan.googleProductId ?? 'premium_unlimited_yearly',
            benefits: [
              'unlimitedAIPoweredAnalysesFairUse',
              'fullDetailedAiResults',
              'priorityProcessing',
              'noAds',
              'unlimitedPdfReportsIncluded',
              'viewPriceEstimation',
            ],
          ),
        );
      }
    }

    _setDefaultSelectedOption();
  }

  SubscriptionPlan _createSubscriptionPlan({
    required String id,
    required String name,
    required String description,
    required PlanData monthlyPlan,
    required PlanData yearlyPlan,
    required String monthlyPackageId,
    required String yearlyPackageId,
    required String monthlyProductId,
    required String yearlyProductId,
    required List<String> benefits,
  }) {
    final monthlyPrice = double.tryParse(monthlyPlan.price) ?? 0.0;
    final yearlyPrice = double.tryParse(yearlyPlan.price) ?? 0.0;
    final monthlyEquivalent = yearlyPrice / 12;
    final savings = (monthlyPrice * 12) - yearlyPrice;

    return SubscriptionPlan(
      id: id,
      name: name,
      description: description,
      icon: 'crown',
      pricingOptions: [
        PricingOption(
          id: monthlyPackageId,
          productId: monthlyProductId,
          type: 'monthly',
          price: monthlyPrice,
          currency: 'USD',
          badge: null,
          monthlyEquivalent: null,
          savings: null,
          isSelected: false,
        ),
        PricingOption(
          id: yearlyPackageId,
          productId: yearlyProductId,
          type: 'yearly',
          price: yearlyPrice,
          currency: 'USD',
          badge: id == 'premium_subscription' ? 'mostPopular' : 'bestValue',
          monthlyEquivalent: monthlyEquivalent,
          savings: savings,
          isSelected: true,
        ),
      ],
      benefits: benefits,
    );
  }

  // ============================================================
  // Buy Methods — One Time Purchase
  // ============================================================
  void onBuyStandard() {
    if (standardPlan.value == null) {
      _showErrorSnackbar(
        title: 'error'.tr,
        message: 'standardPlanNotAvailable'.tr,
      );
      return;
    }

    _showPaymentDialog(
      title: '${'purchase'.tr} ${standardPlan.value!.name}',
      price: _standardDisplayPrice.value.isNotEmpty
          ? _standardDisplayPrice.value
          : '\$${double.tryParse(standardPlan.value!.price)?.toStringAsFixed(2) ?? '2.49'}',
      features: _getStandardFeatures(),
      onConfirm: () async {
        Get.back();
        final productId =
            standardPlan.value?.googleProductId ?? 'standard_analysis';
        await _buyOneTimeProduct(productId);
      },
      showBestBadge: false,
    );
  }

  void onBuyPremium() {
    if (premiumPlan.value == null) {
      _showErrorSnackbar(
        title: 'error'.tr,
        message: 'premiumPlanNotAvailable'.tr,
      );
      return;
    }

    _showPaymentDialog(
      title: '${'purchase'.tr} ${premiumPlan.value!.name}',
      price: _premiumDisplayPrice.value.isNotEmpty
          ? _premiumDisplayPrice.value
          : '\$${double.tryParse(premiumPlan.value!.price)?.toStringAsFixed(2) ?? '5.49'}',
      features: _getPremiumFeatures(),
      onConfirm: () async {
        Get.back();
        final productId =
            premiumPlan.value?.googleProductId ?? 'premium_analysis';
        await _buyOneTimeProduct(productId);
      },
      showBestBadge: true,
    );
  }

  Future<void> _buyOneTimeProduct(String productId) async {
    try {
      isLoading.value = true;
      debugPrint('🛒 Buying product: $productId');
      final customerInfo = await _iapService.purchaseProduct(productId);
      isLoading.value = false;

      if (customerInfo != null) {
        await _verifyWithBackend(
          productId: productId,
          customerInfo: customerInfo,
          isSubscription: false,
        );
      }
    } catch (e) {
      isLoading.value = false;
      final err = e.toString();
      if (!err.contains('cancel') && !err.contains('userCancelled: true')) {
        _showErrorSnackbar(
          title: 'purchaseFailed'.tr,
          message: _parseErrorMessage(e),
        );
      }
    }
  }

  // ============================================================
  // Subscribe — Subscription Purchase
  // ============================================================
  Future<void> subscribe(SubscriptionPlan plan, PricingOption option) async {
    if (isLoading.value) return;

    if (_offerings.value?.current == null) {
      _showErrorSnackbar(
        title: 'error'.tr,
        message: 'storeNotAvailablePleaseTryAgain'.tr,
      );
      await _loadOfferings();
      return;
    }

    Package? targetPackage;
    try {
      targetPackage = _offerings.value!.current!.availablePackages.firstWhere(
        (p) => p.identifier == option.id,
      );
    } catch (_) {
      _showErrorSnackbar(
        title: 'error'.tr,
        message: '${'packageNotFound'.tr}: ${option.id}',
      );
      return;
    }

    try {
      isLoading.value = true;
      final customerInfo = await _iapService.purchasePackage(targetPackage);
      isLoading.value = false;

      if (customerInfo != null &&
          customerInfo.entitlements.all['pro_access']?.isActive == true) {
        final googleProductId = targetPackage.storeProduct.identifier;
        await _verifyWithBackend(
          productId: googleProductId,
          customerInfo: customerInfo,
          isSubscription: true,
        );
      }
    } catch (e) {
      isLoading.value = false;
      final err = e.toString();
      if (!err.contains('cancel') && !err.contains('userCancelled: true')) {
        _showErrorSnackbar(
          title: 'purchaseFailed'.tr,
          message: _parseErrorMessage(e),
        );
      }
    }
  }

  // ============================================================
  // Backend Verification
  // ============================================================
  Future<void> _verifyWithBackend({
    required String productId,
    required CustomerInfo customerInfo,
    bool isSubscription = false,
  }) async {
    try {
      isLoading.value = true;

      final token = AuthService.token;
      if (token == null || token.isEmpty) {
        isLoading.value = false;
        _showErrorSnackbar(
          title: 'authError'.tr,
          message: 'sessionExpiredPleaseLoginAgain'.tr,
        );
        return;
      }

      final body = <String, dynamic>{
        'platform': 'google',
        'product_id': productId,
      };

      debugPrint('📤 Verify body: $body');

      final response = await _networkCaller.postRequest(
        Endpoints.revenueCatVerify,
        body: body,
      );

      isLoading.value = false;

      if (response.isSuccess == true) {
        _showSuccessSnackbar(
          title: isSubscription ? 'subscribed'.tr : 'purchaseSuccessful'.tr,
          message: isSubscription
              ? 'yourSubscriptionHasBeenActivated'.tr
              : 'yourPlanHasBeenActivated'.tr,
        );
        Get.offAllNamed(AppRoute.navBar);
      } else {
        _showErrorSnackbar(
          title: 'purchaseFailed'.tr,
          message: response.errorMessage ?? 'verificationFailed'.tr,
        );
      }
    } catch (e) {
      isLoading.value = false;
      _showErrorSnackbar(
        title: 'purchaseFailed'.tr,
        message: _parseErrorMessage(e),
      );
    }
  }

  // ============================================================
  // Free Plan & Restore
  // ============================================================
  void onContinueWithFreePlan() {
    Get.offAllNamed(AppRoute.navBar);
  }

  Future<void> restorePurchases() async {
    try {
      isLoading.value = true;
      final customerInfo = await _iapService.restorePurchases();
      isLoading.value = false;

      if (customerInfo?.entitlements.all['pro_access']?.isActive == true) {
        _showSuccessSnackbar(
          title: 'restored'.tr,
          message: 'yourPurchasesHaveBeenRestored'.tr,
        );
        Get.offAllNamed(AppRoute.navBar);
      } else {
        _showErrorSnackbar(
          title: 'noPurchasesFound'.tr,
          message: 'noActiveSubscriptionsFoundToRestore'.tr,
        );
      }
    } catch (e) {
      isLoading.value = false;
      _showErrorSnackbar(
        title: 'restoreFailed'.tr,
        message: _parseErrorMessage(e),
      );
    }
  }

  // ============================================================
  // Pricing Option Selection
  // ============================================================
  void _setDefaultSelectedOption() {
    if (subscriptionPlans.isNotEmpty) {
      final firstPlan = subscriptionPlans.first;
      try {
        selectedOption.value = firstPlan.pricingOptions.firstWhere(
          (o) => o.isSelected,
        );
      } catch (_) {
        if (firstPlan.pricingOptions.isNotEmpty) {
          selectedOption.value = firstPlan.pricingOptions.first;
        }
      }
    }
  }

  void selectPricingOption(PricingOption option) {
    selectedOption.value = option;
  }

  // ============================================================
  // Features List
  // ============================================================
  List<String> _getStandardFeatures() {
    final plan = standardPlan.value;
    if (plan == null) return [];
    final features = <String>[];
    if (plan.basicAuthenticityCheck) features.add('basicAuthenticityCheck'.tr);
    if (plan.fastProcessing) features.add('fastProcessing'.tr);
    if (!plan.canDownloadPdf) features.add('noPdfReports'.tr);
    return features;
  }

  List<String> _getPremiumFeatures() {
    final plan = premiumPlan.value;
    if (plan == null) return [];
    final features = <String>[];
    if (plan.showComponentBreakdown) features.add('detailedAiBreakdown'.tr);
    if (plan.showComponentObservations)
      features.add('allWatchComponentsEvaluated'.tr);
    if (plan.canDownloadPdf) features.add('includesPDFReport'.tr);
    if (plan.pdfIncludesStamps)
      features.add('includesAuthenticWatchCheckerStamp'.tr);
    return features;
  }

  // ============================================================
  // Utility
  // ============================================================
  String getCurrentPlan() => selectedPlan.value;
  bool hasActivePlan() => selectedPlan.value != 'free';
  String formatPrice(double price) => '\$${price.toStringAsFixed(2)}';

  String getMonthlyEquivalentText(PricingOption option) {
    if (option.monthlyEquivalent != null) {
      return '${'only'.tr} ${formatPrice(option.monthlyEquivalent!)} /${'month'.tr.replaceAll('/', '')}';
    }
    return '';
  }

  String getSavingsText(PricingOption option) {
    if (option.savings != null && option.savings! > 0) {
      return '${'save'.tr} ${formatPrice(option.savings!)}';
    }
    return '';
  }

  // ============================================================
  // Dialog & Snackbar
  // ============================================================
  void _showPaymentDialog({
    required String title,
    required String price,
    required List<String> features,
    required VoidCallback onConfirm,
    required bool showBestBadge,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: showBestBadge
            ? Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber[700],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'best'.tr,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            : Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        f,
                        style: TextStyle(color: Colors.grey[300], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'cancel'.tr,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'buyNow'.tr,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
