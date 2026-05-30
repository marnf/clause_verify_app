// import 'package:flutter/material.dart';
// import 'package:flutter_extension/features/home/controllers/home_controller.dart';
// import 'package:get/get.dart';
// import 'package:flutter_extension/core/common/widgets/app_bar.dart';
// import 'package:flutter_extension/core/common/widgets/custom_button.dart';
// import 'package:flutter_extension/core/utils/constants/app_colors.dart';
// import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
// import 'package:flutter_extension/core/utils/constants/icon_path.dart';
// import 'package:flutter_extension/features/pricing/controller/subscription_controller.dart';
// import 'package:flutter_extension/features/pricing/model/plan_model.dart';

// class SubscriptionScreen extends StatelessWidget {
//   const SubscriptionScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<SubscriptionController>();

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 14.w),
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         appBar: CustomAppBar(title: 'payPerScan'.tr),
//         body: SafeArea(
//           child: Obx(() {
//             if (controller.isLoading.value && controller.allPlans.isEmpty) {
//               return const Center(
//                 child: CircularProgressIndicator(color: Colors.amber),
//               );
//             }

//             return SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _FreePlanSection(controller: controller),
//                   SizedBox(height: 16.h),
//                   _ContinueWithFreePlanButton(controller: controller),
//                   SizedBox(height: 32.h),
//                   _PayPerScanSection(controller: controller),
//                   SizedBox(height: 40.h),
//                   _SubscriptionPlansSection(controller: controller),
//                 ],
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // Free Plan Section
// // ============================================================
// class _FreePlanSection extends StatelessWidget {
//   final SubscriptionController controller;
//   const _FreePlanSection({Key? key, required this.controller}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final plan = controller.freePlan.value;
//       return _PlanCard(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _FreePlanHeader(planName: plan?.name ?? 'Free Plan'),
//             SizedBox(height: 16.h),
//             _FeatureItem(
//               icon: IconPath.checkbox,
//               text: plan != null
//                   ? '${plan.scansIncluded} ${'welcomeAnalyses'.tr}'
//                   : '3 ${'welcomeAnalyses'.tr}',
//               isEnabled: true,
//             ),
//             _FeatureItem(icon: IconPath.checkbox, text: 'analysisEveryDays'.tr, isEnabled: true),
//             _FeatureItem(icon: IconPath.checkbox, text: 'basicAiResultsOnly'.tr, isEnabled: true),
//             _FeatureItem(icon: IconPath.info, text: 'adsIncluded'.tr, isEnabled: false),
//             _FeatureItem(icon: IconPath.info, text: 'noPdfReports'.tr, isEnabled: false),
//           ],
//         ),
//       );
//     });
//   }
// }

// class _FreePlanHeader extends StatelessWidget {
//   final String planName;
//   const _FreePlanHeader({Key? key, required this.planName}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: Text(
//             planName,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const _CurrentPlanBadge(),
//       ],
//     );
//   }
// }

// class _CurrentPlanBadge extends StatelessWidget {
//   const _CurrentPlanBadge({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: AppColors.currentPlanBg,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         'currentPlan'.tr,
//         style: TextStyle(
//           color: Colors.grey[400],
//           fontSize: 12.sp,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // Continue with Free Plan Button
// // ============================================================
// class _ContinueWithFreePlanButton extends StatelessWidget {
//   final SubscriptionController controller;
//   const _ContinueWithFreePlanButton({Key? key, required this.controller}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final homeController = Get.isRegistered<HomeController>()
//         ? Get.find<HomeController>()
//         : null;

//     return Obx(() {
//       final scansRemaining = homeController?.freeScansRemaining.value ?? 0;
//       return CustomButton(
//         text: 'continue'.tr,
//         onTap: controller.onContinueWithFreePlan,
//         backgroundColor: scansRemaining > 0 ? AppColors.primaryColor : Colors.grey[700],
//       );
//     });
//   }
// }

// // ============================================================
// // Pay Per Scan Section
// // ============================================================
// class _PayPerScanSection extends StatelessWidget {
//   final SubscriptionController controller;
//   const _PayPerScanSection({Key? key, required this.controller}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final hasStandard = controller.standardPlan.value != null;
//       final hasPremium = controller.premiumPlan.value != null;

//       if (!hasStandard && !hasPremium) return const SizedBox.shrink();

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _SectionTitle(title: 'payPerScanOptions'.tr),
//           SizedBox(height: 16.h),
//           if (hasStandard) _StandardAnalysisCard(controller: controller),
//           if (hasStandard && hasPremium) SizedBox(height: 16.h),
//           if (hasPremium) _PremiumAnalysisCard(controller: controller),
//         ],
//       );
//     });
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String title;
//   const _SectionTitle({Key? key, required this.title}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
//     );
//   }
// }

