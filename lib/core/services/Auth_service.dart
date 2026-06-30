// import 'dart:convert';
// import 'package:clause_verify/core/services/endpoints.dart';
// import 'package:clause_verify/core/services/network_caller.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// class AuthService {
//   static const String _tokenKey = 'token';
//   static const String _refreshTokenKey = 'refresh_token';
//   static const String _userDataKey = 'user_data';
//   static const String _selectedCurrencyKey = 'selected_currency';

//   static late SharedPreferences _preferences;
//   static String? _token;
//   static String? _refreshToken;
//   static Map<String, dynamic>? _userData;
//   static String _selectedCurrency = 'USD';

//   // ─────────────────────────────────────────
//   // Init
//   // ─────────────────────────────────────────

//   static Future<void> init() async {
//     _preferences = await SharedPreferences.getInstance();
//     _token = _preferences.getString(_tokenKey);
//     _refreshToken = _preferences.getString(_refreshTokenKey);

//     final userDataString = _preferences.getString(_userDataKey);
//     if (userDataString != null) {
//       try {
//         _userData = jsonDecode(userDataString) as Map<String, dynamic>;
//       } catch (e) {
//         print('⚠️ Error parsing user data: $e');
//       }
//     }

//     _selectedCurrency =
//         _preferences.getString(_selectedCurrencyKey) ?? 'USD';
//   }

//   // ─────────────────────────────────────────
//   // Auth State
//   // ─────────────────────────────────────────

//   static bool get isLoggedIn => _token != null && _token!.isNotEmpty;

//   // ─────────────────────────────────────────
//   // Save Login Data
//   // Login response:
//   // {
//   //   "user": { ...user fields... },
//   //   "refresh": "...",
//   //   "access": "...",
//   //   "user_id": "23"
//   // }
//   // ─────────────────────────────────────────

//   static Future<void> saveLoginData(Map<String, dynamic> responseData) async {
//     try {
//       final accessToken = responseData['access'] as String?;
//       if (accessToken != null && accessToken.isNotEmpty) {
//         await saveToken(accessToken);
//       }

//       final refreshToken = responseData['refresh'] as String?;
//       if (refreshToken != null && refreshToken.isNotEmpty) {
//         await saveRefreshToken(refreshToken);
//       }

//       // Save user object from login response
//       final userData = responseData['user'] as Map<String, dynamic>?;
//       if (userData != null) {
//         await saveUserData(userData);
//       }
//     } catch (e) {
//       print('❌ Error saving login data: $e');
//       rethrow;
//     }
//   }

//   // ─────────────────────────────────────────
//   // Save Google / Apple Login Data
//   // ─────────────────────────────────────────

//   static Future<void> saveGoogleLoginData(
//       Map<String, dynamic> responseData) async {
//     try {
//       final Map<String, dynamic> actualData =
//           responseData.containsKey('data')
//               ? responseData['data'] as Map<String, dynamic>
//               : responseData;

//       final accessToken = actualData['access'] as String?;
//       if (accessToken != null && accessToken.isNotEmpty) {
//         await saveToken(accessToken);
//       }

//       final refreshToken = actualData['refresh'] as String?;
//       if (refreshToken != null && refreshToken.isNotEmpty) {
//         await saveRefreshToken(refreshToken);
//       }

//       final userData = actualData['user'] as Map<String, dynamic>?;
//       if (userData != null) {
//         await saveUserData(userData);
//       }
//     } catch (e) {
//       print('❌ Error saving Google login data: $e');
//       rethrow;
//     }
//   }

//   // ─────────────────────────────────────────
//   // Token helpers
//   // ─────────────────────────────────────────

//   static Future<void> saveToken(String token) async {
//     await _preferences.setString(_tokenKey, token);
//     _token = token;
//   }

//   static Future<void> saveRefreshToken(String refreshToken) async {
//     await _preferences.setString(_refreshTokenKey, refreshToken);
//     _refreshToken = refreshToken;
//   }

//   static String? get token => _token;
//   static String? get refreshToken => _refreshToken;

