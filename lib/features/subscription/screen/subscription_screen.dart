// // import 'package:clause_verify/core/utils/constants/app_colors.dart';
// // import 'package:clause_verify/core/utils/constants/app_sizer.dart';
// // import 'package:clause_verify/features/subscription/controller/subscription_controller.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // class SubscriptionScreen extends StatelessWidget {
// //   final SubscriptionController controller = Get.put(SubscriptionController());

// //   SubscriptionScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.background,
// //       body: SafeArea(
// //         child: Padding(
// //           padding: EdgeInsets.symmetric(horizontal: 24.w),
// //           child: Column(
// //             children: [
// //               SizedBox(height: 16.h),
// //               _buildHeader(),
// //               SizedBox(height: 16.h),
// //               Expanded(
// //                 child: Obx(() {
// //                   if (controller.isLoading.value) {
// //                     return Center(
// //                       child: CircularProgressIndicator(
// //                         color: AppColors.primaryColor,
// //                       ),
// //                     );
// //                   }

// //                   if (controller.errorMessage.value != null &&
// //                       controller.packages.isEmpty) {
// //                     return _buildErrorState();
// //                   }

// //                   return RefreshIndicator(
// //                     color: AppColors.primaryColor,
// //                     backgroundColor: AppColors.surface,
// //                     onRefresh: controller.loadAll,
// //                     child: SingleChildScrollView(
// //                       physics: const AlwaysScrollableScrollPhysics(),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           // ✅ Free user-এর জন্য কোনো "Free Plan" card নেই,
// //                           // শুধু কোনো plan চালু থাকলে দেখাবে
// //                           if (controller.hasActivePlan) ...[
// //                             _buildCurrentPlanCard(),
// //                             SizedBox(height: 28.h),
// //                           ],

// //                           // ── Plans ──
// //                           _buildSectionTitle('Choose a plan'),
// //                           SizedBox(height: 12.h),
// //                           if (controller.packages
// //                               .containsKey(SubscriptionIds.monthlyPackage))
// //                             _buildPlanCard(
// //                               packageId: SubscriptionIds.monthlyPackage,
// //                               title: 'Monthly',
// //                               icon: Icons.calendar_month_rounded,
// //                               period: '/ month',
// //                               features: const [
// //                                 '50 scans per month',
// //                                 'Unused scans do not roll over',
// //                                 'Cancel anytime',
// //                               ],
// //                             ),
// //                           if (controller.packages
// //                               .containsKey(SubscriptionIds.unlimitedPackage))
// //                             _buildPlanCard(
// //                               packageId: SubscriptionIds.unlimitedPackage,
// //                               title: 'Unlimited',
// //                               icon: Icons.all_inclusive_rounded,
// //                               period: '/ month',
// //                               highlighted: true,
// //                               badge: 'BEST VALUE',
// //                               features: const [
// //                                 'Unlimited scans',
// //                                 'Fair use: up to 200 scans per month',
// //                                 'Cancel anytime',
// //                               ],
// //                             ),

// //                           SizedBox(height: 16.h),

// //                           // ── Add-ons ──
// //                           _buildSectionTitle('One-time purchases'),
// //                           SizedBox(height: 6.h),
// //                           Text(
// //                             'Added to your account automatically after purchase.',
// //                             style: TextStyle(
// //                                 color: AppColors.textMuted, fontSize: 12.sp),
// //                           ),
// //                           SizedBox(height: 12.h),
// //                           if (controller.packages
// //                               .containsKey(SubscriptionIds.scanSinglePackage))
// //                             _buildPlanCard(
// //                               packageId: SubscriptionIds.scanSinglePackage,
// //                               title: 'Single Scan',
// //                               icon: Icons.document_scanner_rounded,
// //                               features: const [
// //                                 '1 contract scan credit',
// //                                 'Pay only when you need it',
// //                               ],
// //                               buttonLabel: 'Buy',
// //                             ),
// //                           if (controller.packages
// //                               .containsKey(SubscriptionIds.pdfReportPackage))
// //                             _buildPlanCard(
// //                               packageId: SubscriptionIds.pdfReportPackage,
// //                               title: 'PDF Report',
// //                               icon: Icons.picture_as_pdf_rounded,
// //                               features: const [
// //                                 '1 downloadable PDF report',
// //                                 'Add-on for a completed scan',
// //                               ],
// //                               buttonLabel: 'Buy',
// //                             ),

// //                           SizedBox(height: 16.h),
// //                           _buildManageSection(),
// //                           SizedBox(height: 40.h),
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 }),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // ══════════════════════════════════════
// //   //  Header
// //   // ══════════════════════════════════════
// //   Widget _buildHeader() {
// //     return Row(
// //       children: [
// //         InkWell(
// //           onTap: () => Get.back(),
// //           borderRadius: BorderRadius.circular(12),
// //           child: Container(
// //             width: 42.w,
// //             height: 42.h,
// //             decoration: BoxDecoration(
// //               color: AppColors.surface,
// //               borderRadius: BorderRadius.circular(12),
// //               border: Border.all(color: AppColors.cardBorder, width: 1),
// //             ),
// //             child: Icon(Icons.arrow_back_ios_new_rounded,
// //                 color: AppColors.textWhite, size: 18),
// //           ),
// //         ),
// //         SizedBox(width: 16.w),
// //         Text(
// //           'Subscription',
// //           style: TextStyle(
// //             color: AppColors.textWhite,
// //             fontSize: 22.sp,
// //             fontWeight: FontWeight.w700,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildSectionTitle(String title) {
// //     return Text(
// //       title,
// //       style: TextStyle(
// //         color: AppColors.textWhite,
// //         fontSize: 18.sp,
// //         fontWeight: FontWeight.w600,
// //       ),
// //     );
// //   }

