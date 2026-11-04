import 'package:clause_verify/core/services/auth_service.dart';
import 'package:clause_verify/core/utils/backend_message_translator.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/app_sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// "not_a_contract" response-এর UI handle (popup + banner)।
/// Warning-এর storage পুরোটা AuthService-এ।
class ScanWarningService {
  ScanWarningService._();

  static bool _popupOpen = false;

  /// AuthService.init() app শুরুতেই warning load করে ফেলে,
  /// তাই এখানে আলাদা কিছু করার নেই। Controller-এর পুরোনো call যেন না ভাঙে
  /// সেজন্য method-টা রাখা হলো।
  static Future<void> load() async {
    await AuthService.init();
  }

  static Future<void> clear() => AuthService.clearScanWarning();

  /// code == 'not_a_contract' হলে call করো (HTTP 200 বা error, দুই ক্ষেত্রেই)
  ///
  /// Message এখন user-এর selected language-এ translate হয়ে দেখানো হয়
  /// (BackendMessageTranslator.translateNotAContract দেখুন)।
  static Future<void> handleNotAContract(Map<String, dynamic> data) async {
    // "Warning" (capital W) — safe থাকতে "warning" ও check করা হলো
    final warningText =
        (data['Warning'] ?? data['warning'] ?? '').toString().trim();

    // Warning থাকলে save, empty হলে আগেরটা remove
    await AuthService.saveScanWarning(warningText);

    // ✅ Backend message কে user-এর selected language-এ translate করো।
    // scan_deducted field দিয়ে সঠিক translation key বের করা হয়।
    final message = BackendMessageTranslator.translateNotAContract(data);

    _showMessagePopup(message);
  }

  /// OK বাটন চাপলে বন্ধ হবে — auto-dismiss নেই।
  static void _showMessagePopup(String message) {
    if (message.isEmpty || _popupOpen) return;
    _popupOpen = true;

    Get.dialog(
      PopScope(
        canPop: false, // back button দিয়ে বন্ধ হবে না
        child: Dialog(
          backgroundColor: AppColors.surface,
          insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.cardBorder, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Icon ──
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.description_outlined,
                      color: AppColors.error, size: 28.sp),
                ),
                SizedBox(height: 18.h),

                // ── Title ──
                Text(
                  'notAContractTitle'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),

                // ── Message (translated) ──
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13.sp,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),

                // ── OK button (full-width) ──
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.black,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: Text(
                      'ok'.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false, // বাইরে tap করে বন্ধ হবে না
    ).then((_) {
      _popupOpen = false;
    });
  }
}

/// Camera / Upload screen-এ বসানো banner
class ScanWarningBanner extends StatelessWidget {
  const ScanWarningBanner({Key? key}) : super(key: key);

  /// Backend থেকে আসা English warning text-কে user-এর selected language-এ
  /// convert করে। Match না করলে backend-এর original text-ই দেখায়।
  static String _localized(String raw) {
    final lower = raw.toLowerCase();

    // "The next non-contract document today will use a scan."
    if (lower.contains('next non-contract') && lower.contains('scan')) {
      return 'scanWarningNextNonContract'.tr;
    }

    return raw;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final text = AuthService.scanWarning.value;
      if (text.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppColors.warning.withOpacity(0.5), width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: AppColors.warning, size: 20.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  _localized(text),
                  style: TextStyle(
                    color: AppColors.warning,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}