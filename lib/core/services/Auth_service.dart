

// import 'dart:convert';
// import 'package:clause_verify/core/services/endpoints.dart';
// import 'package:clause_verify/core/services/network_caller.dart';
// import 'package:clause_verify/core/services/purchase_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// class AuthService {
//   static const String _tokenKey = 'token';
//   static const String _refreshTokenKey = 'refresh_token';
//   static const String _userDataKey = 'user_data';
//   static const String _selectedCurrencyKey = 'selected_currency';
//   static const String _userPlanLimitKey = 'user_plan_limit';

//   static SharedPreferences? _preferences;
//   static String? _token;
//   static String? _refreshToken;
//   static Map<String, dynamic>? _userData;
//   static Map<String, dynamic>? _userPlanLimit;
//   static String _selectedCurrency = 'USD';
//   static String? lastGoogleError; 

//   // ─────────────────────────────────────────
//   // Init & Ensure Initialized
//   // ─────────────────────────────────────────

//   static Future<void> init() async {
//     _preferences ??= await SharedPreferences.getInstance();
//     _loadCachedData();
//   }

//   static Future<void> _ensureInitialized() async {
//     _preferences ??= await SharedPreferences.getInstance();
//   }

//   static void _loadCachedData() {
//     _token = _preferences?.getString(_tokenKey);
//     _refreshToken = _preferences?.getString(_refreshTokenKey);

//     final userDataString = _preferences?.getString(_userDataKey);
//     if (userDataString != null) {
//       try {
//         _userData = jsonDecode(userDataString) as Map<String, dynamic>;
//       } catch (e) {
//         print('⚠️ Error parsing user data: $e');
//       }
//     }

//     final planLimitString = _preferences?.getString(_userPlanLimitKey);
//     if (planLimitString != null) {
//       try {
//         _userPlanLimit = jsonDecode(planLimitString) as Map<String, dynamic>;
//       } catch (e) {
//         print('⚠️ Error parsing user plan limit: $e');
//       }
//     }

//     _selectedCurrency = _preferences?.getString(_selectedCurrencyKey) ?? 'USD';
//   }

//   // ─────────────────────────────────────────
//   // Auth State
//   // ─────────────────────────────────────────

//   static bool get isLoggedIn => _token != null && _token!.isNotEmpty;

//   // ─────────────────────────────────────────
//   // RevenueCat user sync
//   // ─────────────────────────────────────────

//   static Future<void> syncPurchaseUser() async {
//     final id = userId;
//     if (!isLoggedIn || id == null || id.isEmpty || id == 'null') {
//       print('⚠️ RevenueCat sync skipped: loggedIn=$isLoggedIn, userId=$id');
//       return;
//     }
//     await PurchaseService.login(id);
//   }

//   // ─────────────────────────────────────────
//   // Save Login Data
//   // ─────────────────────────────────────────

//   static Future<void> saveLoginData(Map<String, dynamic> responseData) async {
//     try {
//       await _ensureInitialized();
      
//       final accessToken = responseData['access'] as String?;
//       if (accessToken != null && accessToken.isNotEmpty) {
//         await saveToken(accessToken);
//       }

//       final refreshToken = responseData['refresh'] as String?;
//       if (refreshToken != null && refreshToken.isNotEmpty) {
//         await saveRefreshToken(refreshToken);
//       }

//       final userData = responseData['user_data'] as Map<String, dynamic>? ?? 
//           responseData['user'] as Map<String, dynamic>?;
//       if (userData != null) {
//         await saveUserData(userData);
//       }

//       final planLimit = responseData['user_plan_limit'] as Map<String, dynamic>?;
//       if (planLimit != null) {
//         await saveUserPlanLimit(planLimit);
//       }

//       await syncPurchaseUser();
//     } catch (e) {
//       print('❌ Error saving login data: $e');
//       rethrow;
//     }
//   }

