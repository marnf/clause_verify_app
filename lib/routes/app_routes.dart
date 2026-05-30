import 'package:flutter_extension/features/analysis/controller/ai_analysis_controller.dart';
import 'package:flutter_extension/features/auth/controller/email_verification_controller.dart';
import 'package:flutter_extension/features/auth/controller/login_controller.dart';
import 'package:flutter_extension/features/auth/controller/registration_controller.dart';
import 'package:flutter_extension/features/auth/controller/reset_password_controller.dart';
import 'package:flutter_extension/features/auth/screen/email_verification_screen.dart';
import 'package:flutter_extension/features/auth/screen/otp_verification_screen_for_registration.dart';
import 'package:flutter_extension/features/auth/screen/reset_password_screen.dart';
import 'package:flutter_extension/features/camera/screens/camera_screen.dart';
import 'package:flutter_extension/features/history/controller/history_controller.dart';
import 'package:flutter_extension/features/history/screen/history_preview.dart';
import 'package:flutter_extension/features/home/controllers/accessories_controller.dart';
import 'package:flutter_extension/features/home/controllers/home_controller.dart';
import 'package:flutter_extension/features/home/controllers/watch_capture_controller.dart';
import 'package:flutter_extension/features/home/presentaion/screens/accessories_screen.dart';
import 'package:flutter_extension/features/home/presentaion/screens/photo_instructions_screen.dart';
import 'package:flutter_extension/features/home/presentaion/screens/watch_capture_screen.dart';
import 'package:flutter_extension/features/nav_bar/controllers/nav_bar_controller.dart';
import 'package:flutter_extension/features/onboarding/controller/onboarding_controller.dart';
import 'package:flutter_extension/features/price_estimation/controller/price_estimation_controller.dart';
import 'package:flutter_extension/features/pricing/controller/subscription_controller.dart';
import 'package:flutter_extension/features/pricing/screen/subscription_screen.dart';
import 'package:flutter_extension/features/profile/controller/profile_controller.dart';
import 'package:flutter_extension/features/profile/screen/help_faq_screen.dart';
import 'package:flutter_extension/features/profile/screen/privacy_policy_screen.dart';
import 'package:flutter_extension/features/profile/screen/terms_of_use_screen.dart';
import 'package:flutter_extension/features/splash/controller/splash_controller.dart';
import 'package:flutter_extension/features/upload/screens/upload_screen.dart';
import 'package:get/get.dart';

// Home & Others
import '../features/home/presentaion/screens/home_screen.dart';
import '../features/nav_bar/presentation/screens/nav_bar.dart';

// Onboarding
import '../features/onboarding/screen/onboarding_screen.dart';

// Auth
import '../features/auth/screen/login_screen.dart';
import '../features/auth/screen/registration_screen.dart';
import '../features/auth/screen/terms_and_condition.dart';
import '../features/auth/screen/otp_verification_screen.dart';

// Splash
import '../features/splash/view/splash_screen.dart';

// Pricing

// Analysis
import '../features/analysis/screen/ai_analysis_screen.dart';
import '../features/analysis/screen/analysis_complete_screen.dart';
import '../features/price_estimation/screen/price_estimation_screen.dart';

// Profile
import '../features/profile/screen/profile_screen.dart';

// PDF
import '../features/pdf/screen/report_webview_screen.dart';

class AppRoute {
  // ----------------- Route Names -----------------
  static String init = "/";
  static String splashScreen = "/splashScreen";
  static String onboardingScreen = "/onboardingScreen";
  static String loginScreen = "/loginScreen";
  static String registrationScreen = "/registrationScreen";
  static String termsAndCondition = "/termsAndCondition";
  static String otpVerificationScreen = "/otpVerificationScreen";
  static String otpVerificationScreenForRegistraion =
      "/otpVerificationScreenForRegistraion";
  static String emailVerificationScreen = "/emailVerificationScreen";
  static String resetPasswordScreen = "/resetPasswordScreen";
  static String homeScreen = "/homeScreen";
  static String navBar = "/navBar";
  static String photoInstructionsScreen = "/photoInstructionsScreen";
  static String watchCaptureScreen = "/watchCaptureScreen";
  static String accessoriesScreen = "/accessoriesScreen";

  static String subscriptionScreen = "/subscriptionScreen";
  static String aiAnalysisScreen = "/aiAnalysisScreen";
  static String analysisCompleteScreen = "/analysisCompleteScreen";
  static String priceEstimationScreen = "/priceEstimationScreen";
  static String profileScreen = "/profileScreen";
  static String reportWebViewScreen = "/reportWebViewScreen";
  static String historyPreview = "/historyPreview";
  static String helpFaqScreen = "/helpFaqScreen";
  static String privacyPolicyScreen = "/privacyPolicyScreen";
  static String termsOfUseScreen = "/termsOfUseScreen";

  static const String uploadScreen = '/upload-screen';
  static const String cameraScreen = '/camera-screen';

  // ----------------- Route List -----------------
  // static List<GetPage> routes = [
  //   // Splash & Onboarding
  //   GetPage(name: splashScreen, page: () => SplashScreen()),
  //   GetPage(name: onboardingScreen, page: () => OnboardingScreen()),

