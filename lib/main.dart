import 'package:flutter/material.dart';
import 'package:flutter_extension/core/services/auth_service.dart';
import 'package:flutter_extension/core/services/watch_image_services.dart';
import 'package:flutter_extension/features/pricing/controller/subscription_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_extension/app.dart';
import 'package:flutter_extension/core/localization/localization_controller.dart';
import 'package:flutter_extension/core/localization/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_extension/firebase_options.dart'; // ✅ নতুন import যোগ করা হয়েছে

void main() async {
  // ✅ Async operation এর জন্য এটা লাগবে......
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ DefaultFirebaseOptions.currentPlatform যোগ করা হয়েছে
  // এটা automatically বুঝবে Android নাকি iOS, সেই অনুযায়ী config নেবে
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // token shoho shob data jeno properly store hoye theka
  await AuthService.init();
  
  // ✅ SharedPreferences initialize করো
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // ✅ Translation files load করো
  await Messages.loadTranslations();
  Get.put(WatchImagesService(), permanent: true);
  
  // ✅ LocalizationController globally initialize করো
  Get.put(LocalizationController(sharedPreferences: sharedPreferences));

  // ✅ ADD THIS (Subscription Controller global)
  Get.put(SubscriptionController(), permanent: true);
  
  runApp(const MyApp());
}