// // ============================================================
// // Standard Analysis Card
// // ============================================================
// class _StandardAnalysisCard extends StatelessWidget {
//   final SubscriptionController controller;
//   const _StandardAnalysisCard({Key? key, required this.controller}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final plan = controller.standardPlan.value;
//       if (plan == null) return const SizedBox.shrink();

//       final priceText = controller.standardDisplayPrice.isNotEmpty
//           ? controller.standardDisplayPrice
//           : '\$${double.tryParse(plan.price)?.toStringAsFixed(2) ?? '0.00'}';

//       return _PlanCard(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _AnalysisCardHeader(title: plan.name, icon: IconPath.shock),
//             SizedBox(height: 8.h),
//             // ✅ Price loading হলে small spinner দেখাবে
//             controller.isPricesLoading.value
//                 ? Padding(
//                     padding: EdgeInsets.symmetric(vertical: 6.h),
//                     child: SizedBox(
//                       width: 20.w,
//                       height: 20.h,
//                       child: CircularProgressIndicator(
//                         color: AppColors.primaryColor,
//                         strokeWidth: 2,
//                       ),
//                     ),
//                   )
//                 : _PriceText(price: priceText),
//             SizedBox(height: 16.h),
//             if (plan.basicAuthenticityCheck)
//               _FeatureItem(icon: IconPath.checkbox, text: 'basicAuthenticityCheck'.tr, isEnabled: true),
//             if (plan.fastProcessing)
//               _FeatureItem(icon: IconPath.checkbox, text: 'fastProcessing'.tr, isEnabled: true),
//             if (!plan.canDownloadPdf)
//               _FeatureItem(icon: IconPath.info, text: 'noPdfReports'.tr, isEnabled: false),
//             SizedBox(height: 16.h),
//             CustomButton(text: 'buyStandard'.tr, onTap: controller.onBuyStandard),
//           ],
//         ),
//       );
//     });
//   }
// }

// // ============================================================
// // Premium Analysis Card
// // ============================================================
// class _PremiumAnalysisCard extends StatelessWidget {
//   final SubscriptionController controller;
//   const _PremiumAnalysisCard({Key? key, required this.controller}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final plan = controller.premiumPlan.value;
//       if (plan == null) return const SizedBox.shrink();

//       final priceText = controller.premiumDisplayPrice.isNotEmpty
//           ? controller.premiumDisplayPrice
//           : '\$${double.tryParse(plan.price)?.toStringAsFixed(2) ?? '0.00'}';

//       return _PlanCard(
//         borderColor: AppColors.currentPlanBg,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _AnalysisCardHeader(title: plan.name, badge: 'bestPlan'.tr),
//             SizedBox(height: 8.h),
//             // ✅ Price loading হলে small spinner দেখাবে
//             controller.isPricesLoading.value
//                 ? Padding(
//                     padding: EdgeInsets.symmetric(vertical: 6.h),
//                     child: SizedBox(
//                       width: 20.w,
//                       height: 20.h,
//                       child: CircularProgressIndicator(
//                         color: AppColors.primaryColor,
//                         strokeWidth: 2,
//                       ),
//                     ),
//                   )
//                 : _PriceText(price: priceText),
//             SizedBox(height: 16.h),
//             if (plan.showComponentBreakdown)
//               _FeatureItem(icon: IconPath.checkbox, text: 'detailedAiBreakdown'.tr, isEnabled: true),
//             if (plan.showComponentObservations)
//               _FeatureItem(icon: IconPath.checkbox, text: 'allWatchComponentsEvaluated'.tr, isEnabled: true),
//             if (plan.canDownloadPdf)
//               _FeatureItem(icon: IconPath.checkbox, text: 'includesPDFReport'.tr, isEnabled: true),
//             if (plan.pdfIncludesStamps)
//               _FeatureItem(icon: IconPath.checkbox, text: 'includesAuthenticWatchCheckerStamp'.tr, isEnabled: true),
//             SizedBox(height: 16.h),
//             CustomButton(text: 'buyPremium'.tr, onTap: controller.onBuyPremium),
//           ],
//         ),
//       );
//     });
//   }
// }

// // ============================================================
// // Shared Card Header
// // ============================================================
// class _AnalysisCardHeader extends StatelessWidget {
//   final String title;
//   final String? icon;
//   final String? badge;

//   const _AnalysisCardHeader({Key? key, required this.title, this.icon, this.badge})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: Text(
//             title,
//             style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
//           ),
//         ),
//         if (icon != null)
//           Image.asset(icon!, width: 38.w, height: 38.h)
//         else if (badge != null)
//           _BestPlanBadge(text: badge!),
//       ],
//     );
//   }
// }

// class _BestPlanBadge extends StatelessWidget {
//   final String text;
//   const _BestPlanBadge({Key? key, required this.text}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.amber[700],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }

