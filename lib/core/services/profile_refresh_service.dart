// lib/core/services/profile_refresh_service.dart

import 'package:clause_verify/core/services/auth_service.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/core/utils/timezone_helper.dart';
import 'package:clause_verify/features/home/controllers/home_controller.dart';
import 'package:clause_verify/features/home/model/home_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// User-এর profile + plan limit আবার fetch করে AuthService cache + HomeController
/// দুটোতেই আপডেট করে।
///
/// কোথায় ব্যবহার করবে:
///   ✅ Upload API response-এর পরে (scan credit কমেছে বা free_rejections বদলেছে)
///   ✅ Purchase success-এর পরে
///   ✅ App resume-এর সময়
///
/// এই service কোনো UI ব্লক করে না — fire-and-forget। শুধু cache + Rx আপডেট করে,
/// সব screen এরপর updated ডেটা পাবে (Home UI Obx দিয়ে rebuild হবে, modal
/// নতুন করে খুললে fresh count পাবে)।
///
/// ব্যবহার:
///   await ProfileRefreshService.refresh();      // wait করতে চাইলে
///   ProfileRefreshService.refresh();             // fire-and-forget
class ProfileRefreshService {
  ProfileRefreshService._();

  /// Backend থেকে profile fetch করে AuthService cache + HomeController Rx
  /// দুটোতেই save করে। success হলে true ফেরত দেয়।
  static Future<bool> refresh() async {
    try {
      final timezone = await getUserTimezone();

      final response = await NetworkCaller().getRequest(
        Endpoints.userProfile,
        token: AuthService.token,
        headers: {'X-Timezone': timezone},
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData as Map<String, dynamic>;

        // ✅ ১. AuthService cache আপডেট (synchronous in-memory cache)
        await AuthService.saveUserData(
          (data['user_data'] as Map<String, dynamic>?) ?? {},
        );
        await AuthService.saveUserPlanLimit(
          (data['user_plan_limit'] as Map<String, dynamic>?) ?? {},
        );

        // ✅ ২. HomeController.home.value (Rx) আপডেট করো যদি registered থাকে।
        // এতে HomeScreen UI Obx দিয়ে rebuild হবে এবং CountryConfirmationModal
        // নতুন করে খুললে fresh count পাবে।
        if (Get.isRegistered<HomeController>()) {
          try {
            final home = Get.find<HomeController>();
            home.home.value = HomeModel.fromLocal(
              AuthService.userData,
              AuthService.userPlanLimit,
            );
          } catch (e) {
            debugPrint('⚠️ HomeController update skipped: $e');
          }
        }

        debugPrint('✅ ProfileRefreshService: profile + plan limit updated '
            '(AuthService cache + HomeController Rx)');
        return true;
      }

      debugPrint(
          '⚠️ ProfileRefreshService: fetch failed (${response.statusCode})');
      return false;
    } catch (e) {
      debugPrint('❌ ProfileRefreshService error: $e');
      return false;
    }
  }
}