// //   // ══════════════════════════════════════
// //   //  Error State
// //   // ══════════════════════════════════════
// //   Widget _buildErrorState() {
// //     return Center(
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(Icons.cloud_off_rounded, color: AppColors.textMuted, size: 48),
// //           SizedBox(height: 16.h),
// //           Text(
// //             controller.errorMessage.value ?? 'Something went wrong.',
// //             textAlign: TextAlign.center,
// //             style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
// //           ),
// //           SizedBox(height: 20.h),
// //           ElevatedButton(
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: AppColors.primaryColor,
// //               padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //             ),
// //             onPressed: controller.loadAll,
// //             child: Text(
// //               'Try again',
// //               style: TextStyle(
// //                 color: AppColors.background,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ══════════════════════════════════════
// //   //  Current Plan Card
// //   // ══════════════════════════════════════
// //   Widget _buildCurrentPlanCard() {
// //     final hasPlan = controller.hasActivePlan;
// //     final expiry = controller.planExpiresAt.value;

// //     String? statusLine;
// //     if (hasPlan && expiry != null) {
// //       final date = controller.formatDate(expiry);
// //       statusLine = controller.willRenew.value
// //           ? 'Renews on $date'
// //           : 'Cancelled — access until $date';
// //     }

// //     return Container(
// //       width: double.infinity,
// //       padding: EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: hasPlan ? Color(0xFF251B0C) : AppColors.surface,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(
// //           color: hasPlan ? AppColors.primaryColor : AppColors.cardBorder,
// //           width: hasPlan ? 1.5 : 1,
// //         ),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             'CURRENT PLAN',
// //             style: TextStyle(
// //               color: AppColors.textMuted,
// //               fontSize: 12.sp,
// //               letterSpacing: 1,
// //               fontWeight: FontWeight.w600,
// //             ),
// //           ),
// //           SizedBox(height: 6.h),
// //           Row(
// //             children: [
// //               Icon(
// //                 hasPlan
// //                     ? Icons.workspace_premium_rounded
// //                     : Icons.person_outline_rounded,
// //                 color: hasPlan ? AppColors.primaryColor : AppColors.textMuted,
// //                 size: 24,
// //               ),
// //               SizedBox(width: 8.w),
// //               Text(
// //                 controller.planLabel,
// //                 style: TextStyle(
// //                   color:
// //                       hasPlan ? AppColors.primaryColor : AppColors.textWhite,
// //                   fontSize: 20.sp,
// //                   fontWeight: FontWeight.w700,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           if (statusLine != null) ...[
// //             SizedBox(height: 6.h),
// //             Text(
// //               statusLine,
// //               style: TextStyle(
// //                 color: controller.willRenew.value
// //                     ? AppColors.textSubtle
// //                     : AppColors.error,
// //                 fontSize: 13.sp,
// //               ),
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }

// //   // ══════════════════════════════════════
// //   //  Plan / Add-on Card
// //   // ══════════════════════════════════════
// //   Widget _buildPlanCard({
// //     required String packageId,
// //     required String title,
// //     required IconData icon,
// //     required List<String> features,
// //     String? period,
// //     String? badge,
// //     bool highlighted = false,
// //     String buttonLabel = 'Subscribe',
// //   }) {
// //     final package = controller.packages[packageId]!;
// //     final price = package.storeProduct.priceString; // Play Console-এর price

// //     return Container(
// //       width: double.infinity,
// //       margin: EdgeInsets.only(bottom: 14.h),
// //       padding: EdgeInsets.all(18),
// //       decoration: BoxDecoration(
// //         color: AppColors.surface,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(
// //           color: highlighted ? AppColors.primaryColor : AppColors.cardBorder,
// //           width: highlighted ? 1.5 : 1,
// //         ),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Container(
// //                 width: 42.w,
// //                 height: 42.h,
// //                 decoration: BoxDecoration(
// //                   color: Color(0xFF13233D),
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //                 child: Icon(icon, color: AppColors.goldLight, size: 22),
// //               ),
// //               SizedBox(width: 12.w),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Row(
// //                       children: [
// //                         Flexible(
// //                           child: Text(
// //                             title,
// //                             style: TextStyle(
// //                               color: AppColors.textWhite,
// //                               fontSize: 17.sp,
// //                               fontWeight: FontWeight.w600,
// //                             ),
// //                           ),
// //                         ),
// //                         if (badge != null) ...[
// //                           SizedBox(width: 8.w),
// //                           Container(
// //                             padding: EdgeInsets.symmetric(
// //                                 horizontal: 8, vertical: 3),
// //                             decoration: BoxDecoration(
// //                               color: AppColors.primaryColor,
// //                               borderRadius: BorderRadius.circular(6),
// //                             ),
// //                             child: Text(
// //                               badge,
// //                               style: TextStyle(
// //                                 color: AppColors.background,
// //                                 fontSize: 10.sp,
// //                                 fontWeight: FontWeight.w700,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ],
// //                     ),
// //                     SizedBox(height: 2.h),
// //                     RichText(
// //                       text: TextSpan(
// //                         text: price,
// //                         style: TextStyle(
// //                           color: AppColors.primaryColor,
// //                           fontSize: 18.sp,
// //                           fontWeight: FontWeight.w700,
// //                         ),
// //                         children: [
// //                           if (period != null)
// //                             TextSpan(
// //                               text: ' $period',
// //                               style: TextStyle(
// //                                 color: AppColors.textMuted,
// //                                 fontSize: 13.sp,
// //                                 fontWeight: FontWeight.w400,
// //                               ),
// //                             ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 14.h),
// //           ...features.map(
// //             (f) => Padding(
// //               padding: EdgeInsets.only(bottom: 6.h),
// //               child: Row(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Icon(Icons.check_circle_rounded,
// //                       color: AppColors.primaryColor, size: 16),
// //                   SizedBox(width: 8.w),
// //                   Expanded(
// //                     child: Text(
// //                       f,
// //                       style: TextStyle(
// //                         color: AppColors.textSubtle,
// //                         fontSize: 14.sp,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 10.h),
// //           _buildBuyButton(packageId, buttonLabel),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildBuyButton(String packageId, String label) {
// //     return Obx(() {
// //       final isCurrent = controller.isCurrentPlan(packageId);
// //       final isThisLoading = controller.isPurchasing.value &&
// //           controller.purchasingId.value == packageId;
// //       final disabled = isCurrent || controller.isPurchasing.value;