// class _PriceText extends StatelessWidget {
//   final String price;
//   const _PriceText({Key? key, required this.price}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       price,
//       style: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold),
//     );
//   }
// }

// // ============================================================
// // Subscription Plans Section — ✅ Loading indicator যোগ করা হয়েছে
// // ============================================================
// class _SubscriptionPlansSection extends StatelessWidget {
//   final SubscriptionController controller;
//   const _SubscriptionPlansSection({Key? key, required this.controller}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // ✅ Plans ও prices দুটোই নেই — বড় centered spinner
//       if (controller.isPricesLoading.value && controller.subscriptionPlans.isEmpty) {
//         return Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 40.h),
//             child: CircularProgressIndicator(
//               color: AppColors.primaryColor,
//               strokeWidth: 2.5,
//             ),
//           ),
//         );
//       }

//       if (controller.subscriptionPlans.isEmpty) return const SizedBox.shrink();

//       // ✅ Plans আছে, prices এখনো আসছে — cards + নিচে ছোট spinner
//       return Column(
//         children: [
//           ...controller.subscriptionPlans
//               .map((plan) => _SubscriptionPlanCard(controller: controller, plan: plan))
//               .toList(),
//           if (controller.isPricesLoading.value)
//             Padding(
//               padding: EdgeInsets.only(bottom: 20.h),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 16.w,
//                     height: 16.h,
//                     child: CircularProgressIndicator(
//                       color: AppColors.primaryColor,
//                       strokeWidth: 2,
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   Text(
//                     'loadingPrices'.tr,
//                     style: TextStyle(
//                       color: Colors.grey[400],
//                       fontSize: 13.sp,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       );
//     });
//   }
// }

// class _SubscriptionPlanCard extends StatelessWidget {
//   final SubscriptionController controller;
//   final SubscriptionPlan plan;

//   const _SubscriptionPlanCard({Key? key, required this.controller, required this.plan})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _PremiumLogo(),
//         SizedBox(height: 16.h),
//         _PlanName(name: plan.name.tr),
//         SizedBox(height: 10.h),
//         _PlanDivider(),
//         SizedBox(height: 10.h),
//         _PlanDescription(description: plan.description.tr),
//         SizedBox(height: 12.h),
//         const _FairUsePolicyLink(),
//         SizedBox(height: 12.h),
//         _PricingOptionsList(controller: controller, pricingOptions: plan.pricingOptions),
//         SizedBox(height: 24.h),
//         _BenefitsSection(controller: controller, plan: plan),
//         SizedBox(height: 16.h),
//         const _SubscriptionTermsText(),
//         SizedBox(height: 20.h),
//         Divider(color: Colors.grey[800], thickness: 1),
//         SizedBox(height: 30.h),
//       ],
//     );
//   }
// }

// class _PremiumLogo extends StatelessWidget {
//   const _PremiumLogo({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Image.asset(IconPath.premiumLogo, width: 90.w, height: 90.h);
//   }
// }

// class _PlanName extends StatelessWidget {
//   final String name;
//   const _PlanName({Key? key, required this.name}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       name,
//       style: TextStyle(
//         color: AppColors.primaryColor,
//         fontSize: 20.sp,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
// }

// class _PlanDivider extends StatelessWidget {
//   const _PlanDivider({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100.w,
//       height: 0.5,
//       color: AppColors.primaryColor,
//     );
//   }
// }

// class _PlanDescription extends StatelessWidget {
//   final String description;
//   const _PlanDescription({Key? key, required this.description}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       description,
//       textAlign: TextAlign.center,
//       style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
//     );
//   }
// }

// class _FairUsePolicyLink extends StatelessWidget {
//   const _FairUsePolicyLink({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // TODO: Navigate to fair use policy
//       },
//       child: Text(
//         'fairUsePolicy'.tr,
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: AppColors.primaryColor,
//           fontSize: 14.sp,
//           decoration: TextDecoration.underline,
//           decorationThickness: 1,
//           decorationColor: AppColors.primaryColor,
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // Pricing Options
// // ============================================================
// class _PricingOptionsList extends StatelessWidget {
//   final SubscriptionController controller;
//   final List<PricingOption> pricingOptions;

//   const _PricingOptionsList({
//     Key? key,
//     required this.controller,
//     required this.pricingOptions,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: pricingOptions
//           .map((option) => _PricingOptionCard(controller: controller, option: option))
//           .toList(),
//     );
//   }
// }

// class _PricingOptionCard extends StatelessWidget {
//   final SubscriptionController controller;
//   final PricingOption option;

//   const _PricingOptionCard({Key? key, required this.controller, required this.option})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final isSelected = controller.selectedOption.value?.id == option.id;
//       return Padding(
//         padding: EdgeInsets.only(
//           bottom: 12.h,
//           top: option.badge != null ? 12.h : 0,
//         ),
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             _PricingOptionContent(
//               controller: controller,
//               option: option,
//               isSelected: isSelected,
//             ),
//             if (option.badge != null)
//               _PricingOptionBadge(badge: option.badge!.tr),
//           ],
//         ),
//       );
//     });
//   }
// }

// class _PricingOptionContent extends StatelessWidget {
//   final SubscriptionController controller;
//   final PricingOption option;
//   final bool isSelected;

//   const _PricingOptionContent({
//     Key? key,
//     required this.controller,
//     required this.option,
//     required this.isSelected,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => controller.selectPricingOption(option),
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.grey[900] : Colors.grey[800],
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? AppColors.primaryColor : Colors.grey[700]!,
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _PricingDetails(controller: controller, option: option),
//                 _RadioButton(isSelected: isSelected),
//               ],
//             ),
//             if (option.monthlyEquivalent != null || option.savings != null)
//               _SavingsInfo(controller: controller, option: option),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _PricingDetails extends StatelessWidget {
//   final SubscriptionController controller;
//   final PricingOption option;

//   const _PricingDetails({Key? key, required this.controller, required this.option})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // ✅ Loading হলে price এর জায়গায় ছোট spinner
//       if (controller.isPricesLoading.value && option.displayPrice == null) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               width: 20.w,
//               height: 20.h,
//               child: CircularProgressIndicator(
//                 color: AppColors.primaryColor,
//                 strokeWidth: 2,
//               ),
//             ),
//             SizedBox(height: 4.h),
//             Text(
//               option.type == 'monthly' ? 'Monthly' : 'Yearly',
//               style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
//             ),
//           ],
//         );
//       }

//       final priceText = option.displayPrice ?? controller.formatPrice(option.price);

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 priceText,
//                 style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(width: 4.w),
//               Padding(
//                 padding: EdgeInsets.only(bottom: 2.h),
//                 child: Text(
//                   option.type == 'monthly' ? '/month' : '/year',
//                   style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
//                 ),
//               ),
//             ],
//           ),
//           Text(
//             option.type == 'monthly' ? 'Monthly' : 'Yearly',
//             style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
//           ),
//         ],
//       );
//     });
//   }
// }

// class _RadioButton extends StatelessWidget {
//   final bool isSelected;
//   const _RadioButton({Key? key, required this.isSelected}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 24.w,
//       height: 24.h,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: isSelected ? AppColors.primaryColor : Colors.grey[600]!,
//           width: 2,
//         ),
//       ),
//       child: isSelected
//           ? Center(
//               child: Container(
//                 width: 12.w,
//                 height: 12.h,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: AppColors.primaryColor,
//                 ),
//               ),
//             )
//           : null,
//     );
//   }
// }

// class _SavingsInfo extends StatelessWidget {
//   final SubscriptionController controller;
//   final PricingOption option;

//   const _SavingsInfo({Key? key, required this.controller, required this.option})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final parts = <String>[
//       if (option.monthlyEquivalent != null) controller.getMonthlyEquivalentText(option),
//       if (option.savings != null) controller.getSavingsText(option),
//     ].where((s) => s.isNotEmpty).toList();

//     if (parts.isEmpty) return const SizedBox.shrink();

//     return Padding(
//       padding: EdgeInsets.only(top: 8.h),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//         decoration: BoxDecoration(
//           color: Colors.grey[700],
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Text(
//           parts.join(' • '),
//           style: TextStyle(color: Colors.grey[300], fontSize: 11.sp),
//         ),
//       ),
//     );
//   }
// }

// class _PricingOptionBadge extends StatelessWidget {
//   final String badge;
//   const _PricingOptionBadge({Key? key, required this.badge}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: -12,
//       left: 0,
//       right: 0,
//       child: Center(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
//           decoration: BoxDecoration(
//             color: AppColors.primaryColor,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Text(
//             badge,
//             style: TextStyle(color: Colors.black, fontSize: 11.sp, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // Benefits Section
// // ============================================================
// class _BenefitsSection extends StatelessWidget {
//   final SubscriptionController controller;
//   final SubscriptionPlan plan;

//   const _BenefitsSection({Key? key, required this.controller, required this.plan})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.grey[900],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'allPremiumBenefits'.tr,
//             style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 12.h),
//           _BenefitsList(benefits: plan.benefits),
//           SizedBox(height: 16.h),
//           _SubscribeButton(controller: controller, plan: plan),
//         ],
//       ),
//     );
//   }
// }

// class _BenefitsList extends StatelessWidget {
//   final List<String> benefits;
//   const _BenefitsList({Key? key, required this.benefits}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: benefits
//           .map(
//             (benefit) => Padding(
//               padding: EdgeInsets.only(bottom: 10.h),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Image.asset(
//                     IconPath.checkbox,
//                     width: 16.w,
//                     height: 16.h,
//                     color: AppColors.primaryColor,
//                   ),
//                   SizedBox(width: 12.w),
//                   Expanded(
//                     child: Text(
//                       benefit.tr,
//                       style: TextStyle(color: Colors.grey[300], fontSize: 14.sp),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }
// }

// class _SubscribeButton extends StatelessWidget {
//   final SubscriptionController controller;
//   final SubscriptionPlan plan;

//   const _SubscribeButton({Key? key, required this.controller, required this.plan})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final isLoading = controller.isLoading.value;
//       final isYearly = controller.selectedOption.value?.type == 'yearly';

//       return CustomButton(
//         text: isYearly ? 'subscribeAnnually'.tr : 'subscribeMonthly'.tr,
//         onTap: isLoading
//             ? () {}
//             : () {
//                 final option = controller.selectedOption.value;
//                 if (option != null) {
//                   controller.subscribe(plan, option);
//                 }
//               },
//         height: 56.h,
//         backgroundColor: isLoading ? Colors.grey[700] : AppColors.primaryColor,
//         textColor: isLoading ? Colors.grey[400] : Colors.black,
//         borderRadius: BorderRadius.circular(12),
//         isUpperCase: false,
//         prefixIcon: isLoading
//             ? SizedBox(
//                 width: 20.w,
//                 height: 20.h,
//                 child: CircularProgressIndicator(color: Colors.grey[400], strokeWidth: 2),
//               )
//             : Image.asset(
//                 IconPath.premiumIcon,
//                 width: 20.w,
//                 height: 20.h,
//                 color: Colors.black,
//               ),
//         customTextStyle: TextStyle(
//           color: isLoading ? Colors.grey[400] : Colors.black,
//           fontSize: 16.sp,
//           fontWeight: FontWeight.bold,
//         ),
//       );
//     });
//   }
// }

// class _SubscriptionTermsText extends StatelessWidget {
//   const _SubscriptionTermsText({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       'subscriptionAutomaticallyRenewsUnlessCancelledCancelAnytimeFromSettings'.tr,
//       textAlign: TextAlign.center,
//       style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
//     );
//   }
// }

// // ============================================================
// // Shared Widgets
// // ============================================================
// class _PlanCard extends StatelessWidget {
//   final Widget child;
//   final Color? borderColor;

//   const _PlanCard({Key? key, required this.child, this.borderColor}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppColors.currentPlanBg,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: borderColor ?? AppColors.subscription_card_border,
//           width: 1,
//         ),
//       ),
//       child: child,
//     );
//   }
// }

// class _FeatureItem extends StatelessWidget {
//   final String icon;
//   final String text;
//   final bool isEnabled;

//   const _FeatureItem({Key? key, required this.icon, required this.text, required this.isEnabled})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12.h),
//       child: Row(
//         children: [
//           Image.asset(
//             icon,
//             color: isEnabled ? Colors.amber[700] : Colors.grey[600],
//             width: 20.w,
//             height: 20.h,
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 color: isEnabled ? Colors.white : Colors.grey[500],
//                 fontSize: 14.sp,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:flutter_extension/features/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_extension/core/common/widgets/app_bar.dart';
import 'package:flutter_extension/core/common/widgets/custom_button.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/core/utils/constants/app_sizer.dart';
import 'package:flutter_extension/core/utils/constants/icon_path.dart';
import 'package:flutter_extension/features/pricing/controller/subscription_controller.dart';
import 'package:flutter_extension/features/pricing/model/plan_model.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBar(title: 'payPerScan'.tr),
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value && controller.allPlans.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FreePlanSection(controller: controller),
                  SizedBox(height: 16.h),
                  _ContinueWithFreePlanButton(controller: controller),
                  SizedBox(height: 32.h),
                  _PayPerScanSection(controller: controller),
                  SizedBox(height: 40.h),
                  _SubscriptionPlansSection(controller: controller),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================
// Free Plan Section
// ============================================================
class _FreePlanSection extends StatelessWidget {
  final SubscriptionController controller;
  const _FreePlanSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final plan = controller.freePlan.value;
      return _PlanCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FreePlanHeader(planName: plan?.name ?? 'Free Plan'),
            SizedBox(height: 16.h),
            _FeatureItem(
              icon: IconPath.checkbox,
              text: plan != null
                  ? '${plan.scansIncluded} ${'welcomeAnalyses'.tr}'
                  : '${'welcomeAnalyses'.tr}',
              isEnabled: true,
            ),
            _FeatureItem(icon: IconPath.checkbox, text: 'analysisEveryDays'.tr, isEnabled: true),
            _FeatureItem(icon: IconPath.checkbox, text: 'basicAiResultsOnly'.tr, isEnabled: true),
            _FeatureItem(icon: IconPath.info, text: 'adsIncluded'.tr, isEnabled: false),
            _FeatureItem(icon: IconPath.info, text: 'noPdfReports'.tr, isEnabled: false),
          ],
        ),
      );
    });
  }
}