//   // ─────────────────────────────────────────
//   // Save Google / Apple Login Data
//   // ─────────────────────────────────────────

//   static Future<void> saveGoogleLoginData(Map<String, dynamic> responseData) async {
//     try {
//       await _ensureInitialized();

//       final Map<String, dynamic> actualData = responseData.containsKey('data')
//           ? responseData['data'] as Map<String, dynamic>
//           : responseData;

//       final accessToken = actualData['access'] as String?;
//       if (accessToken != null && accessToken.isNotEmpty) {
//         await saveToken(accessToken);
//       }

//       final refreshToken = actualData['refresh'] as String?;
//       if (refreshToken != null && refreshToken.isNotEmpty) {
//         await saveRefreshToken(refreshToken);
//       }

//       final userData = actualData['user_data'] as Map<String, dynamic>? ?? 
//           actualData['user'] as Map<String, dynamic>?;
//       if (userData != null) {
//         await saveUserData(userData);
//       }

//       final planLimit = actualData['user_plan_limit'] as Map<String, dynamic>?;
//       if (planLimit != null) {
//         await saveUserPlanLimit(planLimit);
//       }

//       await syncPurchaseUser();
//     } catch (e) {
//       print('❌ Error saving Google login data: $e');
//       rethrow;
//     }
//   }

//   // ─────────────────────────────────────────
//   // Token helpers
//   // ─────────────────────────────────────────

//   static Future<void> saveToken(String token) async {
//     await _ensureInitialized();
//     await _preferences!.setString(_tokenKey, token);
//     _token = token;
//   }

//   static Future<void> saveRefreshToken(String refreshToken) async {
//     await _ensureInitialized();
//     await _preferences!.setString(_refreshTokenKey, refreshToken);
//     _refreshToken = refreshToken;
//   }

//   static String? get token => _token;
//   static String? get refreshToken => _refreshToken;

//   // ─────────────────────────────────────────
//   // User Profile Data
//   // ─────────────────────────────────────────

//   static Future<void> saveUserData(Map<String, dynamic> userData) async {
//     try {
//       await _ensureInitialized();
//       final jsonString = jsonEncode(userData);
//       await _preferences!.setString(_userDataKey, jsonString);
//       _userData = userData;
//       print('✅ User data saved successfully! Status: ${userData['user_status']}');
//     } catch (e) {
//       print('❌ Error saving user data: $e');
//       rethrow;
//     }
//   }

//   static Map<String, dynamic>? get userData => _userData;

//   static String? getUserField(String key) {
//     return _userData?[key]?.toString();
//   }

//   static dynamic getUserFieldRaw(String key) {
//     return _userData?[key];
//   }

//   // ─────────────────────────────────────────
//   // ✅ User Plan Limit Save/Get
//   // ─────────────────────────────────────────

//   static Future<void> saveUserPlanLimit(Map<String, dynamic> planLimit) async {
//     try {
//       await _ensureInitialized();
//       final jsonString = jsonEncode(planLimit);
//       await _preferences!.setString(_userPlanLimitKey, jsonString);
//       _userPlanLimit = planLimit;
//       print('✅ User plan limit saved: $planLimit');
//     } catch (e) {
//       print('❌ Error saving user plan limit: $e');
//     }
//   }

//   static Map<String, dynamic>? get userPlanLimit => _userPlanLimit;

//   // ─────────────────────────────────────────
//   // Bulletproof Integer Parser
//   // ─────────────────────────────────────────

//   static int _parseInt(dynamic value) {
//     if (value == null) return 0;
//     if (value is int) return value;
//     if (value is double) return value.toInt(); 
//     if (value is String) {
//       final d = double.tryParse(value);
//       if (d != null) return d.toInt();
//       return int.tryParse(value) ?? 0;
//     }
//     return 0;
//   }

//   // ─────────────────────────────────────────
//   // ✅ Package value parser
//   // ─────────────────────────────────────────