// //       return SizedBox(
// //         width: double.infinity,
// //         child: ElevatedButton(
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: AppColors.primaryColor,
// //             disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.35),
// //             padding: EdgeInsets.symmetric(vertical: 14),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //           ),
// //           onPressed: disabled ? null : () => controller.buyAndGoHome(packageId),
// //           child: isThisLoading
// //               ? SizedBox(
// //                   height: 20,
// //                   width: 20,
// //                   child: CircularProgressIndicator(
// //                     color: AppColors.background,
// //                     strokeWidth: 2,
// //                   ),
// //                 )
// //               : Text(
// //                   isCurrent ? 'Current plan' : label,
// //                   style: TextStyle(
// //                     color: AppColors.background,
// //                     fontSize: 15.sp,
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),
// //         ),
// //       );
// //     });
// //   }

// //   // ══════════════════════════════════════
// //   //  Manage / Cancel / Restore
// //   // ══════════════════════════════════════
// //   Widget _buildManageSection() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         _buildSectionTitle('Manage'),
// //         SizedBox(height: 12.h),

// //         // Cancel — শুধু active subscription থাকলে
// //         if (controller.hasActivePlan && controller.willRenew.value) ...[
// //           GestureDetector(
// //             onTap: _showCancelDialog,
// //             child: Container(
// //               width: double.infinity,
// //               padding: EdgeInsets.symmetric(vertical: 14.h),
// //               decoration: BoxDecoration(
// //                 color: Color(0xFF1C0A0A),
// //                 borderRadius: BorderRadius.circular(12),
// //                 border: Border.all(
// //                     color: AppColors.error.withOpacity(0.3), width: 1),
// //               ),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.cancel_outlined, color: AppColors.error, size: 20),
// //                   SizedBox(width: 8.w),
// //                   Text(
// //                     'Cancel Subscription',
// //                     style: TextStyle(
// //                       color: AppColors.error,
// //                       fontSize: 16.sp,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           SizedBox(height: 12.h),
// //         ],

// //         // Restore
// //         Obx(
// //           () => GestureDetector(
// //             onTap: controller.isRestoring.value
// //                 ? null
// //                 : controller.restorePurchases,
// //             child: Container(
// //               width: double.infinity,
// //               padding: EdgeInsets.symmetric(vertical: 14.h),
// //               decoration: BoxDecoration(
// //                 color: Colors.transparent,
// //                 borderRadius: BorderRadius.circular(12),
// //                 border: Border.all(color: AppColors.cardBorder, width: 1.5),
// //               ),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   if (controller.isRestoring.value)
// //                     SizedBox(
// //                       height: 18,
// //                       width: 18,
// //                       child: CircularProgressIndicator(
// //                         color: AppColors.textWhite,
// //                         strokeWidth: 2,
// //                       ),
// //                     )
// //                   else ...[
// //                     Icon(Icons.restore_rounded,
// //                         color: AppColors.textWhite, size: 20),
// //                     SizedBox(width: 8.w),
// //                     Text(
// //                       'Restore Purchases',
// //                       style: TextStyle(
// //                         color: AppColors.textWhite,
// //                         fontSize: 16.sp,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ],
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //         SizedBox(height: 12.h),
// //         Center(
// //           child: Text(
// //             'Subscriptions renew automatically until cancelled. '
// //             'Manage or cancel anytime in Google Play.',
// //             textAlign: TextAlign.center,
// //             style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   // ══════════════════════════════════════
// //   //  Cancel Dialog
// //   // ══════════════════════════════════════
// //   void _showCancelDialog() {
// //     Get.dialog(
// //       Dialog(
// //         backgroundColor: AppColors.surface,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //         child: Padding(
// //           padding: EdgeInsets.all(24),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Container(
// //                 width: 56,
// //                 height: 56,
// //                 decoration: BoxDecoration(
// //                   color: AppColors.error.withOpacity(0.1),
// //                   shape: BoxShape.circle,
// //                 ),
// //                 child: Icon(Icons.cancel_outlined,
// //                     color: AppColors.error, size: 28),
// //               ),
// //               SizedBox(height: 20),
// //               Text(
// //                 'Cancel Subscription?',
// //                 style: TextStyle(
// //                   fontSize: 20.sp,
// //                   fontWeight: FontWeight.w700,
// //                   color: AppColors.textWhite,
// //                 ),
// //               ),
// //               SizedBox(height: 8),
// //               Text(
// //                 'You will be taken to Google Play to cancel. '
// //                 'You keep your plan benefits until the end of the current billing period.',
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
// //               ),
// //               SizedBox(height: 24),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: OutlinedButton(
// //                       style: OutlinedButton.styleFrom(
// //                         side: BorderSide(color: AppColors.cardBorder),
// //                         padding: EdgeInsets.symmetric(vertical: 14),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                       ),
// //                       onPressed: () => Get.back(),
// //                       child: Text('Keep plan',
// //                           style: TextStyle(color: AppColors.textWhite)),
// //                     ),
// //                   ),
// //                   SizedBox(width: 12),
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: AppColors.error,
// //                         padding: EdgeInsets.symmetric(vertical: 14),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                       ),
// //                       onPressed: () {
// //                         Get.back();
// //                         controller.openCancelSubscription();
// //                       },
// //                       child: Text('Continue',
// //                           style: TextStyle(color: AppColors.textWhite)),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       barrierDismissible: true,
// //     );
// //   }
// // }





