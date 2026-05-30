
import 'package:flutter_extension/core/localization/localization_controller.dart';
import 'package:flutter_extension/core/localization/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_extension/routes/app_routes.dart';
import 'core/utils/constants/app_sizer.dart';
import 'core/utils/constants/app_sizes.dart';
import 'core/utils/theme/theme.dart';

class PlatformUtils {
  static bool get isIOS =>
      foundation.defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isAndroid =>
      foundation.defaultTargetPlatform == TargetPlatform.android;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return Sizer(
      builder: (context, orientation, deviceType) {
        // ✅ GetBuilder দিয়ে wrap করো
        return GetBuilder<LocalizationController>(
          builder: (localizationController) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.system,
              theme: _getLightTheme(),
              darkTheme: _getDarkTheme(),

              // ✅ Localization setup
              locale: localizationController.locale,
              fallbackLocale: const Locale('en', 'US'),
              translations: Messages(),

              defaultTransition: PlatformUtils.isIOS
                  ? Transition.cupertino
                  : Transition.fade,

              builder: (context, child) => PlatformUtils.isIOS
                  ? CupertinoTheme(
                      data: const CupertinoThemeData(), child: child!)
                  : child!,

              initialRoute: AppRoute.splashScreen,
              getPages: AppRoute.routes,
            );
          },
        );
      },
    );
  }

  ThemeData _getLightTheme() {
    return PlatformUtils.isIOS
        ? AppTheme.lightTheme.copyWith(platform: TargetPlatform.iOS)
        : AppTheme.lightTheme;
  }

  ThemeData _getDarkTheme() {
    return PlatformUtils.isIOS
        ? AppTheme.darkTheme.copyWith(platform: TargetPlatform.iOS)
        : AppTheme.darkTheme;
  }
}