//   static int _parsePackageCount(dynamic value) {
//     if (value == null) return 0;
//     if (value is int) return value;
//     if (value is double) return value.toInt();
//     if (value is String) {
//       final lower = value.toLowerCase().trim();
//       if (lower == 'not purchased yet' || lower == 'not purchased' || lower == 'none' || lower == 'null') {
//         return 0;
//       }
//       return int.tryParse(value) ?? 0;
//     }
//     return 0;
//   }

//   // ─────────────────────────────────────────
//   // Typed getters — profile fields
//   // ─────────────────────────────────────────

//   static String? get userEmail => getUserField('email');
//   static String? get userName => getUserField('full_name');
//   static String? get userId => getUserField('id');
//   static String? get customizedUserId => getUserField('customized_user_id');
//   static String? get userType => getUserField('user_type');
//   static String get userStatus => getUserField('user_status') ?? 'non_premium';
//   static String? get profilePicture => getUserField('profile_picture');
//   static String? get phone => getUserField('phone');
//   static String? get address => getUserField('address');

//   static bool get isVerified => getUserField('is_verified')?.toLowerCase() == 'true';
//   static bool get isPremium => getUserField('user_status') == 'premium';

//   static int get point => _parseInt(_userData?['point']);
//   static int get scanLimit => _parseInt(_userData?['scan_limit']);

//   static int get scanLimitCount => _parsePackageCount(_userPlanLimit?['scan_limit']);
//   static int get monthlyPackageCount => _parsePackageCount(_userPlanLimit?['monthly_package']);
//   static int get unlimitedPackageCount => _parsePackageCount(_userPlanLimit?['unlimited_package']);
  
//   static int get totalAvailableScans => scanLimitCount + monthlyPackageCount + unlimitedPackageCount;

//   // ─────────────────────────────────────────
//   // Logout
//   // ─────────────────────────────────────────

//   static Future<void> logoutUser() async {
//     try {
//       await _ensureInitialized();
//       await PurchaseService.logout();

//       await _preferences!.clear();
//       _token = null;
//       _refreshToken = null;
//       _userData = null;
//       _userPlanLimit = null;
//       _selectedCurrency = 'USD';
//     } catch (e) {
//       print('❌ Error during logout: $e');
//       rethrow;
//     }
//   }

//   // ─────────────────────────────────────────
//   // Terms & Conditions
//   // ─────────────────────────────────────────

//   static Future<bool> isFirstTimeUser() async {
//     try {
//       await _ensureInitialized();
//       return _preferences!.getBool('is_first_time') ?? true;
//     } catch (e) {
//       return true;
//     }
//   }

//   static Future<void> setFirstTimeUser(bool value) async {
//     try {
//       await _ensureInitialized();
//       await _preferences!.setBool('is_first_time', value);
//     } catch (e) {
//       print('⚠️ Error setting first time user: $e');
//     }
//   }

//   static Future<bool> shouldShowTerms() async {
//     try {
//       await _ensureInitialized();
//       final termsAccepted = _preferences!.getBool('terms_accepted') ?? false;
//       final isFirstTime = _preferences!.getBool('is_first_time') ?? true;
//       return isFirstTime && !termsAccepted;
//     } catch (e) {
//       return true;
//     }
//   }

//   // ─────────────────────────────────────────
//   // Google Sign In
//   // ─────────────────────────────────────────

//   static Future<bool> signInWithGoogle() async {
//     lastGoogleError = null;
//     try {
//       final googleSignIn = GoogleSignIn(scopes: ['email']);
//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) {
//         lastGoogleError = 'User cancelled or Google account picker failed to open';
//         print('❌ Google Sign-In: User cancelled or returned null');
//         return false;
//       }

//       final googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//         accessToken: googleAuth.accessToken,
//       );

//       final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//       final idToken = await userCredential.user?.getIdToken();
//       if (idToken == null) {
//         lastGoogleError = 'Firebase idToken was null';
//         print('❌ Google Sign-In: idToken is null');
//         return false;
//       }