// import 'package:clause_verify/core/utils/constants/app_colors.dart';
// import 'package:clause_verify/core/utils/constants/app_sizer.dart';
// import 'package:clause_verify/features/subscription/controller/subscription_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SubscriptionScreen extends StatelessWidget {
//   final SubscriptionController controller = Get.put(SubscriptionController());

//   SubscriptionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Column(
//             children: [
//               SizedBox(height: 16.h),
//               _buildHeader(),
//               SizedBox(height: 20.h),
//               Expanded(
//                 child: Obx(() {
//                   if (controller.isLoading.value) {
//                     return Center(
//                       child: CircularProgressIndicator(
//                         color: AppColors.primaryColor,
//                       ),
//                     );
//                   }

//                   if (controller.errorMessage.value != null &&
//                       controller.packages.isEmpty) {
//                     return _buildErrorState();
//                   }

//                   return RefreshIndicator(
//                     color: AppColors.primaryColor,
//                     backgroundColor: AppColors.surface,
//                     onRefresh: controller.loadAll,
//                     child: SingleChildScrollView(
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // ✅ Free user-এর জন্য কোনো "Free Plan" card নেই,
//                           // শুধু কোনো plan চালু থাকলে দেখাবে
//                           if (controller.hasActivePlan) ...[
//                             _buildCurrentPlanCard(),
//                             SizedBox(height: 28.h),
//                           ],

//                           // ── One-time purchases (আগে) ──
//                           if (controller.packages.containsKey(
//                                   SubscriptionIds.scanSinglePackage) ||
//                               controller.packages.containsKey(
//                                   SubscriptionIds.pdfReportPackage)) ...[
//                             _buildSectionTitle(
//                               'One-time purchases',
//                               subtitle:
//                                   'Added to your account automatically after purchase — no commitment.',
//                               icon: Icons.bolt_rounded,
//                             ),
//                             SizedBox(height: 14.h),
//                             if (controller.packages.containsKey(
//                                 SubscriptionIds.scanSinglePackage))
//                               _buildPlanCard(
//                                 packageId: SubscriptionIds.scanSinglePackage,
//                                 title: 'Single Scan',
//                                 icon: Icons.document_scanner_rounded,
//                                 features: const [
//                                   '1 contract scan credit',
//                                   'Pay only when you need it',
//                                 ],
//                                 buttonLabel: 'Buy',
//                               ),
//                             if (controller.packages
//                                 .containsKey(SubscriptionIds.pdfReportPackage))
//                               _buildPlanCard(
//                                 packageId: SubscriptionIds.pdfReportPackage,
//                                 title: 'PDF Report',
//                                 icon: Icons.picture_as_pdf_rounded,
//                                 features: const [
//                                   '1 downloadable PDF report',
//                                   'Add-on for a completed scan',
//                                 ],
//                                 buttonLabel: 'Buy',
//                               ),
//                             SizedBox(height: 24.h),
//                           ],

//                           // ── Subscription plans (পরে) ──
//                           if (controller.packages.containsKey(
//                                   SubscriptionIds.monthlyPackage) ||
//                               controller.packages.containsKey(
//                                   SubscriptionIds.unlimitedPackage)) ...[
//                             _buildSectionTitle(
//                               'Subscription plans',
//                               subtitle:
//                                   'Get more scans every month at a better value.',
//                               icon: Icons.workspace_premium_rounded,
//                             ),
//                             SizedBox(height: 14.h),
//                             if (controller.packages
//                                 .containsKey(SubscriptionIds.monthlyPackage))
//                               _buildPlanCard(
//                                 packageId: SubscriptionIds.monthlyPackage,
//                                 title: 'Monthly',
//                                 icon: Icons.calendar_month_rounded,
//                                 period: '/ month',
//                                 features: const [
//                                   '50 scans per month',
//                                   'Unused scans do not roll over',
//                                   'Cancel anytime',
//                                 ],
//                               ),
//                             if (controller.packages
//                                 .containsKey(SubscriptionIds.unlimitedPackage))
//                               _buildPlanCard(
//                                 packageId: SubscriptionIds.unlimitedPackage,
//                                 title: 'Unlimited',
//                                 icon: Icons.all_inclusive_rounded,
//                                 period: '/ month',
//                                 highlighted: true,
//                                 badge: 'BEST VALUE',
//                                 features: const [
//                                   'Unlimited scans',
//                                   'Fair use: up to 200 scans per month',
//                                   'Cancel anytime',
//                                 ],
//                               ),
//                             SizedBox(height: 24.h),
//                           ],

//                           _buildManageSection(),
//                           SizedBox(height: 40.h),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ══════════════════════════════════════
//   //  Header
//   // ══════════════════════════════════════
//   Widget _buildHeader() {
//     return Row(
//       children: [
//         InkWell(
//           onTap: () => Get.back(),
//           borderRadius: BorderRadius.circular(12),
//           child: Container(
//             width: 42.w,
//             height: 42.h,
//             decoration: BoxDecoration(
//               color: AppColors.surface,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: AppColors.cardBorder, width: 1),
//             ),
//             child: Icon(Icons.arrow_back_ios_new_rounded,
//                 color: AppColors.textWhite, size: 18),
//           ),
//         ),
//         SizedBox(width: 16.w),
//         Text(
//           'Subscription',
//           style: TextStyle(
//             color: AppColors.textWhite,
//             fontSize: 22.sp,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ],
//     );
//   }

