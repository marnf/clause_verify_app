import 'dart:convert';
import 'dart:io';

import 'package:clause_verify/core/services/auth_service.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/features/analysis/controller/analysis_result_controller.dart';
import 'package:clause_verify/features/analysis/model/analysis_result_model.dart';
import 'package:clause_verify/firebase_options.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

/// Background/terminated state-এর message এই function handle করে।
/// অবশ্যই top-level হতে হবে (class-এর ভেতরে না)।
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('🔔 Background message: ${message.messageId}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  /// false হলে app খোলা থাকলে push দেখাবে না,
  /// শুধু app বন্ধ বা background-এ থাকলে দেখাবে।
  static const bool _showWhenAppIsOpen = false;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Clause Verify notifications',
    importance: Importance.high,
  );

  bool _tokenListenerAttached = false;
  bool _isOpeningAnalysis = false;

  /// App বন্ধ অবস্থায় notification tap করে খুললে data এখানে জমা থাকে।
  Map<String, dynamic>? _pendingData;

  /// main()-এ Firebase.initializeApp()-এর পরে একবার call করো।
  /// (এখানে permission চাওয়া হয় না)
  Future<void> init() async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _local.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // iOS: app খোলা থাকলে system banner দেখাবে কিনা
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: _showWhenAppIsOpen,
      badge: _showWhenAppIsOpen,
      sound: _showWhenAppIsOpen,
    );

    // Foreground message
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Background থেকে notification tap করে app খুললে
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleTap(message.data);
    });

    // App পুরোপুরি বন্ধ ছিল, notification tap করে খুলেছে
    final initial = await _fcm.getInitialMessage();
    if (initial != null) {
      _pendingData = initial.data;
    }
  }

  // ───────────────────────── Token register ─────────────────────────

  /// Login সফল হলে, অথবা login করা অবস্থায় app খুললে call করো।
  /// Login না থাকলে কিছুই করে না।
  Future<void> registerForCurrentUser() async {
    if (!AuthService.isLoggedIn) return;

    try {
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('🔕 Notification permission denied');
        return;
      }

      // iOS-এ FCM token পাওয়ার আগে APNs token লাগে
      if (Platform.isIOS) {
        String? apns = await _fcm.getAPNSToken();
        int retry = 0;
        while (apns == null && retry < 20) {
          await Future.delayed(const Duration(milliseconds: 500));
          apns = await _fcm.getAPNSToken();
          retry++;
        }
      }

      final token = await _fcm.getToken();
      if (token != null) {
        await _sendTokenToBackend(token);
      }

      if (!_tokenListenerAttached) {
        _tokenListenerAttached = true;
        _fcm.onTokenRefresh.listen(_sendTokenToBackend);
      }
    } catch (e) {
      debugPrint('❌ FCM register error: $e');
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    if (!AuthService.isLoggedIn) return;

    final response = await NetworkCaller().postRequest(
      Endpoints.notificationDevices,
      body: {'token': token},
    );

    if (response.isSuccess) {
      debugPrint('✅ FCM token backend-এ register হয়েছে');
    } else {
      debugPrint('❌ FCM token register failed: ${response.errorMessage}');
    }
  }

  /// Logout-এর সময় call করো (token মুছে ফেলার আগে)।
  Future<void> unregisterFromBackend() async {
    try {
      await NetworkCaller().deleteRequest(
        Endpoints.notificationDevices,
        AuthService.token,
      );
    } catch (e) {
      debugPrint('⚠️ FCM unregister failed (continuing): $e');
    }
    try {
      // নতুন token তৈরি হবে, যাতে পুরনো token দিয়ে আর কিছু না আসে
      await _fcm.deleteToken();
    } catch (e) {
      debugPrint('⚠️ FCM deleteToken failed (continuing): $e');
    }
  }

  // ───────────────────────── Notification handling ─────────────────────────

  /// App বন্ধ থেকে খোলার পর, splash শেষ হলে এটা call করো।
  void consumePendingNavigation() {
    final data = _pendingData;
    _pendingData = null;
    if (data != null) _handleTap(data);
  }

  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('🔔 Foreground message: ${message.messageId}');
    if (!_showWhenAppIsOpen) return;

    final notification = message.notification;
    if (notification == null) return;

    // iOS-এ system নিজেই দেখায়, তাই শুধু Android-এ local notification দেখাই
    if (Platform.isAndroid) {
      _local.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      _handleTap(Map<String, dynamic>.from(jsonDecode(payload)));
    } catch (e) {
      debugPrint('❌ Payload parse error: $e');
    }
  }

  /// Notification tap করলে: analysis_id থাকলে সেই result screen খোলে।
  void _handleTap(Map<String, dynamic> data) {
    debugPrint('👉 Notification tapped: $data');

    final id =
        (data['analysis_id'] ?? data['scan_id'] ?? data['id'])?.toString();
    if (id != null && id.isNotEmpty) {
      _openAnalysis(id);
      return;
    }

    final route = data['route']?.toString();
    if (route != null && route.isNotEmpty) {
      Get.toNamed(route, arguments: data);
    }
  }

  /// Detail API থেকে পুরো result এনে result screen খোলে।
  Future<void> _openAnalysis(String id) async {
    if (!AuthService.isLoggedIn) return; // login ছাড়া খুলবে না
    if (_isOpeningAnalysis) return; // double tap থেকে রক্ষা
    _isOpeningAnalysis = true;

    bool dialogShown = false;
    try {
      Get.dialog(
        PopScope(
          canPop: false,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        ),
        barrierDismissible: false,
      );
      dialogShown = true;

      final response = await NetworkCaller().getRequest(
        '${Endpoints.fileAnalysis}$id/',
      );

      if (dialogShown && Get.isDialogOpen == true) Get.back();
      dialogShown = false;

      if (response.isSuccess && response.responseData != null) {
        final result = AnalysisResultModel.fromJson(response.responseData);

        // আগের controller মুছে দাও, যাতে binding নতুন করে বানায়
        try {
          Get.delete<AnalysisResultController>(force: true);
        } catch (_) {}

        Get.toNamed(AppRoute.analysisResultScreen, arguments: result);
      } else {
        Get.snackbar(
          'error'.tr,
          'failedToLoadAnalysisDetails'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.surface,
          colorText: AppColors.white,
        );
      }
    } catch (e) {
      debugPrint('❌ Open analysis from notification failed: $e');
      if (dialogShown && Get.isDialogOpen == true) Get.back();
    } finally {
      _isOpeningAnalysis = false;
    }
  }
}