//       final networkCaller = NetworkCaller();
//       final response = await networkCaller.postRequest(
//         Endpoints.googleAuth,
//         body: {'id_token': idToken},
//         requiresAuth: false,
//       );

//       if (response.isSuccess && response.responseData != null) {
//         await saveGoogleLoginData(response.responseData!);
//         return true;
//       } else {
//         lastGoogleError = 'Backend error: ${response.errorMessage}';
//         print('❌ Google Backend Error: ${response.errorMessage}');
//         return false;
//       }
//     } catch (e, stack) {
//       lastGoogleError = e.toString();
//       print('❌ Google login error: $e');
//       print('❌ Stack trace: $stack');
//       return false;
//     }
//   }

//   // ─────────────────────────────────────────
//   // Apple Sign In
//   // ─────────────────────────────────────────

//   static Future<bool> signInWithApple() async {
//     try {
//       final appleCredential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//         webAuthenticationOptions: WebAuthenticationOptions(
//           clientId: 'com.clauseverify.app',
//           redirectUri: Uri.parse(
//             'https://clauseverify-app.firebaseapp.com/__/auth/handler',
//           ),
//         ),
//       );

//       final oauthCredential = OAuthProvider('apple.com').credential(
//         idToken: appleCredential.identityToken,
//         accessToken: appleCredential.authorizationCode,
//       );

//       final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
//       final idToken = await userCredential.user?.getIdToken();
//       if (idToken == null) return false;

//       final networkCaller = NetworkCaller();
//       final response = await networkCaller.postRequest(
//         Endpoints.googleAuth, 
//         body: {'id_token': idToken},
//         requiresAuth: false, 
//       );

//       if (response.isSuccess && response.responseData != null) {
//         await saveGoogleLoginData(response.responseData!);
//         return true;
//       } else {
//         print('❌ Apple Backend Error: ${response.errorMessage}');
//         return false;
//       }
//     } catch (e) {
//       print('❌ Apple login error: $e');
//       return false;
//     }
//   }

//   // ─────────────────────────────────────────
//   // Currency Management
//   // ─────────────────────────────────────────

//   static String get selectedCurrency => _selectedCurrency;
//   static const List<String> availableCurrencies = ['USD', 'EUR', 'Auto'];

//   static Future<void> saveCurrency(String currency) async {
//     if (!availableCurrencies.contains(currency)) return;
//     await _ensureInitialized();
//     await _preferences!.setString(_selectedCurrencyKey, currency);
//     _selectedCurrency = currency;
//   }

//   static String get currencySymbol {
//     switch (_selectedCurrency) {
//       case 'EUR':
//         return '€';
//       default:
//         return '\$';
//     }
//   }

//   static String get currencyCode => _selectedCurrency;
//   static bool get isCurrencyAuto => _selectedCurrency == 'Auto';

//   static Future<void> resetCurrency() async {
//     await saveCurrency('USD');
//   }
// }