//   // ─────────────────────────────────────────
//   // User Profile Data
//   // Saves the full profile response from
//   // /api/auth/user-profile-info/ which includes:
//   // id, customized_user_id, profile_picture,
//   // user_type, user_status, is_verified, point,
//   // full_name, email, phone, address,
//   // updated_at, created_at
//   // ─────────────────────────────────────────

//   static Future<void> saveUserData(Map<String, dynamic> userData) async {
//     try {
//       final jsonString = jsonEncode(userData);
//       await _preferences.setString(_userDataKey, jsonString);
//       _userData = userData;
//     } catch (e) {
//       print('❌ Error saving user data: $e');
//       rethrow;
//     }
//   }

//   static Map<String, dynamic>? get userData => _userData;

//   /// Get any single field from saved user data as String
//   static String? getUserField(String key) {
//     return _userData?[key]?.toString();
//   }

//   /// Get any single field from saved user data as original type
//   static dynamic getUserFieldRaw(String key) {
//     return _userData?[key];
//   }

//   // ─────────────────────────────────────────
//   // Typed getters — profile fields
//   // ─────────────────────────────────────────

//   static String? get userEmail       => getUserField('email');
//   static String? get userName        => getUserField('full_name');
//   static String? get userId          => getUserField('id');
//   static String? get customizedUserId => getUserField('customized_user_id');
//   static String? get userType        => getUserField('user_type');
//   static String? get userStatus      => getUserField('user_status');
//   static String? get profilePicture  => getUserField('profile_picture');
//   static String? get phone           => getUserField('phone');
//   static String? get address         => getUserField('address');

//   static bool get isVerified =>
//       getUserField('is_verified')?.toLowerCase() == 'true';

//   /// user_status == 'premium'
//   static bool get isPremium =>
//       getUserField('user_status') == 'premium';

//   /// Points balance — used for scan count display on HomeScreen
//   static int get point {
//     final raw = _userData?['point'];
//     if (raw == null) return 0;
//     if (raw is int) return raw;
//     return int.tryParse(raw.toString()) ?? 0;
//   }

//   // ─────────────────────────────────────────
//   // Logout
//   // ─────────────────────────────────────────

//   static Future<void> logoutUser() async {
//     try {
//       await _preferences.clear();
//       _token = null;
//       _refreshToken = null;
//       _userData = null;
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
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getBool('is_first_time') ?? true;
//     } catch (e) {
//       return true;
//     }
//   }

//   static Future<void> setFirstTimeUser(bool value) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('is_first_time', value);
//     } catch (e) {
//       print('⚠️ Error setting first time user: $e');
//     }
//   }

//   static Future<bool> shouldShowTerms() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final termsAccepted = prefs.getBool('terms_accepted') ?? false;
//       final isFirstTime = prefs.getBool('is_first_time') ?? true;
//       return isFirstTime && !termsAccepted;
//     } catch (e) {
//       return true;
//     }
//   }

//   // ─────────────────────────────────────────
//   // Google Sign In
//   // ─────────────────────────────────────────

//   static Future<bool> signInWithGoogle() async {
//     try {
//       final googleSignIn = GoogleSignIn(scopes: ['email']);
//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) return false;

//       final googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//         accessToken: googleAuth.accessToken,
//       );

//       final userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);
//       final idToken = await userCredential.user?.getIdToken();
//       if (idToken == null) return false;

//       final networkCaller = NetworkCaller();
//       final response = await networkCaller.postRequest(
//         Endpoints.googleAuth,
//         body: {'id_token': idToken},
//       );

//       if (response.isSuccess && response.responseData != null) {
//         await saveGoogleLoginData(response.responseData!);
//         return true;
//       }
//       return false;
//     } catch (e) {
//       print('❌ Google login error: $e');
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

//       final userCredential =
//           await FirebaseAuth.instance.signInWithCredential(oauthCredential);
//       final idToken = await userCredential.user?.getIdToken();
//       if (idToken == null) return false;

//       final networkCaller = NetworkCaller();
//       final response = await networkCaller.postRequest(
//         Endpoints.googleAuth,
//         body: {'id_token': idToken},
//       );

//       if (response.isSuccess && response.responseData != null) {
//         await saveGoogleLoginData(response.responseData!);
//         return true;
//       }
//       return false;
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
//     await _preferences.setString(_selectedCurrencyKey, currency);
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

