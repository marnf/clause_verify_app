class Endpoints {
  // Base URL
  // static const String baseUrl = "https://rihanna-preacquisitive-eleanore.ngrok-free.dev/";
 static const String baseUrl = "https://unheated-overuse-abrasive.ngrok-free.dev";

  // ================= AUTH =================


    static const String register = "$baseUrl/api/auth/signup/";
  static const String verifyOtp = "$baseUrl/api/auth/otp-verification/";
  static const String resendOtp = "$baseUrl/api/auth/resend-otp/";
  static const String login = "$baseUrl/api/auth/login/";
static const String forgotPassword = "$baseUrl/api/auth/forgot-password-request-otp/";
static const String forgotPassOtpVerify = "$baseUrl/api/auth/forgot-password-otp-verification/";
static const String resetPassword = "$baseUrl/api/auth/forgot-change-password/";
  static const String googleAuth = "$baseUrl/api/auth/user/firebase-auth/";

  static const String language = "$baseUrl/api/auth/user/me/";
  static const String subscription = "$baseUrl/api/subscription/list/";
  static const String history = "$baseUrl/api/watch-analysis/analyses/history/";
  static const String historyDetails = "$baseUrl/api/watch-analysis/analyses/report/";
  static const String analysis = "$baseUrl/api/watch-analysis/analyses/";
  static const String revenueCatVerify = "$baseUrl/api/payment/purchases/revenuecat-verify/";
 
  static const String user = "$baseUrl/api/auth/user/me/";
  static const String scan = "$baseUrl/api/auth/user/me/";
 
  // ✅ নতুন endpoints
  static const String userProfile = "$baseUrl/api/auth/user-profile-info/";
  static const String fileUpload = "$baseUrl/api/files/upload/";
  static const String generateReport = "$baseUrl/api/files/generate/report/";



static const String fileAnalysis = "$baseUrl/api/files/analysis/";

}