class _FreePlanHeader extends StatelessWidget {
  final String planName;
  const _FreePlanHeader({Key? key, required this.planName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            planName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const _CurrentPlanBadge(),
      ],
    );
  }
}

class _CurrentPlanBadge extends StatelessWidget {
  const _CurrentPlanBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.currentPlanBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'currentPlan'.tr,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ============================================================
// Continue with Free Plan Button
// ============================================================
class _ContinueWithFreePlanButton extends StatelessWidget {
  final SubscriptionController controller;
  const _ContinueWithFreePlanButton({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : null;

    return Obx(() {
      final scansRemaining = homeController?.freeScansRemaining.value ?? 0;
      return CustomButton(
        text: 'continue'.tr,
        onTap: controller.onContinueWithFreePlan,
        backgroundColor: scansRemaining > 0 ? AppColors.primaryColor : Colors.grey[700],
      );
    });
  }
}

// ============================================================
// Pay Per Scan Section
// ============================================================
class _PayPerScanSection extends StatelessWidget {
  final SubscriptionController controller;
  const _PayPerScanSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasStandard = controller.standardPlan.value != null;
      final hasPremium = controller.premiumPlan.value != null;

      if (!hasStandard && !hasPremium) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'payPerScanOptions'.tr),
          SizedBox(height: 16.h),
          if (hasStandard) _StandardAnalysisCard(controller: controller),
          if (hasStandard && hasPremium) SizedBox(height: 16.h),
          if (hasPremium) _PremiumAnalysisCard(controller: controller),
        ],
      );
    });
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
    );
  }
}

