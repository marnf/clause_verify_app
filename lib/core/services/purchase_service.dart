import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';


/// Path: lib/core/services/purchase_service.dart
class PurchaseService {
  PurchaseService._();


  //  public key
  static const String _androidApiKey = 'goog_PihPipXddvfxnJkoDEgDJneLlUz';

  // iOS
  static const String _iosApiKey = 'appl_zPdOJJCYyIMMHdgldCoGTFlycJV';

  static bool _isConfigured = false;
  static String? _loggedInUserId;

  static bool get isConfigured => _isConfigured;

  /// main() এ runApp() এর আগে একবার call করবে
  static Future<void> init() async {
    if (_isConfigured) return;

    final String apiKey = Platform.isAndroid ? _androidApiKey : _iosApiKey;
    if (apiKey.isEmpty) {
      print('⚠️ PurchaseService: API key নেই, RevenueCat configure হয়নি');
      return;
    }

    try {
      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      }
      await Purchases.configure(PurchasesConfiguration(apiKey));
      _isConfigured = true;
      print('✅ RevenueCat configured');
    } catch (e) {
      print('❌ RevenueCat configure error: $e');
    }
  }

  /// Login সফল হওয়ার পর (এবং app খুলে saved session পেলে) call করবে।
  /// [userId] অবশ্যই সেই ID হবে যেটা backend user-এর identifier হিসেবে রাখে
  /// (Firebase UID) — webhook-এ এই ID-ই `app_user_id` হয়ে আসবে।
  static Future<void> login(String userId) async {
    if (!_isConfigured || userId.isEmpty) return;
    if (_loggedInUserId == userId) return; // আবার login করার দরকার নেই

    try {
      await Purchases.logIn(userId);
      _loggedInUserId = userId;
      print('✅ RevenueCat logIn: $userId');
    } catch (e) {
      print('❌ RevenueCat logIn error: $e');
    }
  }

  /// Logout / delete account-এ call করবে
  static Future<void> logout() async {
    if (!_isConfigured) return;

    try {
      // anonymous user-এ logOut করলে error দেয়, তাই আগে check
      if (!await Purchases.isAnonymous) {
        await Purchases.logOut();
      }
      _loggedInUserId = null;
      print('✅ RevenueCat logOut');
    } catch (e) {
      print('❌ RevenueCat logOut error: $e');
    }
  }
}