//   /// সাধারণ সেকশন টাইটেল — এখন optional icon ও subtitle সহ,
//   /// যাতে ইউজার সহজে বুঝতে পারে প্রতিটা সেকশন আসলে কী।
//   Widget _buildSectionTitle(String title, {String? subtitle, IconData? icon}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             if (icon != null) ...[
//               Icon(icon, color: AppColors.primaryColor, size: 18),
//               SizedBox(width: 8.w),
//             ],
//             Text(
//               title,
//               style: TextStyle(
//                 color: AppColors.textWhite,
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ],
//         ),
//         if (subtitle != null) ...[
//           SizedBox(height: 4.h),
//           Text(
//             subtitle,
//             style: TextStyle(
//               color: AppColors.textMuted,
//               fontSize: 12.5.sp,
//               height: 1.3,
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   // ══════════════════════════════════════
//   //  Error State
//   // ══════════════════════════════════════
//   Widget _buildErrorState() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.cloud_off_rounded, color: AppColors.textMuted, size: 48),
//           SizedBox(height: 16.h),
//           Text(
//             controller.errorMessage.value ?? 'Something went wrong.',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
//           ),
//           SizedBox(height: 20.h),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryColor,
//               padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             onPressed: controller.loadAll,
//             child: Text(
//               'Try again',
//               style: TextStyle(
//                 color: AppColors.background,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ══════════════════════════════════════
//   //  Current Plan Card
//   // ══════════════════════════════════════
//   Widget _buildCurrentPlanCard() {
//     final hasPlan = controller.hasActivePlan;
//     final expiry = controller.planExpiresAt.value;

//     String? statusLine;
//     if (hasPlan && expiry != null) {
//       final date = controller.formatDate(expiry);
//       statusLine = controller.willRenew.value
//           ? 'Renews on $date'
//           : 'Cancelled — access until $date';
//     }

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: hasPlan
//             ? LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Color(0xFF2B2007), Color(0xFF1F1809)],
//               )
//             : null,
//         color: hasPlan ? null : AppColors.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: hasPlan ? AppColors.primaryColor : AppColors.cardBorder,
//           width: hasPlan ? 1.5 : 1,
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 46.w,
//             height: 46.h,
//             decoration: BoxDecoration(
//               color: hasPlan
//                   ? AppColors.primaryColor.withOpacity(0.15)
//                   : AppColors.background,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               hasPlan
//                   ? Icons.workspace_premium_rounded
//                   : Icons.person_outline_rounded,
//               color: hasPlan ? AppColors.primaryColor : AppColors.textMuted,
//               size: 24,
//             ),
//           ),
//           SizedBox(width: 14.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'CURRENT PLAN',
//                   style: TextStyle(
//                     color: AppColors.textMuted,
//                     fontSize: 11.sp,
//                     letterSpacing: 1.2,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   controller.planLabel,
//                   style: TextStyle(
//                     color:
//                         hasPlan ? AppColors.primaryColor : AppColors.textWhite,
//                     fontSize: 19.sp,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 if (statusLine != null) ...[
//                   SizedBox(height: 4.h),
//                   Row(
//                     children: [
//                       Icon(
//                         controller.willRenew.value
//                             ? Icons.autorenew_rounded
//                             : Icons.schedule_rounded,
//                         size: 13,
//                         color: controller.willRenew.value
//                             ? AppColors.textSubtle
//                             : AppColors.error,
//                       ),
//                       SizedBox(width: 4.w),
//                       Text(
//                         statusLine,
//                         style: TextStyle(
//                           color: controller.willRenew.value
//                               ? AppColors.textSubtle
//                               : AppColors.error,
//                           fontSize: 12.5.sp,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ══════════════════════════════════════
//   //  Plan / Add-on Card
//   // ══════════════════════════════════════
//   Widget _buildPlanCard({
//     required String packageId,
//     required String title,
//     required IconData icon,
//     required List<String> features,
//     String? period,
//     String? badge,
//     bool highlighted = false,
//     String buttonLabel = 'Subscribe',
//   }) {
//     final package = controller.packages[packageId]!;
//     final price = package.storeProduct.priceString; // Play Console-এর price

//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.only(bottom: 14.h),
//       padding: EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: highlighted
//             ? AppColors.primaryColor.withOpacity(0.06)
//             : AppColors.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: highlighted ? AppColors.primaryColor : AppColors.cardBorder,
//           width: highlighted ? 1.5 : 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 42.w,
//                 height: 42.h,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF13233D),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, color: AppColors.goldLight, size: 22),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Flexible(
//                           child: Text(
//                             title,
//                             style: TextStyle(
//                               color: AppColors.textWhite,
//                               fontSize: 17.sp,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                         if (badge != null) ...[
//                           SizedBox(width: 8.w),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 3),
//                             decoration: BoxDecoration(
//                               color: AppColors.primaryColor,
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(
//                               badge,
//                               style: TextStyle(
//                                 color: AppColors.background,
//                                 fontSize: 10.sp,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                     SizedBox(height: 2.h),
//                     RichText(
//                       text: TextSpan(
//                         text: price,
//                         style: TextStyle(
//                           color: AppColors.primaryColor,
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w700,
//                         ),
//                         children: [
//                           if (period != null)
//                             TextSpan(
//                               text: ' $period',
//                               style: TextStyle(
//                                 color: AppColors.textMuted,
//                                 fontSize: 13.sp,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 14.h),
//           Container(height: 1, color: AppColors.cardBorder.withOpacity(0.5)),
//           SizedBox(height: 14.h),
//           ...features.map(
//             (f) => Padding(
//               padding: EdgeInsets.only(bottom: 8.h),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(Icons.check_circle_rounded,
//                       color: AppColors.primaryColor, size: 16),
//                   SizedBox(width: 8.w),
//                   Expanded(
//                     child: Text(
//                       f,
//                       style: TextStyle(
//                         color: AppColors.textSubtle,
//                         fontSize: 14.sp,
//                         height: 1.3,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 6.h),
//           _buildBuyButton(packageId, buttonLabel),
//         ],
//       ),
//     );
//   }

//   // ══════════════════════════════════════
//   //  Buy Button
//   //  ✅ শুধু যেই package কেনা হচ্ছে সেটাতেই spinner + solid color দেখাবে।
//   //  বাকি সব button একই bg color এ থাকবে, শুধু purchase চলাকালীন
//   //  হালকা fade করে tap ব্লক করবে — যাতে মনে না হয় সব button-এ click হয়েছে।
//   // ══════════════════════════════════════
//   Widget _buildBuyButton(String packageId, String label) {
//     return Obx(() {
//       final isCurrent = controller.isCurrentPlan(packageId);
//       final isThisLoading = controller.isPurchasing.value &&
//           controller.purchasingId.value == packageId;
//       // অন্য কোনো package কেনা চলছে, এইটা না
//       final isBlockedByOther = controller.isPurchasing.value && !isThisLoading;

//       // ── Current plan: আলাদা distinct outlined style, যাতে
//       // purchasing state-এর সাথে কখনো গুলিয়ে না যায় ──
//       if (isCurrent) {
//         return SizedBox(
//           width: double.infinity,
//           child: OutlinedButton(
//             style: OutlinedButton.styleFrom(
//               side: BorderSide(color: AppColors.primaryColor.withOpacity(0.5)),
//               padding: EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             onPressed: null,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.check_circle_rounded,
//                     color: AppColors.primaryColor, size: 18),
//                 SizedBox(width: 6.w),
//                 Text(
//                   'Current plan',
//                   style: TextStyle(
//                     color: AppColors.primaryColor,
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }

