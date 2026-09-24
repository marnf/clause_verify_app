import 'package:clause_verify/core/models/response_data.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaywallGuard {
  PaywallGuard._();

  /// Response-এর status 402 হলে dialog দেখায়, "View plans" চাপলে
  /// Subscription page খোলে। 402 হলে true ফেরত দেয়, না হলে false।
  static Future<bool> handle(ResponseData response) async {
    if (response.statusCode != 402) return false;

    final goToPlans = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        title: const Text(
          'Upgrade required',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'You have no scans left. Choose a plan to continue.',
          style: TextStyle(color: AppColors.textSubtle),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'Not now',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Get.back(result: true),
            child: const Text('View plans'),
          ),
        ],
      ),
      barrierDismissible: true,
    );

    if (goToPlans == true) {
      await Get.toNamed(AppRoute.subscriptionScreen);
    }
    return true;
  }
}