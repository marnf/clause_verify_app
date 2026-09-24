import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:clause_verify/features/subscription/controller/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Path: lib/features/subscription/widgets/pdf_purchase_sheet.dart
///
/// Scan result পেজে PDF button lock থাকলে, সেখান থেকে `pdf_report`
/// one-time purchase করার ছোট bottom sheet।
///
/// ব্যবহার:
///   final purchased = await PdfPurchaseSheet.show();
///   if (purchased) { /* PDF unlock/download করো */ }
class PdfPurchaseSheet {
  PdfPurchaseSheet._();

  /// Purchase সফল হলে `true` ফেরত দেয়। PDF credit backend-এ webhook দিয়ে যোগ হয়,
  /// এতে কয়েক সেকেন্ড লাগতে পারে।
  static Future<bool> show() async {
    // SubscriptionController আগে থেকে না থাকলে এখানে বানাই,
    // আর কাজ শেষে নিজে বানালে নিজেই delete করি (stale data এড়াতে)।
    final bool created = !Get.isRegistered<SubscriptionController>();
    final controller = created
        ? Get.put(SubscriptionController())
        : Get.find<SubscriptionController>();

    try {
      final result = await Get.bottomSheet<bool>(
        _PdfPurchaseSheetContent(controller: controller),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
      final purchased = result ?? false;
      if (purchased) {
        Get.snackbar(
          'Purchase successful',
          'Your PDF report is being unlocked.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
      return purchased;
    } finally {
      if (created && Get.isRegistered<SubscriptionController>()) {
        Get.delete<SubscriptionController>();
      }
    }
  }
}

class _PdfPurchaseSheetContent extends StatelessWidget {
  final SubscriptionController controller;

  const _PdfPurchaseSheetContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          final package =
              controller.packages[SubscriptionIds.pdfReportPackage];
          final isBuying = controller.isPurchasing.value &&
              controller.purchasingId.value ==
                  SubscriptionIds.pdfReportPackage;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Color(0xFF13233D),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.picture_as_pdf_rounded,
                    color: AppColors.goldLight, size: 28),
              ),
              SizedBox(height: 16.h),
              Text(
                'Unlock PDF Report',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Download the full analysis of this contract as a PDF. '
                'The text result stays free.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
              ),
              SizedBox(height: 24.h),

              if (controller.isLoading.value)
                CircularProgressIndicator(color: AppColors.primaryColor)
              else if (package == null)
                Text(
                  'This option is not available right now. Please try again later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.error, fontSize: 14.sp),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      disabledBackgroundColor:
                          AppColors.primaryColor.withOpacity(0.35),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: controller.isPurchasing.value
                        ? null
                        : () => _onBuy(context),
                    child: isBuying
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.background,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Buy PDF Report — ${package.storeProduct.priceString}',
                            style: TextStyle(
                              color: AppColors.background,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

              SizedBox(height: 8.h),
              TextButton(
                onPressed: controller.isPurchasing.value
                    ? null
                    : () => Navigator.of(context).pop(false),
                child: Text(
                  'Not now',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _onBuy(BuildContext context) async {
    final ok = await controller.buy(SubscriptionIds.pdfReportPackage);

    // কেনা সফল হলে sheet বন্ধ করে `true` ফেরত দাও
    if (ok && context.mounted) {
      Navigator.of(context).pop(true);
    }
  }
}