// ============================================================
// Standard Analysis Card
// ============================================================
class _StandardAnalysisCard extends StatelessWidget {
  final SubscriptionController controller;
  const _StandardAnalysisCard({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final plan = controller.standardPlan.value;
      if (plan == null) return const SizedBox.shrink();

      final priceText = controller.standardDisplayPrice.isNotEmpty
          ? controller.standardDisplayPrice
          : '\$${double.tryParse(plan.price)?.toStringAsFixed(2) ?? '0.00'}';

      return _PlanCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AnalysisCardHeader(title: plan.name, icon: IconPath.shock),
            SizedBox(height: 8.h),
            controller.isPricesLoading.value
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : _PriceText(price: priceText),
            SizedBox(height: 16.h),
            if (plan.basicAuthenticityCheck)
              _FeatureItem(icon: IconPath.checkbox, text: 'basicAuthenticityCheck'.tr, isEnabled: true),
            if (plan.fastProcessing)
              _FeatureItem(icon: IconPath.checkbox, text: 'fastProcessing'.tr, isEnabled: true),
            if (!plan.canDownloadPdf)
              _FeatureItem(icon: IconPath.info, text: 'noPdfReports'.tr, isEnabled: false),
            SizedBox(height: 16.h),
            CustomButton(text: 'buyStandard'.tr, onTap: controller.onBuyStandard),
          ],
        ),
      );
    });
  }
}

