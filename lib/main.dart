// import 'package:flutter/material.dart';
// import 'package:clause_verify/core/services/auth_service.dart';
// import 'package:clause_verify/core/services/purchase_service.dart';
// import 'package:clause_verify/core/services/watch_image_services.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:clause_verify/app.dart';
// import 'package:clause_verify/core/localization/localization_controller.dart';
// import 'package:clause_verify/core/localization/messages.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:clause_verify/firebase_options.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:clause_verify/core/services/notification_service.dart';

// void main() async {
//   // ✅ Async operation এর জন্য এটা লাগবে
//   WidgetsFlutterBinding.ensureInitialized();

//   // ✅ DefaultFirebaseOptions.currentPlatform যোগ করা হয়েছে
//   // এটা automatically বুঝবে Android নাকি iOS, সেই অনুযায়ী config নেবে
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   // ✅ Push Notification setup (permission এখানে চাওয়া হয় না)
//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//   await NotificationService.instance.init();

//   // token shoho shob data jeno properly store hoye theka
//   await AuthService.init();

//   // ✅ RevenueCat configure করো (AuthService.init()-এর পরে)
//   await PurchaseService.init();

//   // ✅ আগে থেকে login করা user থাকলে RevenueCat-এও login করাও
//   await AuthService.syncPurchaseUser();

//   // ✅ আগে থেকে login করা user-এর token backend-ে পাঠাও
//   NotificationService.instance.registerForCurrentUser();

//   // ✅ SharedPreferences initialize করো
//   final sharedPreferences = await SharedPreferences.getInstance();

//   // ✅ Translation files load করো
//   await Messages.loadTranslations();
//   Get.put(WatchImagesService(), permanent: true);

//   // ✅ LocalizationController globally initialize করো
//   Get.put(LocalizationController(sharedPreferences: sharedPreferences));

//   // ❌ পুরনো SubscriptionController (features/pricing) এখান থেকে সরানো হয়েছে।
//   // নতুন SubscriptionController এখন SubscriptionScreen খোলার সময় নিজেই তৈরি হয়।

//   runApp(const MyApp());
// }






import 'package:flutter/material.dart';
import 'package:clause_verify/core/services/auth_service.dart';
import 'package:clause_verify/core/services/purchase_service.dart';
import 'package:clause_verify/core/services/watch_image_services.dart';
import 'package:clause_verify/core/services/notification_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clause_verify/app.dart';
import 'package:clause_verify/core/localization/localization_controller.dart';
import 'package:clause_verify/core/localization/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:clause_verify/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Push Notification setup (permission এখানে চাওয়া হয় না)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationService.instance.init();

  // token সহ সব data যেন properly store হয়ে থাকে
  await AuthService.init();

  // RevenueCat configure করো (AuthService.init()-এর পরে)
  await PurchaseService.init();

  // আগে থেকে login করা user থাকলে RevenueCat-এও login করাও
  await AuthService.syncPurchaseUser();

  // ✅ আগে থেকে login করা user-এর FCM token backend-এ পাঠাও
  NotificationService.instance.registerForCurrentUser();

  final sharedPreferences = await SharedPreferences.getInstance();

  await Messages.loadTranslations();
  Get.put(WatchImagesService(), permanent: true);

  Get.put(LocalizationController(sharedPreferences: sharedPreferences));

  runApp(const MyApp());
}