//   // ─────────────────────────────────────────
//   // Debug
//   // ─────────────────────────────────────────

//   static Future<void> testDataPersistence() async {
//     print('🧪 Token available: ${_token != null}');
//     print('🧪 User email: $userEmail');
//     print('🧪 User name: $userName');
//     print('🧪 Points: $point');
//   }


//   /// scan_limit — homescreen এ দেখানোর জন্য
// static int get scanLimit {
//   final raw = _userData?['scan_limit'];
//   if (raw == null) return 0;
//   if (raw is int) return raw;
//   return int.tryParse(raw.toString()) ?? 0;
// }
// }




import 'dart:convert';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  static const String _tokenKey = 'token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _selectedCurrencyKey = 'selected_currency';

  // ✅ Changed from late to nullable to prevent LateInitializationError
  static SharedPreferences? _preferences;
  static String? _token;
  static String? _refreshToken;
  static Map<String, dynamic>? _userData;
  static String _selectedCurrency = 'USD';

  // ─────────────────────────────────────────
  // Init & Ensure Initialized
  // ─────────────────────────────────────────

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
    _loadCachedData();
  }

  // ✅ Fallback method to prevent crashes if init() wasn't called
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

    _selectedCurrency = _preferences?.getString(_selectedCurrencyKey) ?? 'USD';
  }

  // ─────────────────────────────────────────
  // Auth State
  // ─────────────────────────────────────────

  static bool get isLoggedIn => _token != null && _token!.isNotEmpty;

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

      final userData = responseData['user'] as Map<String, dynamic>?;
      if (userData != null) {
        await saveUserData(userData);
      }
    } catch (e) {
      print('❌ Error saving login data: $e');
      rethrow;
    }
  }

  // ─────────────────────────────────────────
  // Save Google / Apple Login Data
  // ─────────────────────────────────────────

  static Future<void> saveGoogleLoginData(Map<String, dynamic> responseData) async {
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

      final userData = actualData['user'] as Map<String, dynamic>?;
      if (userData != null) {
        await saveUserData(userData);
      }
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
      await _ensureInitialized(); // ✅ FIX: Ensures preferences is initialized before saving
      
      final jsonString = jsonEncode(userData);
      await _preferences!.setString(_userDataKey, jsonString);
      _userData = userData;
      
      print('✅ User data saved successfully! Scan limit: ${userData['scan_limit']}');
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
  // Typed getters — profile fields
  // ─────────────────────────────────────────

  static String? get userEmail => getUserField('email');
  static String? get userName => getUserField('full_name');
  static String? get userId => getUserField('id');
  static String? get customizedUserId => getUserField('customized_user_id');
  static String? get userType => getUserField('user_type');
  static String? get userStatus => getUserField('user_status');
  static String? get profilePicture => getUserField('profile_picture');
  static String? get phone => getUserField('phone');
  static String? get address => getUserField('address');

  static bool get isVerified => getUserField('is_verified')?.toLowerCase() == 'true';
  static bool get isPremium => getUserField('user_status') == 'premium';

  static int get point => _parseInt(_userData?['point']);
  static int get scanLimit => _parseInt(_userData?['scan_limit']);

  // ─────────────────────────────────────────
  // Logout
  // ─────────────────────────────────────────

  static Future<void> logoutUser() async {
    try {
      await _ensureInitialized();
      await _preferences!.clear();
      _token = null;
      _refreshToken = null;
      _userData = null;
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
    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) return false;

      final networkCaller = NetworkCaller();
      final response = await networkCaller.postRequest(
        Endpoints.googleAuth,
        body: {'id_token': idToken},
      );

      if (response.isSuccess && response.responseData != null) {
        await saveGoogleLoginData(response.responseData!);
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Google login error: $e');
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

      final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) return false;

      final networkCaller = NetworkCaller();
      final response = await networkCaller.postRequest(
        Endpoints.googleAuth,
        body: {'id_token': idToken},
      );

      if (response.isSuccess && response.responseData != null) {
        await saveGoogleLoginData(response.responseData!);
        return true;
      }
      return false;
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