  //   // Auth Section
  //   GetPage(name: loginScreen, page: () => LoginScreen()),
  //   GetPage(name: registrationScreen, page: () => RegistrationScreen()),
  //   GetPage(name: termsAndCondition, page: () => TermsAndCondition()),
  //   GetPage(name: otpVerificationScreen, page: () => OtpVerificationScreen()),
  //   GetPage(
  //     name: otpVerificationScreenForRegistraion,
  //     page: () => OtpVerificationScreenForRegistration(),
  //   ),
  //   GetPage(
  //     name: emailVerificationScreen,
  //     page: () => EmailVerificationScreen(),
  //   ),
  //   GetPage(name: resetPasswordScreen, page: () => ResetPasswordScreen()),

  //   // Main Section
  //   GetPage(name: homeScreen, page: () => HomeScreen()),
  //   GetPage(name: navBar, page: () => NavBar()),

  //   // Pricing Section
  //   GetPage(
  //     name: subscriptionScreen,
  //     page: () => SubscriptionScreen(),
  //   ),

  //   // Analysis Section
  //   GetPage(
  //     name: photoInstructionsScreen,
  //     page: () => PhotoInstructionsScreen(),
  //   ),
  //   GetPage(name: watchCaptureScreen, page: () => WatchCaptureScreen()),
  //   GetPage(name: accessoriesScreen, page: () => AccessoriesScreen()),
  //   GetPage(name: aiAnalysisScreen, page: () => AiAnalysisScreen()),
  //   GetPage(name: analysisCompleteScreen, page: () => AnalysisCompleteScreen()),
  //   GetPage(name: priceEstimationScreen, page: () => PriceEstimationScreen()),

  //   // Profile & Reports
  //   GetPage(name: profileScreen, page: () => ProfileScreen()),
  //   GetPage(name: reportWebViewScreen, page: () => ReportWebViewScreen()),
  //   GetPage(name: historyPreview, page: () => HistoryPreview()),
  // ];

  static List<GetPage> routes = [
    // Splash & Onboarding
    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SplashController());
      }),
    ),
    GetPage(
      name: onboardingScreen,
      page: () => OnboardingScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => OnboardingController());
      }),
    ),

    // Auth Section
    GetPage(
      name: loginScreen,
      page: () => LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LoginController());
        Get.lazyPut(() => LoginController(), fenix: true);
      }),
    ),
    GetPage(
      name: registrationScreen,
      page: () => RegistrationScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => RegistrationController());
        Get.lazyPut(() => LoginController(), fenix: true);
      }),
    ),
    GetPage(name: termsAndCondition, page: () => TermsAndCondition()),
    GetPage(name: otpVerificationScreen, page: () => OtpVerificationScreen()),
    GetPage(
      name: otpVerificationScreenForRegistraion,
      page: () => OtpVerificationScreenForRegistration(),
    ),
    GetPage(
      name: emailVerificationScreen,
      page: () => EmailVerificationScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => EmailVerificationController());
        Get.lazyPut(() => LoginController(), fenix: true);
      }),
    ),
    GetPage(
      name: resetPasswordScreen,
      page: () => ResetPasswordScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ResetPasswordController());
        Get.lazyPut(() => LoginController(), fenix: true);
      }),
    ),

    // Main Section
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController());
        Get.lazyPut(() => NavBarController(), fenix: true);
      }),
    ),
    GetPage(
      name: navBar,
      page: () => NavBar(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => NavBarController(), fenix: true);
      }),
    ),

    // Pricing Section
    GetPage(
      name: subscriptionScreen,
      page: () => SubscriptionScreen(),
      binding: BindingsBuilder(() {
        Get.delete<SubscriptionController>(force: true);
        Get.put(SubscriptionController());
      }),
    ),

    // Analysis Section
    GetPage(
      name: photoInstructionsScreen,
      page: () => PhotoInstructionsScreen(),
    ),
    GetPage(
      name: watchCaptureScreen,
      page: () => WatchCaptureScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => WatchCaptureController());
      }),
    ),
    GetPage(
      name: accessoriesScreen,
      page: () => AccessoriesScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AccessoriesController());
      }),
    ),
    GetPage(
      name: aiAnalysisScreen,
      page: () => AiAnalysisScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AiAnalysisController());
      }),
    ),
    GetPage(name: analysisCompleteScreen, page: () => AnalysisCompleteScreen()),
    GetPage(
      name: priceEstimationScreen,
      page: () => PriceEstimationScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => PriceEstimationController());
      }),
    ),

    // Profile & Reports
    GetPage(
      name: profileScreen,
      page: () => ProfileScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ProfileController());
        Get.lazyPut(() => NavBarController(), fenix: true);
      }),
    ),
    GetPage(name: reportWebViewScreen, page: () => ReportWebViewScreen()),
    GetPage(name: privacyPolicyScreen, page: () => PrivacyPolicyScreen()),
    GetPage(name: termsOfUseScreen, page: () => TermsOfUseScreen()),
    GetPage(name: helpFaqScreen, page: () => HelpFaqScreen()),
    GetPage(
      name: historyPreview,
      page: () => HistoryPreview(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HistoryController());
      }),
    ),

    GetPage(name: AppRoute.uploadScreen, page: () => UploadScreen()),
    GetPage(name: AppRoute.cameraScreen, page: () => CameraScreen()),
  ];
}