// ============================================================
// Premium Analysis Card
// ============================================================
class _PremiumAnalysisCard extends StatelessWidget {
  final SubscriptionController controller;
  const _PremiumAnalysisCard({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final plan = controller.premiumPlan.value;
      if (plan == null) return const SizedBox.shrink();

      final priceText = controller.premiumDisplayPrice.isNotEmpty
          ? controller.premiumDisplayPrice
          : '\$${double.tryParse(plan.price)?.toStringAsFixed(2) ?? '0.00'}';

      return _PlanCard(
        borderColor: AppColors.currentPlanBg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AnalysisCardHeader(title: plan.name, badge: 'bestPlan'.tr),
            SizedBox(height: 8.h),
            controller.isPricesLoading.value
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : _PriceText(price: priceText),
            SizedBox(height: 16.h),
            if (plan.showComponentBreakdown)
              _FeatureItem(icon: IconPath.checkbox, text: 'detailedAiBreakdown'.tr, isEnabled: true),
            if (plan.showComponentObservations)
              _FeatureItem(icon: IconPath.checkbox, text: 'allWatchComponentsEvaluated'.tr, isEnabled: true),
            if (plan.canDownloadPdf)
              _FeatureItem(icon: IconPath.checkbox, text: 'includesPDFReport'.tr, isEnabled: true),
            if (plan.pdfIncludesStamps)
              _FeatureItem(icon: IconPath.checkbox, text: 'includesAuthenticWatchCheckerStamp'.tr, isEnabled: true),
            SizedBox(height: 16.h),
            CustomButton(text: 'buyPremium'.tr, onTap: controller.onBuyPremium),
          ],
        ),
      );
    });
  }
}

