import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

/*
================================================================================
APP DEVICE UTILITY CLASS
================================================================================
এই ক্লাসটি Flutter অ্যাপ্লিকেশনের বিভিন্ন ডিভাইস-সম্পর্কিত ইউটিলিটি ফাংশন প্রদান করে।
এটি হ্যান্ডেল করে:
- কীবোর্ড ম্যানেজমেন্ট
- স্ক্রীন ওরিয়েন্টেশন
- স্ট্যাটাস/নেভিগেশন বার কন্ট্রোল
- ডিভাইস ইনফরমেশন
- নেটওয়ার্ক কানেকশন চেক
- URL লঞ্চিং
- ভাইব্রেশন ইফেক্ট
================================================================================
*/

class AppDeviceUtility {
  /// কীবোর্ড লুকানো (Hide Keyboard)
  /// [context]: বিল্ড কনটেক্সট
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// স্ট্যাটাস বার কালার সেট করা
  /// [color]: সেট করার জন্য রং
  static Future<void> setStatusBarColor(Color color) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color),
    );
  }

  /// ল্যান্ডস্কেপ ওরিয়েন্টেশন চেক করা
  /// [context]: বিল্ড কনটেক্সট
  /// রিটার্ন: true যদি ল্যান্ডস্কেপ মোডে থাকে
  static bool isLandscapeOrientation(BuildContext context) {
    final viewInsets = View.of(context).viewInsets;
    return viewInsets.bottom == 0;
  }

  /// পোর্ট্রেট ওরিয়েন্টেশন চেক করা
  /// [context]: বিল্ড কনটেক্সট
  /// রিটার্ন: true যদি পোর্ট্রেট মোডে থাকে
  static bool isPortraitOrientation(BuildContext context) {
    final viewInsets = View.of(context).viewInsets;
    return viewInsets.bottom != 0;
  }

  /// ফুলস্ক্রীন মোড সেট করা
  /// [enable]: true = ফুলস্ক্রীন সক্ষম, false = নরমাল মোড
  static void setFullScreen(bool enable) {
    SystemChrome.setEnabledSystemUIMode(
      enable ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
  }

  /// স্ক্রীন উচ্চতা পাওয়া (GetX কনটেক্সট ব্যবহার করে)
  /// রিটার্ন: স্ক্রীনের উচ্চতা (পিক্সেলে)
  static double getScreenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  /// স্ক্রীন প্রস্থ পাওয়া
  /// [context]: বিল্ড কনটেক্সট
  /// রিটার্ন: স্ক্রীনের প্রস্থ (পিক্সেলে)
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// ডিভাইস পিক্সেল রেশিও পাওয়া
  /// রিটার্ন: ডিভাইসের পিক্সেল ঘনত্ব
  static double getPixelRatio() {
    return MediaQuery.of(Get.context!).devicePixelRatio;
  }

  /// স্ট্যাটাস বার উচ্চতা পাওয়া
  /// রিটার্ন: স্ট্যাটাস বারের উচ্চতা (পিক্সেলে)
  static double getStatusBarHeight() {
    return MediaQuery.of(Get.context!).padding.top;
  }

  /// বটম নেভিগেশন বার উচ্চতা পাওয়া
  /// রিটার্ন: স্ট্যান্ডার্ড বটম নেভিগেশন বার উচ্চতা
  static double getBottomNavigationBarHeight() {
    return kBottomNavigationBarHeight;
  }

  /// অ্যাপ বার উচ্চতা পাওয়া
  /// রিটার্ন: স্ট্যান্ডার্ড অ্যাপ বার উচ্চতা
  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  /// কীবোর্ড উচ্চতা পাওয়া
  /// রিটার্ন: বর্তমান কীবোর্ডের উচ্চতা (পিক্সেলে)
  static double getKeyboardHeight() {
    final viewInsets = MediaQuery.of(Get.context!).viewInsets;
    return viewInsets.bottom;
  }

  /// কীবোর্ড দৃশ্যমান কিনা চেক করা
  /// রিটার্ন: true যদি কীবোর্ড দৃশ্যমান থাকে
  static Future<bool> isKeyboardVisible() async {
    final viewInsets = View.of(Get.context!).viewInsets;
    return viewInsets.bottom > 0;
  }

  /// ফিজিক্যাল ডিভাইস কিনা চেক করা
  /// রিটার্ন: true যদি ফিজিক্যাল ডিভাইস হয় (Android/iOS)
  static Future<bool> isPhysicalDevice() async {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// ডিভাইস ভাইব্রেট করা
  /// [duration]: ভাইব্রেশনের সময়কাল
  static void vibrate(Duration duration) {
    HapticFeedback.vibrate();
    Future.delayed(duration, () => HapticFeedback.vibrate());
  }

  /// প্রেফার্ড স্ক্রীন ওরিয়েন্টেশন সেট করা
  /// [orientations]: অনুমোদিত ওরিয়েন্টেশনের লিস্ট
  static Future<void> setPreferredOrientations(
    List<DeviceOrientation> orientations,
  ) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }

  /// স্ট্যাটাস বার লুকানো
  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
  }

  /// স্ট্যাটাস বার দেখানো
  static void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  /// ইন্টারনেট কানেকশন চেক করা
  /// রিটার্ন: true যদি ইন্টারনেট কানেকশন থাকে
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// iOS ডিভাইস কিনা চেক করা
  /// রিটার্ন: true যদি iOS ডিভাইস হয়
  static bool isIOS() {
    return Platform.isIOS;
  }

  /// Android ডিভাইস কিনা চেক করা
  /// রিটার্ন: true যদি Android ডিভাইস হয়
  static bool isAndroid() {
    return Platform.isAndroid;
  }

  /// URL লঞ্চ করা (ব্রাউজার/অ্যাপে ওপেন করা)
  /// [url]: লঞ্চ করার URL স্ট্রিং
  static void launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}