//       // ── এই package টাই কেনা হচ্ছে: normal solid color + spinner ──
//       if (isThisLoading) {
//         return SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryColor,
//               padding: EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             onPressed: null,
//             child: SizedBox(
//               height: 20,
//               width: 20,
//               child: CircularProgressIndicator(
//                 color: AppColors.background,
//                 strokeWidth: 2,
//               ),
//             ),
//           ),
//         );
//       }

//       // ── বাকি সব button: purchase চলাকালীন শুধু হালকা opacity দিয়ে
//       // tap ব্লক করা হবে, bg color একই থাকবে ──
//       return AnimatedOpacity(
//         duration: const Duration(milliseconds: 200),
//         opacity: isBlockedByOther ? 0.45 : 1,
//         child: IgnorePointer(
//           ignoring: isBlockedByOther,
//           child: SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryColor,
//                 padding: EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () => controller.buyAndGoHome(packageId),
//               child: Text(
//                 label,
//                 style: TextStyle(
//                   color: AppColors.background,
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   // ══════════════════════════════════════
//   //  Manage / Cancel / Restore
//   // ══════════════════════════════════════
//   Widget _buildManageSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Manage', icon: Icons.settings_rounded),
//         SizedBox(height: 14.h),

//         // Cancel — শুধু active subscription থাকলে
//         if (controller.hasActivePlan && controller.willRenew.value) ...[
//           GestureDetector(
//             onTap: _showCancelDialog,
//             child: Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(vertical: 14.h),
//               decoration: BoxDecoration(
//                 color: Color(0xFF1C0A0A),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                     color: AppColors.error.withOpacity(0.3), width: 1),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.cancel_outlined, color: AppColors.error, size: 20),
//                   SizedBox(width: 8.w),
//                   Text(
//                     'Cancel Subscription',
//                     style: TextStyle(
//                       color: AppColors.error,
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 12.h),
//         ],

//         // Restore
//         Obx(
//           () => GestureDetector(
//             onTap: controller.isRestoring.value
//                 ? null
//                 : controller.restorePurchases,
//             child: Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(vertical: 14.h),
//               decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: AppColors.cardBorder, width: 1.5),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (controller.isRestoring.value)
//                     SizedBox(
//                       height: 18,
//                       width: 18,
//                       child: CircularProgressIndicator(
//                         color: AppColors.textWhite,
//                         strokeWidth: 2,
//                       ),
//                     )
//                   else ...[
//                     Icon(Icons.restore_rounded,
//                         color: AppColors.textWhite, size: 20),
//                     SizedBox(width: 8.w),
//                     Text(
//                       'Restore Purchases',
//                       style: TextStyle(
//                         color: AppColors.textWhite,
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: 14.h),
//         Center(
//           child: Text(
//             'Subscriptions renew automatically until cancelled. '
//             'Manage or cancel anytime in Google Play.',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: AppColors.textMuted,
//               fontSize: 12.sp,
//               height: 1.4,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ══════════════════════════════════════
//   //  Cancel Dialog
//   // ══════════════════════════════════════
//   void _showCancelDialog() {
//     Get.dialog(
//       Dialog(
//         backgroundColor: AppColors.surface,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 56,
//                 height: 56,
//                 decoration: BoxDecoration(
//                   color: AppColors.error.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.cancel_outlined,
//                     color: AppColors.error, size: 28),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'Cancel Subscription?',
//                 style: TextStyle(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textWhite,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'You will be taken to Google Play to cancel. '
//                 'You keep your plan benefits until the end of the current billing period.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
//               ),
//               SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                         side: BorderSide(color: AppColors.cardBorder),
//                         padding: EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       onPressed: () => Get.back(),
//                       child: Text('Keep plan',
//                           style: TextStyle(color: AppColors.textWhite)),
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.error,
//                         padding: EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       onPressed: () {
//                         Get.back();
//                         controller.openCancelSubscription();
//                       },
//                       child: Text('Continue',
//                           style: TextStyle(color: AppColors.textWhite)),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       barrierDismissible: true,
//     );
//   }
// }