import 'dart:convert';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/core/services/purchase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  static const String _tokenKey = 'token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _selectedCurrencyKey = 'selected_currency';
  static const String _userPlanLimitKey = 'user_plan_limit';

  static SharedPreferences? _preferences;
  static String? _token;
  static String? _refreshToken;
  static Map<String, dynamic>? _userData;
  static Map<String, dynamic>? _userPlanLimit;
  static String _selectedCurrency = 'USD';
  static String? lastGoogleError;

  // ─────────────────────────────────────────
  // Init & Ensure Initialized
  // ─────────────────────────────────────────

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
    _loadCachedData();
  }

  static Future<void> _ensureInitialized() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static void _loadCachedData() {
    _token = _preferences?.getString(_tokenKey);
    _refreshToken = _preferences?.getString(_refreshTokenKey);

    final userDataString = _preferences?.getString(_userDataKey);
    if (userDataString != null) {
      try {
        _userData = jsonDecode(userDataString) as Map<String, dynamic>;
      } catch (e) {
        print('⚠️ Error parsing user data: $e');
      }
    }

    final planLimitString = _preferences?.getString(_userPlanLimitKey);
    if (planLimitString != null) {
      try {
        _userPlanLimit = jsonDecode(planLimitString) as Map<String, dynamic>;
      } catch (e) {
        print('⚠️ Error parsing user plan limit: $e');
      }
    }

    _selectedCurrency = _preferences?.getString(_selectedCurrencyKey) ?? 'USD';
  }

  // ─────────────────────────────────────────
  // Auth State
  // ─────────────────────────────────────────

  static bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  // ─────────────────────────────────────────
  // RevenueCat user sync
  // ─────────────────────────────────────────

  static Future<void> syncPurchaseUser() async {
    final id = userId;
    if (!isLoggedIn || id == null || id.isEmpty || id == 'null') {
      print('⚠️ RevenueCat sync skipped: loggedIn=$isLoggedIn, userId=$id');
      return;
    }
    await PurchaseService.login(id);
  }

  // ─────────────────────────────────────────
  // Save Login Data
  // ─────────────────────────────────────────

  static Future<void> saveLoginData(Map<String, dynamic> responseData) async {
    try {
      await _ensureInitialized();

      final accessToken = responseData['access'] as String?;
      if (accessToken != null && accessToken.isNotEmpty) {
        await saveToken(accessToken);
      }

      final refreshToken = responseData['refresh'] as String?;
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await saveRefreshToken(refreshToken);
      }

      final userData = responseData['user_data'] as Map<String, dynamic>? ??
          responseData['user'] as Map<String, dynamic>?;
      if (userData != null) {
        await saveUserData(userData);
      }

      final planLimit =
          responseData['user_plan_limit'] as Map<String, dynamic>?;
      if (planLimit != null) {
        await saveUserPlanLimit(planLimit);
      }

      await syncPurchaseUser();
    } catch (e) {
      print('❌ Error saving login data: $e');
      rethrow;
    }
  }

  // ─────────────────────────────────────────
  // Save Google / Apple Login Data
  // ─────────────────────────────────────────

  static Future<void> saveGoogleLoginData(
      Map<String, dynamic> responseData) async {
    try {
      await _ensureInitialized();

      final Map<String, dynamic> actualData = responseData.containsKey('data')
          ? responseData['data'] as Map<String, dynamic>
          : responseData;

      final accessToken = actualData['access'] as String?;
      if (accessToken != null && accessToken.isNotEmpty) {
        await saveToken(accessToken);
      }

      final refreshToken = actualData['refresh'] as String?;
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await saveRefreshToken(refreshToken);
      }

      final userData = actualData['user_data'] as Map<String, dynamic>? ??
          actualData['user'] as Map<String, dynamic>?;
      if (userData != null) {
        await saveUserData(userData);
      }

      final planLimit = actualData['user_plan_limit'] as Map<String, dynamic>?;
      if (planLimit != null) {
        await saveUserPlanLimit(planLimit);
      }

      await syncPurchaseUser();
    } catch (e) {
      print('❌ Error saving Google login data: $e');
      rethrow;
    }
  }

  // ─────────────────────────────────────────
  // Token helpers
  // ─────────────────────────────────────────

  static Future<void> saveToken(String token) async {
    await _ensureInitialized();
    await _preferences!.setString(_tokenKey, token);
    _token = token;
  }

  static Future<void> saveRefreshToken(String refreshToken) async {
    await _ensureInitialized();
    await _preferences!.setString(_refreshTokenKey, refreshToken);
    _refreshToken = refreshToken;
  }

  static String? get token => _token;
  static String? get refreshToken => _refreshToken;

  // ─────────────────────────────────────────
  // User Profile Data
  // ─────────────────────────────────────────

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      await _ensureInitialized();
      final jsonString = jsonEncode(userData);
      await _preferences!.setString(_userDataKey, jsonString);
      _userData = userData;
      print(
          '✅ User data saved successfully! Status: ${userData['user_status']}');
    } catch (e) {
      print('❌ Error saving user data: $e');
      rethrow;
    }
  }

  static Map<String, dynamic>? get userData => _userData;

  static String? getUserField(String key) {
    return _userData?[key]?.toString();
  }

  static dynamic getUserFieldRaw(String key) {
    return _userData?[key];
  }

  // ─────────────────────────────────────────
  // ✅ User Plan Limit Save/Get
  // ─────────────────────────────────────────

  static Future<void> saveUserPlanLimit(Map<String, dynamic> planLimit) async {
    try {
      await _ensureInitialized();
      final jsonString = jsonEncode(planLimit);
      await _preferences!.setString(_userPlanLimitKey, jsonString);
      _userPlanLimit = planLimit;
      print('✅ User plan limit saved: $planLimit');
    } catch (e) {
      print('❌ Error saving user plan limit: $e');
    }
  }

  static Map<String, dynamic>? get userPlanLimit => _userPlanLimit;

  // ─────────────────────────────────────────
  // Bulletproof Integer Parser
  // ─────────────────────────────────────────

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final d = double.tryParse(value);
      if (d != null) return d.toInt();
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  // ─────────────────────────────────────────
  // ✅ Package value parser
  // ─────────────────────────────────────────

  static int _parsePackageCount(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final lower = value.toLowerCase().trim();
      if (lower == 'not purchased yet' ||
          lower == 'not purchased' ||
          lower == 'none' ||
          lower == 'null') {
        return 0;
      }
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  // ─────────────────────────────────────────
  // Typed getters — profile fields
  // ─────────────────────────────────────────

  static String? get userEmail => getUserField('email');
  static String? get userName => getUserField('full_name');
  static String? get userId => getUserField('id');
  static String? get customizedUserId => getUserField('customized_user_id');
  static String? get userType => getUserField('user_type');
  static String get userStatus => getUserField('user_status') ?? 'non_premium';
  static String? get profilePicture => getUserField('profile_picture');
  static String? get phone => getUserField('phone');
  static String? get address => getUserField('address');

  static bool get isVerified =>
      getUserField('is_verified')?.toLowerCase() == 'true';
  static bool get isPremium => getUserField('user_status') == 'premium';

  static int get point => _parseInt(_userData?['point']);
  static int get scanLimit => _parseInt(_userData?['scan_limit']);

  static int get scanLimitCount =>
      _parsePackageCount(_userPlanLimit?['scan_limit']);
  static int get monthlyPackageCount =>
      _parsePackageCount(_userPlanLimit?['monthly_package']);
  static int get unlimitedPackageCount =>
      _parsePackageCount(_userPlanLimit?['unlimited_package']);

  static int get totalAvailableScans =>
      scanLimitCount + monthlyPackageCount + unlimitedPackageCount;

  // ─────────────────────────────────────────
  // Logout
  // ─────────────────────────────────────────

  static Future<void> logoutUser() async {
    try {
      await _ensureInitialized();
      await PurchaseService.logout();

      // Google ও Firebase session মুছে ফেলো,
      // যাতে পরের বার Google login-এ account select করার modal আসে
      try {
        await GoogleSignIn().signOut();
      } catch (e) {
        print('⚠️ Google signOut failed (continuing): $e');
      }
      try {
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        print('⚠️ Firebase signOut failed (continuing): $e');
      }

      await _preferences!.clear();
      _token = null;
      _refreshToken = null;
      _userData = null;
      _userPlanLimit = null;
      _selectedCurrency = 'USD';
    } catch (e) {
      print('❌ Error during logout: $e');
      rethrow;
    }
  }

  // ─────────────────────────────────────────
  // Terms & Conditions
  // ─────────────────────────────────────────

  static Future<bool> isFirstTimeUser() async {
    try {
      await _ensureInitialized();
      return _preferences!.getBool('is_first_time') ?? true;
    } catch (e) {
      return true;
    }
  }

  static Future<void> setFirstTimeUser(bool value) async {
    try {
      await _ensureInitialized();
      await _preferences!.setBool('is_first_time', value);
    } catch (e) {
      print('⚠️ Error setting first time user: $e');
    }
  }

  static Future<bool> shouldShowTerms() async {
    try {
      await _ensureInitialized();
      final termsAccepted = _preferences!.getBool('terms_accepted') ?? false;
      final isFirstTime = _preferences!.getBool('is_first_time') ?? true;
      return isFirstTime && !termsAccepted;
    } catch (e) {
      return true;
    }
  }

  // ─────────────────────────────────────────
  // Google Sign In
  // ─────────────────────────────────────────

  static Future<bool> signInWithGoogle() async {
    lastGoogleError = null;
    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);

      // আগের session মুছে ফেলো, যাতে প্রতিবার account select করার modal আসে
      try {
        await googleSignIn.signOut();
      } catch (e) {
        print('⚠️ Google signOut before signIn failed (continuing): $e');
      }
      try {
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        print('⚠️ Firebase signOut before signIn failed (continuing): $e');
      }

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        lastGoogleError =
            'User cancelled or Google account picker failed to open';
        print('❌ Google Sign-In: User cancelled or returned null');
        return false;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        lastGoogleError = 'Firebase idToken was null';
        print('❌ Google Sign-In: idToken is null');
        return false;
      }

      final networkCaller = NetworkCaller();
      final response = await networkCaller.postRequest(
        Endpoints.googleAuth,
        body: {'id_token': idToken},
        requiresAuth: false,
      );

      if (response.isSuccess && response.responseData != null) {
        await saveGoogleLoginData(response.responseData!);
        return true;
      } else {
        lastGoogleError = 'Backend error: ${response.errorMessage}';
        print('❌ Google Backend Error: ${response.errorMessage}');
        return false;
      }
    } catch (e, stack) {
      lastGoogleError = e.toString();
      print('❌ Google login error: $e');
      print('❌ Stack trace: $stack');
      return false;
    }
  }

  // ─────────────────────────────────────────
  // Apple Sign In
  // ─────────────────────────────────────────

  static Future<bool> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.clauseverify.app',
          redirectUri: Uri.parse(
            'https://clauseverify-app.firebaseapp.com/__/auth/handler',
          ),
        ),
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) return false;

      final networkCaller = NetworkCaller();
      final response = await networkCaller.postRequest(
        Endpoints.googleAuth,
        body: {'id_token': idToken},
        requiresAuth: false,
      );

      if (response.isSuccess && response.responseData != null) {
        await saveGoogleLoginData(response.responseData!);
        return true;
      } else {
        print('❌ Apple Backend Error: ${response.errorMessage}');
        return false;
      }
    } catch (e) {
      print('❌ Apple login error: $e');
      return false;
    }
  }

  // ─────────────────────────────────────────
  // Currency Management
  // ─────────────────────────────────────────

  static String get selectedCurrency => _selectedCurrency;
  static const List<String> availableCurrencies = ['USD', 'EUR', 'Auto'];

  static Future<void> saveCurrency(String currency) async {
    if (!availableCurrencies.contains(currency)) return;
    await _ensureInitialized();
    await _preferences!.setString(_selectedCurrencyKey, currency);
    _selectedCurrency = currency;
  }

  static String get currencySymbol {
    switch (_selectedCurrency) {
      case 'EUR':
        return '€';
      default:
        return '\$';
    }
  }

  static String get currencyCode => _selectedCurrency;
  static bool get isCurrencyAuto => _selectedCurrency == 'Auto';

  static Future<void> resetCurrency() async {
    await saveCurrency('USD');
  }
}