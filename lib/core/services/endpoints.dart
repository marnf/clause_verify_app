class Endpoints {
  // Base URL
  // static const String baseUrl = "https://rihanna-preacquisitive-eleanore.ngrok-free.dev/";
  static const String baseUrl = "https://api.chronoverify.app";

  // ================= AUTH =================
  static const String register = "$baseUrl/api/auth/user/register/";
  static const String verifyOtp = "$baseUrl/api/auth/user/register/verify/";
  static const String resendOtp = "$baseUrl/api/auth/user/otp/resend/";
  static const String login = "$baseUrl/api/auth/user/login/";
  static const String forgotPassword = "$baseUrl/api/auth/user/forgot-password/";
  static const String forgotPassOtpVerify = "$baseUrl/api/auth/user/forgot-password-otp/verify/";
  static const String resetPassword = "$baseUrl/api/auth/user/reset-password/";
  static const String googleAuth = "$baseUrl/api/auth/user/firebase-auth/";
  static const String language = "$baseUrl/api/auth/user/me/";
  static const String subscription = "$baseUrl/api/subscription/list/";
  static const String history = "$baseUrl/api/watch-analysis/analyses/history/";
  static const String historyDetails = "$baseUrl/api/watch-analysis/analyses/report/";
  static const String analysis = "$baseUrl/api/watch-analysis/analyses/";
  static const String revenueCatVerify = "$baseUrl/api/payment/purchases/revenuecat-verify/";
 
  static const String user = "$baseUrl/api/auth/user/me/";
  static const String scan = "$baseUrl/api/auth/user/me/";
 
  

}