// ============================================================
// Shared Card Header
// ============================================================
class _AnalysisCardHeader extends StatelessWidget {
  final String title;
  final String? icon;
  final String? badge;

  const _AnalysisCardHeader({Key? key, required this.title, this.icon, this.badge})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
        ),
        if (icon != null)
          Image.asset(icon!, width: 38.w, height: 38.h)
        else if (badge != null)
          _BestPlanBadge(text: badge!),
      ],
    );
  }
}

class _BestPlanBadge extends StatelessWidget {
  final String text;
  const _BestPlanBadge({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber[700],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _PriceText extends StatelessWidget {
  final String price;
  const _PriceText({Key? key, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      price,
      style: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold),
    );
  }
}

// ============================================================
// Subscription Plans Section
// ============================================================
class _SubscriptionPlansSection extends StatelessWidget {
  final SubscriptionController controller;
  const _SubscriptionPlansSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isPricesLoading.value && controller.subscriptionPlans.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
              strokeWidth: 2.5,
            ),
          ),
        );
      }

      if (controller.subscriptionPlans.isEmpty) return const SizedBox.shrink();

      return Column(
        children: [
          ...controller.subscriptionPlans
              .map((plan) => _SubscriptionPlanCard(controller: controller, plan: plan))
              .toList(),
          if (controller.isPricesLoading.value)
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16.w,
                    height: 16.h,
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'loadingPrices'.tr,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }
}

class _SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionController controller;
  final SubscriptionPlan plan;

  const _SubscriptionPlanCard({Key? key, required this.controller, required this.plan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PremiumLogo(),
        SizedBox(height: 16.h),
        _PlanName(name: plan.name.tr),
        SizedBox(height: 10.h),
        _PlanDivider(),
        SizedBox(height: 10.h),
        _PlanDescription(description: plan.description.tr),
        SizedBox(height: 12.h),
        const _FairUsePolicyLink(),
        SizedBox(height: 12.h),
        _PricingOptionsList(controller: controller, pricingOptions: plan.pricingOptions),
        SizedBox(height: 24.h),
        _BenefitsSection(controller: controller, plan: plan),
        SizedBox(height: 16.h),
        const _SubscriptionTermsText(),
        SizedBox(height: 20.h),
        Divider(color: Colors.grey[800], thickness: 1),
        SizedBox(height: 30.h),
      ],
    );
  }
}

class _PremiumLogo extends StatelessWidget {
  const _PremiumLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(IconPath.premiumLogo, width: 90.w, height: 90.h);
  }
}

class _PlanName extends StatelessWidget {
  final String name;
  const _PlanName({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
        color: AppColors.primaryColor,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _PlanDivider extends StatelessWidget {
  const _PlanDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 0.5,
      color: AppColors.primaryColor,
    );
  }
}

class _PlanDescription extends StatelessWidget {
  final String description;
  const _PlanDescription({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
    );
  }
}

class _FairUsePolicyLink extends StatelessWidget {
  const _FairUsePolicyLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to fair use policy
      },
      child: Text(
        'fairUsePolicy'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 14.sp,
          decoration: TextDecoration.underline,
          decorationThickness: 1,
          decorationColor: AppColors.primaryColor,
        ),
      ),
    );
  }
}

// ============================================================
// Pricing Options
// ============================================================
class _PricingOptionsList extends StatelessWidget {
  final SubscriptionController controller;
  final List<PricingOption> pricingOptions;

  const _PricingOptionsList({
    Key? key,
    required this.controller,
    required this.pricingOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: pricingOptions
          .map((option) => _PricingOptionCard(controller: controller, option: option))
          .toList(),
    );
  }
}

class _PricingOptionCard extends StatelessWidget {
  final SubscriptionController controller;
  final PricingOption option;

  const _PricingOptionCard({Key? key, required this.controller, required this.option})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedOption.value?.id == option.id;
      return Padding(
        padding: EdgeInsets.only(
          bottom: 12.h,
          top: option.badge != null ? 12.h : 0,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _PricingOptionContent(
              controller: controller,
              option: option,
              isSelected: isSelected,
            ),
            if (option.badge != null)
              _PricingOptionBadge(badge: option.badge!.tr),
          ],
        ),
      );
    });
  }
}

class _PricingOptionContent extends StatelessWidget {
  final SubscriptionController controller;
  final PricingOption option;
  final bool isSelected;

