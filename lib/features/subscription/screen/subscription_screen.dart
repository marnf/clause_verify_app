
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
                          if (controller.hasActivePlan) ...[
                            _buildCurrentPlanCard(),
                            SizedBox(height: 28.h),
                          ],

                          // ── One-time purchases ──
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
                                  'singleScanFeature3'.tr,
                                  'singleScanFeature4'.tr,
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

                          // ── Subscription plans ──
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
                                  'monthlyFeature3'.tr,
                                  'monthlyFeature4'.tr,
                                ],
                                buttonLabel: 'subscribeButtonLabel'.tr,
                              ),
                            if (controller.packages
                                .containsKey(SubscriptionIds.unlimitedPackage))
                              _buildPlanCard(
                                packageId: SubscriptionIds.unlimitedPackage,
                                title: 'unlimitedPlanTitle'.tr,
                                icon: Icons.workspace_premium_rounded,
                                period: 'perMonth'.tr,
                                highlighted: true,
                                badge: 'bestValueBadge'.tr,
                                features: [
                                  'unlimitedFeature1'.tr,
                                  'unlimitedFeature2'.tr,
                                  'unlimitedFeature3'.tr,
                                  'unlimitedFeature4'.tr,
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
                            color: AppColors.navy,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textWhite, size: 18.sp),
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

  Widget _buildSectionTitle(String title, {String? subtitle, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.primaryColor, size: 18.sp),
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

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_rounded, color: AppColors.textMuted, size: 48.sp),
          SizedBox(height: 16.h),
          Text(
            controller.errorMessage.value ?? 'genericErrorBody'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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

  Widget _buildCurrentPlanCard() {
    final hasPlan = controller.hasActivePlan;
    final expiry = controller.planExpiresAt.value;

    String? statusLine;
    if (hasPlan && expiry != null) {
      final date = controller.formatDate(expiry);
      statusLine = controller.willRenew.value
          ? 'renewsOn'.trParams({'date': date})
          : 'cancelledAccessUntil'.trParams({'date': date});
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: hasPlan
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.premiumCard, AppColors.surface],
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
              size: 24.sp,
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
                  controller.planLabel,
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
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Icon(
          controller.willRenew.value
              ? Icons.autorenew_rounded
              : Icons.schedule_rounded,
          size: 13.sp,
                   color: controller.willRenew.value
              ? AppColors.textMuted
              : AppColors.error,
        ),
      ),
      SizedBox(width: 4.w),
      Expanded(
        child: Text(
          statusLine,
          softWrap: true,
                    style: TextStyle(
            color: controller.willRenew.value
                ? AppColors.textMuted
                : AppColors.error,
            fontSize: 12.5.sp,
            height: 1.3,
          ),
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
    final price = package.storeProduct.priceString;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
                color: highlighted ? AppColors.premiumCard : AppColors.surface,
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
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 22.sp),
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
                            padding: const EdgeInsets.symmetric(
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
                                color: highlighted
                                    ? AppColors.cream
                                    : AppColors.textMuted,
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
          Container(height: 1.h, color: AppColors.cardBorder.withOpacity(0.5)),
          SizedBox(height: 14.h),
          ...features.map(
            (f) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: AppColors.primaryColor, size: 16.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                                        child: Text(
                      f,
                      style: TextStyle(
                        color: highlighted
                            ? AppColors.cream
                            : AppColors.textMuted,
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

  Widget _buildBuyButton(String packageId, String label) {
    return Obx(() {
      final isCurrent = controller.isCurrentPlan(packageId);
      final changeType = controller.planChangeType(packageId);
      final isThisLoading = controller.isPurchasing.value &&
          controller.purchasingId.value == packageId;
      final isBlockedByOther = controller.isPurchasing.value && !isThisLoading;

      if (isCurrent) {
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primaryColor.withOpacity(0.5)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded,
                    color: AppColors.primaryColor, size: 18.sp),
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

      if (isThisLoading) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: null,
            child: SizedBox(
              height: 20.h,
              width: 20.w,
              child: const CircularProgressIndicator(
                color: AppColors.background,
                strokeWidth: 2,
              ),
            ),
          ),
        );
      }

      // Active plan থাকলে অন্য subscription-এর label বদলে যাবে
      final effectiveLabel = changeType == PlanChangeType.upgrade
          ? 'upgradeButtonLabel'.tr
          : changeType == PlanChangeType.downgrade
              ? 'downgradeButtonLabel'.tr
              : label;

      return AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isBlockedByOther ? 0.45 : 1,
        child: IgnorePointer(
          ignoring: isBlockedByOther,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => controller.buyAndGoHome(packageId),
                  child: Text(
                    effectiveLabel,
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (changeType != null) ...[
                SizedBox(height: 8.h),
                Text(
                  changeType == PlanChangeType.upgrade
                      ? 'upgradeNote'.tr
                      : 'downgradeNote'.tr,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12.sp,
                    height: 1.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildManageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('manageSectionTitle'.tr,
            icon: Icons.settings_rounded),
        SizedBox(height: 14.h),

        if (controller.hasActivePlan && controller.willRenew.value) ...[
          GestureDetector(
            onTap: _showCancelDialog,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.error.withOpacity(0.3), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cancel_outlined, color: AppColors.error, size: 20.sp),
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
                      height: 18.h,
                      width: 18.w,
                      child: const CircularProgressIndicator(
                        color: AppColors.textWhite,
                        strokeWidth: 2,
                      ),
                    )
                  else ...[
                    Icon(Icons.restore_rounded,
                        color: AppColors.textWhite, size: 20.sp),
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

  void _showCancelDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.cancel_outlined,
                    color: AppColors.error, size: 28.sp),
              ),
              SizedBox(height: 20.h),
              Text(
                'cancelSubDialogTitle'.tr,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'cancelSubDialogBody'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.cardBorder),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: Text('keepPlanButton'.tr,
                          style: const TextStyle(color: AppColors.textWhite)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        controller.openCancelSubscription();
                      },
                      child: Text('continue'.tr,
                          style: const TextStyle(color: AppColors.textWhite)),
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