import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/subscription/controller/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionScreen extends StatelessWidget {
  final SubscriptionController controller = Get.put(SubscriptionController());

  SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              _buildHeader(),
              SizedBox(height: 20.h),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  if (controller.errorMessage.value != null &&
                      controller.packages.isEmpty) {
                    return _buildErrorState();
                  }

                  return RefreshIndicator(
                    color: AppColors.primaryColor,
                    backgroundColor: AppColors.surface,
                    onRefresh: controller.loadAll,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Free user-এর জন্য কোনো "Free Plan" card নেই,
                          // শুধু কোনো plan চালু থাকলে দেখাবে
                          if (controller.hasActivePlan) ...[
                            _buildCurrentPlanCard(),
                            SizedBox(height: 28.h),
                          ],

                          // ── One-time purchases (আগে) ──
                          if (controller.packages.containsKey(
                                  SubscriptionIds.scanSinglePackage) ||
                              controller.packages.containsKey(
                                  SubscriptionIds.pdfReportPackage)) ...[
                            _buildSectionTitle(
                              'oneTimePurchases'.tr,
                              subtitle: 'oneTimePurchasesSubtitle'.tr,
                              icon: Icons.bolt_rounded,
                            ),
                            SizedBox(height: 14.h),
                            if (controller.packages.containsKey(
                                SubscriptionIds.scanSinglePackage))
                              _buildPlanCard(
                                packageId: SubscriptionIds.scanSinglePackage,
                                title: 'singleScanTitle'.tr,
                                icon: Icons.document_scanner_rounded,
                                features: [
                                  'singleScanFeature1'.tr,
                                  'singleScanFeature2'.tr,
                                ],
                                buttonLabel: 'buyButtonLabel'.tr,
                              ),
                            if (controller.packages
                                .containsKey(SubscriptionIds.pdfReportPackage))
                              _buildPlanCard(
                                packageId: SubscriptionIds.pdfReportPackage,
                                title: 'pdfAddonTitle'.tr,
                                icon: Icons.picture_as_pdf_rounded,
                                features: [
                                  'pdfAddonFeature1'.tr,
                                  'pdfAddonFeature2'.tr,
                                ],
                                buttonLabel: 'buyButtonLabel'.tr,
                              ),
                            SizedBox(height: 24.h),
                          ],

                          // ── Subscription plans (পরে) ──
                          if (controller.packages.containsKey(
                                  SubscriptionIds.monthlyPackage) ||
                              controller.packages.containsKey(
                                  SubscriptionIds.unlimitedPackage)) ...[
                            _buildSectionTitle(
                              'subscriptionPlans'.tr,
                              subtitle: 'subscriptionPlansSubtitle'.tr,
                              icon: Icons.workspace_premium_rounded,
                            ),
                            SizedBox(height: 14.h),
                            if (controller.packages
                                .containsKey(SubscriptionIds.monthlyPackage))
                              _buildPlanCard(
                                packageId: SubscriptionIds.monthlyPackage,
                                title: 'monthlyPlanTitle'.tr,
                                icon: Icons.calendar_month_rounded,
                                period: 'perMonth'.tr,
                                features: [
                                  'monthlyFeature1'.tr,
                                  'monthlyFeature2'.tr,
                                  'cancelAnytime'.tr,
                                ],
                                buttonLabel: 'subscribeButtonLabel'.tr,
                              ),
                            if (controller.packages
                                .containsKey(SubscriptionIds.unlimitedPackage))
                              _buildPlanCard(
                                packageId: SubscriptionIds.unlimitedPackage,
                                title: 'unlimitedPlanTitle'.tr,
                                icon: Icons.all_inclusive_rounded,
                                period: 'perMonth'.tr,
                                highlighted: true,
                                badge: 'bestValueBadge'.tr,
                                features: [
                                  'unlimitedFeature1'.tr,
                                  'unlimitedFeature2'.tr,
                                  'cancelAnytime'.tr,
                                ],
                                buttonLabel: 'subscribeButtonLabel'.tr,
                              ),
                            SizedBox(height: 24.h),
                          ],

                          _buildManageSection(),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  //  Header
  // ══════════════════════════════════════
  Widget _buildHeader() {
    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textWhite, size: 18),
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          'subscriptionTitle'.tr,
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  /// সাধারণ সেকশন টাইটেল — icon ও subtitle সহ
  Widget _buildSectionTitle(String title, {String? subtitle, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.primaryColor, size: 18),
              SizedBox(width: 8.w),
            ],
            Text(
              title,
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12.5.sp,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }

  // ══════════════════════════════════════
  //  Error State
  // ══════════════════════════════════════
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_rounded, color: AppColors.textMuted, size: 48),
          SizedBox(height: 16.h),
          Text(
            controller.errorMessage.value ?? 'somethingWentWrong'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: controller.loadAll,
            child: Text(
              'tryAgainButton'.tr,
              style: TextStyle(
                color: AppColors.background,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════
  //  Current Plan Card
  // ══════════════════════════════════════
  Widget _buildCurrentPlanCard() {
    final hasPlan = controller.hasActivePlan;
    final expiry = controller.planExpiresAt.value;

    String? statusLine;
    if (hasPlan && expiry != null) {
      final date = controller.formatDate(expiry);
      // GetX trParams: json এ "renewsOn": "Renews on @date" আকারে থাকতে হবে
      statusLine = controller.willRenew.value
          ? 'renewsOn'.trParams({'date': date})
          : 'cancelledAccessUntil'.trParams({'date': date});
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: hasPlan
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2B2007), Color(0xFF1F1809)],
              )
            : null,
        color: hasPlan ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasPlan ? AppColors.primaryColor : AppColors.cardBorder,
          width: hasPlan ? 1.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46.w,
            height: 46.h,
            decoration: BoxDecoration(
              color: hasPlan
                  ? AppColors.primaryColor.withOpacity(0.15)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              hasPlan
                  ? Icons.workspace_premium_rounded
                  : Icons.person_outline_rounded,
              color: hasPlan ? AppColors.primaryColor : AppColors.textMuted,
              size: 24,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'currentPlanLabel'.tr,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11.sp,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  controller.planLabel, // controller থেকে আসে, এখন translated
                  style: TextStyle(
                    color:
                        hasPlan ? AppColors.primaryColor : AppColors.textWhite,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (statusLine != null) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        controller.willRenew.value
                            ? Icons.autorenew_rounded
                            : Icons.schedule_rounded,
                        size: 13,
                        color: controller.willRenew.value
                            ? AppColors.textSubtle
                            : AppColors.error,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        statusLine,
                        style: TextStyle(
                          color: controller.willRenew.value
                              ? AppColors.textSubtle
                              : AppColors.error,
                          fontSize: 12.5.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════
  //  Plan / Add-on Card
  // ══════════════════════════════════════
  Widget _buildPlanCard({
    required String packageId,
    required String title,
    required IconData icon,
    required List<String> features,
    String? period,
    String? badge,
    bool highlighted = false,
    required String buttonLabel,
  }) {
    final package = controller.packages[packageId]!;
    final price = package.storeProduct.priceString; // Play Console-এর price

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.primaryColor.withOpacity(0.06)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted ? AppColors.primaryColor : AppColors.cardBorder,
          width: highlighted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.h,
                decoration: BoxDecoration(
                  color: Color(0xFF13233D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.goldLight, size: 22),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: AppColors.textWhite,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (badge != null) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                color: AppColors.background,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 2.h),
                    RichText(
                      text: TextSpan(
                        text: price,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          if (period != null)
                            TextSpan(
                              text: ' $period',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(height: 1, color: AppColors.cardBorder.withOpacity(0.5)),
          SizedBox(height: 14.h),
          ...features.map(
            (f) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: AppColors.primaryColor, size: 16),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      f,
                      style: TextStyle(
                        color: AppColors.textSubtle,
                        fontSize: 14.sp,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 6.h),
          _buildBuyButton(packageId, buttonLabel),
        ],
      ),
    );
  }

  // ══════════════════════════════════════
  //  Buy Button
  //  ✅ শুধু যেই package কেনা হচ্ছে সেটাতেই spinner + solid color দেখাবে।
  //  বাকি সব button একই bg color এ থাকবে, শুধু purchase চলাকালীন
  //  হালকা fade করে tap ব্লক করবে — যাতে মনে না হয় সব button-এ click হয়েছে।
  // ══════════════════════════════════════
  Widget _buildBuyButton(String packageId, String label) {
    return Obx(() {
      final isCurrent = controller.isCurrentPlan(packageId);
      final isThisLoading = controller.isPurchasing.value &&
          controller.purchasingId.value == packageId;
      // অন্য কোনো package কেনা চলছে, এইটা না
      final isBlockedByOther = controller.isPurchasing.value && !isThisLoading;

      // ── Current plan: আলাদা distinct outlined style, যাতে
      // purchasing state-এর সাথে কখনো গুলিয়ে না যায় ──
      if (isCurrent) {
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primaryColor.withOpacity(0.5)),
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded,
                    color: AppColors.primaryColor, size: 18),
                SizedBox(width: 6.w),
                Text(
                  'currentPlanButton'.tr,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // ── এই package টাই কেনা হচ্ছে: normal solid color + spinner ──
      if (isThisLoading) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: null,
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: AppColors.background,
                strokeWidth: 2,
              ),
            ),
          ),
        );
      }

      // ── বাকি সব button: purchase চলাকালীন শুধু হালকা opacity দিয়ে
      // tap ব্লক করা হবে, bg color একই থাকবে ──
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isBlockedByOther ? 0.45 : 1,
        child: IgnorePointer(
          ignoring: isBlockedByOther,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => controller.buyAndGoHome(packageId),
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  // ══════════════════════════════════════
  //  Manage / Cancel / Restore
  // ══════════════════════════════════════
  Widget _buildManageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('manageSectionTitle'.tr,
            icon: Icons.settings_rounded),
        SizedBox(height: 14.h),

        // Cancel — শুধু active subscription থাকলে
        if (controller.hasActivePlan && controller.willRenew.value) ...[
          GestureDetector(
            onTap: _showCancelDialog,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: Color(0xFF1C0A0A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.error.withOpacity(0.3), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cancel_outlined, color: AppColors.error, size: 20),
                  SizedBox(width: 8.w),
                  Text(
                    'cancelSubscriptionButton'.tr,
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],

        // Restore
        Obx(
          () => GestureDetector(
            onTap: controller.isRestoring.value
                ? null
                : controller.restorePurchases,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.isRestoring.value)
                    SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        color: AppColors.textWhite,
                        strokeWidth: 2,
                      ),
                    )
                  else ...[
                    Icon(Icons.restore_rounded,
                        color: AppColors.textWhite, size: 20),
                    SizedBox(width: 8.w),
                    Text(
                      'restorePurchasesButton'.tr,
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 14.h),
        Center(
          child: Text(
            'subscriptionFooterNote'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════
  //  Cancel Dialog
  // ══════════════════════════════════════
  void _showCancelDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.cancel_outlined,
                    color: AppColors.error, size: 28),
              ),
              SizedBox(height: 20),
              Text(
                'cancelSubDialogTitle'.tr,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'cancelSubDialogBody'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.cardBorder),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: Text('keepPlanButton'.tr,
                          style: TextStyle(color: AppColors.textWhite)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        controller.openCancelSubscription();
                      },
                      // ℹ️ তোমার forgot-password flow-এ আগে থেকেই থাকা
                      // 'continue' key reuse করা হয়েছে, নতুন key বানানো হয়নি
                      child: Text('continue'.tr,
                          style: TextStyle(color: AppColors.textWhite)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}