  const _PricingOptionContent({
    Key? key,
    required this.controller,
    required this.option,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.selectPricingOption(option),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[900] : Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey[700]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PricingDetails(controller: controller, option: option),
                _RadioButton(isSelected: isSelected),
              ],
            ),
            if (option.monthlyEquivalent != null || option.savings != null)
              _SavingsInfo(controller: controller, option: option),
          ],
        ),
      ),
    );
  }
}

class _PricingDetails extends StatelessWidget {
  final SubscriptionController controller;
  final PricingOption option;

  const _PricingDetails({Key? key, required this.controller, required this.option})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isPricesLoading.value && option.displayPrice == null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
                strokeWidth: 2,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              option.type == 'monthly' ? 'Monthly' : 'Yearly',
              style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
            ),
          ],
        );
      }

      final priceText = option.displayPrice ?? controller.formatPrice(option.price);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                priceText,
                style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4.w),
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  option.type == 'monthly' ? '/month' : '/year',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
                ),
              ),
            ],
          ),
          Text(
            option.type == 'monthly' ? 'Monthly' : 'Yearly',
            style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
          ),
        ],
      );
    });
  }
}

class _RadioButton extends StatelessWidget {
  final bool isSelected;
  const _RadioButton({Key? key, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : Colors.grey[600]!,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
              ),
            )
          : null,
    );
  }
}

class _SavingsInfo extends StatelessWidget {
  final SubscriptionController controller;
  final PricingOption option;

  const _SavingsInfo({Key? key, required this.controller, required this.option})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      if (option.monthlyEquivalent != null) controller.getMonthlyEquivalentText(option),
      if (option.savings != null) controller.getSavingsText(option),
    ].where((s) => s.isNotEmpty).toList();

    if (parts.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          parts.join(' • '),
          style: TextStyle(color: Colors.grey[300], fontSize: 11.sp),
        ),
      ),
    );
  }
}

class _PricingOptionBadge extends StatelessWidget {
  final String badge;
  const _PricingOptionBadge({Key? key, required this.badge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -12,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badge,
            style: TextStyle(color: Colors.black, fontSize: 11.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Benefits Section
// ============================================================
class _BenefitsSection extends StatelessWidget {
  final SubscriptionController controller;
  final SubscriptionPlan plan;

  const _BenefitsSection({Key? key, required this.controller, required this.plan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'allPremiumBenefits'.tr,
            style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          _BenefitsList(benefits: plan.benefits),
          SizedBox(height: 16.h),
          _SubscribeButton(controller: controller, plan: plan),
        ],
      ),
    );
  }
}

class _BenefitsList extends StatelessWidget {
  final List<String> benefits;
  const _BenefitsList({Key? key, required this.benefits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: benefits
          .map(
            (benefit) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    IconPath.checkbox,
                    width: 16.w,
                    height: 16.h,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      benefit.tr,
                      style: TextStyle(color: Colors.grey[300], fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SubscribeButton extends StatelessWidget {
  final SubscriptionController controller;
  final SubscriptionPlan plan;

  const _SubscribeButton({Key? key, required this.controller, required this.plan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final isYearly = controller.selectedOption.value?.type == 'yearly';

      return CustomButton(
        text: isYearly ? 'subscribeAnnually'.tr : 'subscribeMonthly'.tr,
        onTap: isLoading
            ? () {}
            : () {
                final option = controller.selectedOption.value;
                if (option != null) {
                  controller.subscribe(plan, option);
                }
              },
        height: 56.h,
        backgroundColor: isLoading ? Colors.grey[700] : AppColors.primaryColor,
        textColor: isLoading ? Colors.grey[400] : Colors.black,
        borderRadius: BorderRadius.circular(12),
        isUpperCase: false,
        prefixIcon: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(color: Colors.grey[400], strokeWidth: 2),
              )
            : Image.asset(
                IconPath.premiumIcon,
                width: 20.w,
                height: 20.h,
                color: Colors.black,
              ),
        customTextStyle: TextStyle(
          color: isLoading ? Colors.grey[400] : Colors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      );
    });
  }
}

class _SubscriptionTermsText extends StatelessWidget {
  const _SubscriptionTermsText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'subscriptionAutomaticallyRenewsUnlessCancelledCancelAnytimeFromSettings'.tr,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
    );
  }
}

// ============================================================
// Shared Widgets
// ============================================================
class _PlanCard extends StatelessWidget {
  final Widget child;
  final Color? borderColor;

  const _PlanCard({Key? key, required this.child, this.borderColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.currentPlanBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? AppColors.subscription_card_border,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String icon;
  final String text;
  final bool isEnabled;

  const _FeatureItem({Key? key, required this.icon, required this.text, required this.isEnabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Image.asset(
            icon,
            color: isEnabled ? Colors.amber[700] : Colors.grey[600],
            width: 20.w,
            height: 20.h,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isEnabled ? Colors.white : Colors.grey[500],
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}