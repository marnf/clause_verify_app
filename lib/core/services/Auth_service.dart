// // // // ignore_for_file: file_names

// // // import 'dart:developer';
// // // import 'package:shared_preferences/shared_preferences.dart';

// // // class AuthService {
// // //   static const String _tokenKey = 'token';

// // //   // Singleton instance for SharedPreferences
// // //   static late SharedPreferences _preferences;


// // //   // Private variables to hold token and userId
// // //   static String? _token;

// // //   // Initialize SharedPreferences (call this during app startup)
// // //   static Future<void> init() async {
// // //     _preferences = await SharedPreferences.getInstance();
// // //     // Load token and userId from SharedPreferences into private variables
// // //     _token = _preferences.getString(_tokenKey);
// // //   }

// // //   // Check if a token exists in local storage
// // //   static bool hasToken() {
// // //     return _preferences.containsKey(_tokenKey);
// // //   }

// // //   // Save the token and user ID to local storage
// // //   static Future<void> saveToken(String token) async {
// // //     try {
// // //       await _preferences.setString(_tokenKey, token);
// // //       // Update private variables
// // //       _token = token;
// // //     } catch (e) {
// // //       log('Error saving token: $e');
// // //     }
// // //   }

// // //   // Clear authentication data (for logout or clearing auth data)
// // //   static Future<void> logoutUser() async {
// // //     try {
// // //       // Clear all data from SharedPreferences
// // //       await _preferences.clear();

// // //       // Reset private variables
// // //       _token = null;
// // //       // Redirect to the login screen
// // //       await goToLogin();
// // //     } catch (e) {
// // //       log('Error during logout: $e');
// // //     }
// // //   }

// // //   // Navigate to the login screen (e.g., after logout or token expiry)
// // //   static Future<void> goToLogin() async {
// // //     // Get.offAllNamed('/login');
// // //   }

// // //   // Getter for token
// // //   static String? get token => _token;
// // // }





// // // ignore_for_file: file_names

// // import 'dart:convert';
// // import 'package:flutter_extension/core/services/endpoints.dart';
// // import 'package:flutter_extension/core/services/network_caller.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:google_sign_in/google_sign_in.dart';

// // class AuthService {
// //   static const String _tokenKey = 'token';
// //   static const String _refreshTokenKey = 'refresh_token';
// //   static const String _userDataKey = 'user_data';

// //   static late SharedPreferences _preferences;
// //   static String? _token;
// //   static String? _refreshToken;
// //   static Map<String, dynamic>? _userData;
// //   static const String _hasSeenTermsKey = 'has_seen_terms';





// //   // Initialize SharedPreferences
// //   static Future<void> init() async {
// //     _preferences = await SharedPreferences.getInstance();
// //     _token = _preferences.getString(_tokenKey);
// //     _refreshToken = _preferences.getString(_refreshTokenKey);
    
// //     // Load user data
// //     final userDataString = _preferences.getString(_userDataKey);
// //     if (userDataString != null) {
// //       try {
// //         _userData = jsonDecode(userDataString) as Map<String, dynamic>;
// //       } catch (e) {
// //         print('❌ Error parsing user data: $e');
// //       }
// //     }
    
// //     // Print all stored data after initialization
// //     printAllStoredData();
// //   }

// //   // ✅ NEW METHOD: Print all stored data
// //   static void printAllStoredData() {
// //     print('\n══════════════════════════════════════════');
// //     print('🔍 AUTH SERVICE - STORED DATA CHECK');
// //     print('══════════════════════════════════════════');
    
// //     // Print all keys in SharedPreferences
// //     print('\n📁 All SharedPreferences Keys:');
// //     final allKeys = _preferences.getKeys();
// //     allKeys.forEach((key) {
// //       print('   • $key');
// //     });
    
// //     // Print token
// //     print('\n🔑 Token Status:');
// //     final storedToken = _preferences.getString(_tokenKey);
// //     print('   - Key exists: ${_preferences.containsKey(_tokenKey)}');
// //     print('   - Stored value: ${storedToken != null ? '${storedToken.substring(0, 20)}...' : 'NULL'}');
// //     print('   - _token variable: ${_token != null ? '${_token!.substring(0, 20)}...' : 'NULL'}');
// //     print('   - Token length: ${storedToken?.length ?? 0}');
    
// //     // Print refresh token
// //     print('\n🔄 Refresh Token Status:');
// //     final storedRefreshToken = _preferences.getString(_refreshTokenKey);
// //     print('   - Key exists: ${_preferences.containsKey(_refreshTokenKey)}');
// //     print('   - Stored value: ${storedRefreshToken != null ? '${storedRefreshToken.substring(0, 20)}...' : 'NULL'}');
// //     print('   - _refreshToken variable: ${_refreshToken != null ? '${_refreshToken!.substring(0, 20)}...' : 'NULL'}');
// //     print('   - Refresh token length: ${storedRefreshToken?.length ?? 0}');
    
// //     // Print user data
// //     print('\n👤 User Data Status:');
// //     final userDataString = _preferences.getString(_userDataKey);
// //     print('   - Key exists: ${_preferences.containsKey(_userDataKey)}');
// //     print('   - User data stored: ${userDataString != null ? 'YES' : 'NO'}');
    
// //     if (userDataString != null) {
// //       try {
// //         final decodedData = jsonDecode(userDataString);
// //         print('   - User data type: ${decodedData.runtimeType}');
// //         print('   - User data keys: ${(decodedData as Map<String, dynamic>).keys.toList()}');
        
// //         // Print specific user fields
// //         if (_userData != null) {
// //           print('\n   📋 User Details:');
// //           print('      • Email: ${_userData!['email'] ?? 'N/A'}');
// //           print('      • ID: ${_userData!['id'] ?? 'N/A'}');
// //           print('      • First Name: ${_userData!['first_name'] ?? 'N/A'}');
// //           print('      • Last Name: ${_userData!['last_name'] ?? 'N/A'}');
// //           print('      • Subscription: ${_userData!['subscription_type'] ?? 'N/A'}');
// //           print('      • Is Premium: ${_userData!['is_premium'] ?? 'N/A'}');
// //           print('      • Free Scans: ${_userData!['free_scans_remaining'] ?? 'N/A'}');
// //         }
// //       } catch (e) {
// //         print('   ❌ Error decoding user data: $e');
// //         print('   Raw user data string: $userDataString');
// //       }
// //     }
    
// //     // Print isLoggedIn status
// //     print('\n✅ Login Status:');
// //     print('   - isLoggedIn: $isLoggedIn');
// //     print('   - Token exists: ${_token != null}');
// //     print('   - Token not empty: ${_token?.isNotEmpty ?? false}');
    
// //     print('══════════════════════════════════════════\n');
// //   }

// //   // ✅ NEW METHOD: Print raw stored data (for debugging)
// //   static void printRawStoredData() {
// //     print('\n📊 RAW STORED DATA:');
// //     print('Token: ${_preferences.getString(_tokenKey)}');
// //     print('Refresh Token: ${_preferences.getString(_refreshTokenKey)}');
// //     print('User Data JSON: ${_preferences.getString(_userDataKey)}');
// //   }

// //   // Check if a token exists
// //   static bool get isLoggedIn => _token != null && _token!.isNotEmpty;

// //   // Save authentication data from login response
// //   static Future<void> saveLoginData(Map<String, dynamic> responseData) async {
// //     try {
// //       print('\n💾 SAVING LOGIN DATA...');
// //       print('Response data keys: ${responseData.keys.toList()}');
      
// //       // Save tokens
// //       final tokens = responseData['tokens'] as Map<String, dynamic>;
// //       print('Tokens received: ${tokens.keys.toList()}');
      
// //       await saveToken(tokens['access'] as String);
// //       await saveRefreshToken(tokens['refresh'] as String);
      
// //       // Save user data
// //       final userData = responseData['user'] as Map<String, dynamic>;
// //       print('User data received: ${userData.keys.toList()}');
// //       await saveUserData(userData);
      
// //       print('✅ Login data saved successfully');
      
// //       // Print verification after save
// //       printAllStoredData();
// //     } catch (e) {
// //       print('❌ Error saving login data: $e');
// //       print('Stack trace: ${e.toString()}');
// //       rethrow;
// //     }
// //   }

// //   // Save access token
// //   static Future<void> saveToken(String token) async {
// //     try {
// //       print('\n🔐 Saving token...');
// //       print('Token length: ${token.length}');
// //       print('Token preview: ${token.substring(0, 50)}...');
      
// //       await _preferences.setString(_tokenKey, token);
// //       _token = token;
      
// //       // Verify save
// //       final savedToken = _preferences.getString(_tokenKey);
// //       print('✅ Token saved successfully');
// //       print('   - Verification: ${savedToken != null ? 'Saved' : 'NOT Saved'}');
// //       print('   - Length match: ${savedToken?.length == token.length}');
// //     } catch (e) {
// //       print('❌ Error saving token: $e');
// //       rethrow;
// //     }
// //   }

// //   // Save refresh token
// //   static Future<void> saveRefreshToken(String refreshToken) async {
// //     try {
// //       print('\n🔄 Saving refresh token...');
// //       print('Refresh token length: ${refreshToken.length}');
// //       print('Refresh token preview: ${refreshToken.substring(0, 50)}...');
      
// //       await _preferences.setString(_refreshTokenKey, refreshToken);
// //       _refreshToken = refreshToken;
      
// //       // Verify save
// //       final savedRefreshToken = _preferences.getString(_refreshTokenKey);
// //       print('✅ Refresh token saved successfully');
// //       print('   - Verification: ${savedRefreshToken != null ? 'Saved' : 'NOT Saved'}');
// //     } catch (e) {
// //       print('❌ Error saving refresh token: $e');
// //       rethrow;
// //     }
// //   }

// //   // Save user data
// //   static Future<void> saveUserData(Map<String, dynamic> userData) async {
// //     try {
// //       print('\n👤 Saving user data...');
// //       print('User data to save:');
// //       userData.forEach((key, value) {
// //         print('   - $key: $value');
// //       });
      
// //       final jsonString = jsonEncode(userData);
// //       print('JSON encoded length: ${jsonString.length}');
      
// //       await _preferences.setString(_userDataKey, jsonString);
// //       _userData = userData;
      
// //       // Verify save
// //       final savedUserData = _preferences.getString(_userDataKey);
// //       print('✅ User data saved successfully');
// //       print('   - Verification: ${savedUserData != null ? 'Saved' : 'NOT Saved'}');
// //       print('   - Can decode: ${jsonDecode(savedUserData!) != null}');
// //     } catch (e) {
// //       print('❌ Error saving user data: $e');
// //       print('User data that caused error: $userData');
// //       rethrow;
// //     }
// //   }

// //   // Get user data
// //   static Map<String, dynamic>? get userData => _userData;

// //   // Get specific user field with type safety
// //   static String? getUserField(String key) {
// //     final value = _userData?[key]?.toString();
// //     print('📝 Getting user field "$key": $value');
// //     return value;
// //   }

// //   // Get user email
// //   static String? get userEmail => getUserField('email');

// //   // Get user name
// //   static String? get userName {
// //     final firstName = getUserField('first_name') ?? '';
// //     final lastName = getUserField('last_name') ?? '';
// //     final name = '$firstName $lastName'.trim();
// //     print('👤 User name calculated: $name');
// //     return name;
// //   }

// //   // Get subscription status
// //   static bool get isPremium {
// //     final premium = getUserField('is_premium')?.toLowerCase() == 'true';
// //     print('⭐ Is premium: $premium');
// //     return premium;
// //   }

// //   // Get remaining scans
// //   static int get freeScansRemaining {
// //     final scans = getUserField('free_scans_remaining');
// //     final result = scans != null ? int.tryParse(scans) ?? 0 : 0;
// //     print('🔍 Free scans remaining: $result');
// //     return result;
// //   }

// //   // Clear authentication data
// //   static Future<void> logoutUser() async {
// //     try {
// //       print('\n🚪 Logging out user...');
// //       print('Before logout:');
// //       print('   - Token exists: ${_preferences.containsKey(_tokenKey)}');
// //       print('   - User data exists: ${_preferences.containsKey(_userDataKey)}');
      
// //       await _preferences.clear();
// //       _token = null;
// //       _refreshToken = null;
// //       _userData = null;
      
// //       print('✅ User logged out successfully');
// //       print('After logout:');
// //       print('   - Token exists: ${_preferences.containsKey(_tokenKey)}');
// //       print('   - User data exists: ${_preferences.containsKey(_userDataKey)}');
// //     } catch (e) {
// //       print('❌ Error during logout: $e');
// //       rethrow;
// //     }
// //   }

// //   // Get refresh token
// //   static String? get refreshToken {
// //     print('🔄 Getting refresh token: ${_refreshToken != null ? "Available" : "NULL"}');
// //     return _refreshToken;
// //   }
  
// //   // Getter for token
// //   static String? get token {
// //     print('🔑 Getting access token: ${_token != null ? "Available" : "NULL"}');
// //     return _token;
// //   }
  
// //   // ✅ NEW METHOD: Test method to verify data persistence
// //   static Future<void> testDataPersistence() async {
// //     print('\n🧪 TESTING DATA PERSISTENCE');
// //     print('============================');
    
// //     // Test 1: Check if data survives app restart
// //     print('\n1️⃣ Simulating app restart...');
// //     await init();
    
// //     // Test 2: Verify all data is loaded
// //     print('\n2️⃣ Verifying loaded data:');
// //     print('   - Token loaded: ${_token != null}');
// //     print('   - Refresh token loaded: ${_refreshToken != null}');
// //     print('   - User data loaded: ${_userData != null}');
    
// //     // Test 3: Check SharedPreferences directly
// //     print('\n3️⃣ Direct SharedPreferences check:');
// //     print('   - Token in prefs: ${_preferences.getString(_tokenKey) != null}');
// //     print('   - Keys in prefs: ${_preferences.getKeys().length}');
    
// //     print('\n✅ Test completed\n');
// //   }



// // // For terms and conditon part 
// // static Future<bool> isFirstTimeUser() async {
// //   try {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getBool('is_first_time') ?? true;
// //   } catch (e) {
// //     print('Error checking first time user: $e');
// //     return true;
// //   }
// // }

// // static Future<void> setFirstTimeUser(bool value) async {
// //   try {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setBool('is_first_time', value);
// //   } catch (e) {
// //     print('Error setting first time user: $e');
// //   }
// // }

// // static Future<bool> shouldShowTerms() async {
// //   try {
// //     final prefs = await SharedPreferences.getInstance();
// //     final termsAccepted = prefs.getBool('terms_accepted') ?? false;
// //     final isFirstTime = prefs.getBool('is_first_time') ?? true;
    
// //     // Terms দেখাবে যদি:
// //     // 1. প্রথমবার অ্যাপ ব্যবহার করছে (isFirstTime = true) AND
// //     // 2. Terms এখনো accept করেনি
// //     return isFirstTime && !termsAccepted;
// //   } catch (e) {
// //     print('Error checking shouldShowTerms: $e');
// //     return true; // Safe default - show terms
// //   }
// // }


// // static Future<bool> signInWithGoogle() async {
// //     try {
// //       // 1️⃣ Google SignIn
// //       final googleSignIn = GoogleSignIn(scopes: ['email']);
// //       final googleUser = await googleSignIn.signIn();
// //       if (googleUser == null) return false; // user cancelled

// //       final googleAuth = await googleUser.authentication;

// //       // 2️⃣ Firebase credential
// //       final credential = GoogleAuthProvider.credential(
// //         idToken: googleAuth.idToken,
// //         accessToken: googleAuth.accessToken,
// //       );

// //       // 3️⃣ Firebase sign in
// //       final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

// //       // 4️⃣ Get Firebase ID Token
// //       final idToken = await userCredential.user?.getIdToken();
// //       print('🔥 Firebase ID Token: $idToken');

// //       if (idToken == null) return false;

// //       // 5️⃣ POST to backend using NetworkCaller
// //       final networkCaller = NetworkCaller();
// //       final response = await networkCaller.postRequest(
// //         Endpoints.googleAuth, // Your backend endpoint
// //         body: {'id_token': idToken}, // JSON body
// //       );

// //       if (response.isSuccess) {
// //         print('✅ Backend login successful: ${response.responseData}');
// //         // Save backend token if needed
// //         final backendToken = response.responseData?['token'];
// //         if (backendToken != null) {
// //           await AuthService.saveToken(backendToken); // Save token in AuthService
// //           print('🎯 Backend Token saved: $backendToken');
// //         }
// //         return true;
// //       } else {
// //         print('❌ Backend login failed: ${response.errorMessage}');
// //         return false;
// //       }
// //     } catch (e) {
// //       print('❌ Google login error: $e');
// //       return false;
// //     }
// //   }

  







// // //   static Future<String?> signInWithGoogle() async {
// // //   try {
// // //     // 1️⃣ Google Sign-In
// // //     final googleSignIn = GoogleSignIn(scopes: ['email']);
// // //     final googleUser = await googleSignIn.signIn();
// // //     if (googleUser == null) return null; // user cancelled

// // //     // 2️⃣ Google authentication
// // //     final googleAuth = await googleUser.authentication;

// // //     // 3️⃣ Firebase credential
// // //     final credential = GoogleAuthProvider.credential(
// // //       idToken: googleAuth.idToken,
// // //       accessToken: googleAuth.accessToken,
// // //     );

// // //     // 4️⃣ Firebase sign in
// // //     final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

// // //     // 5️⃣ Get Firebase ID Token
// // //     final idToken = await userCredential.user?.getIdToken();
// // //     print('🔥 Firebase ID Token: $idToken xxx');

// // //     return idToken; // Return Firebase ID token
// // //   } catch (e) {
// // //     print('❌ Google login error: $e');
// // //     return null;
// // //   }
// // // }


  
// // }









// import 'dart:convert';
// import 'package:flutter_extension/core/services/endpoints.dart';
// import 'package:flutter_extension/core/services/network_caller.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   static const String _tokenKey = 'token';
//   static const String _refreshTokenKey = 'refresh_token';
//   static const String _userDataKey = 'user_data';

//   static late SharedPreferences _preferences;
//   static String? _token;
//   static String? _refreshToken;
//   static Map<String, dynamic>? _userData;
//   static const String _hasSeenTermsKey = 'has_seen_terms';

//   // Initialize SharedPreferences
//   static Future<void> init() async {
//     _preferences = await SharedPreferences.getInstance();
//     _token = _preferences.getString(_tokenKey);
//     _refreshToken = _preferences.getString(_refreshTokenKey);
    
//     // Load user data
//     final userDataString = _preferences.getString(_userDataKey);
//     if (userDataString != null) {
//       try {
//         _userData = jsonDecode(userDataString) as Map<String, dynamic>;
//       } catch (e) {
//         print('❌ Error parsing user data: $e');
//       }
//     }
    
//     // Print all stored data after initialization
//     printAllStoredData();
//   }

//   // ✅ NEW METHOD: Print all stored data
//   static void printAllStoredData() {
//     print('\n══════════════════════════════════════════');
//     print('🔍 AUTH SERVICE - STORED DATA CHECK');
//     print('══════════════════════════════════════════');
    
//     // Print all keys in SharedPreferences
//     print('\n📁 All SharedPreferences Keys:');
//     final allKeys = _preferences.getKeys();
//     allKeys.forEach((key) {
//       print('   • $key');
//     });
    
//     // Print token
//     print('\n🔑 Token Status:');
//     final storedToken = _preferences.getString(_tokenKey);
//     print('   - Key exists: ${_preferences.containsKey(_tokenKey)}');
//     print('   - Stored value: ${storedToken != null ? '${storedToken.substring(0, 20)}...' : 'NULL'}');
//     print('   - _token variable: ${_token != null ? '${_token!.substring(0, 20)}...' : 'NULL'}');
//     print('   - Token length: ${storedToken?.length ?? 0}');
    
//     // Print refresh token
//     print('\n🔄 Refresh Token Status:');
//     final storedRefreshToken = _preferences.getString(_refreshTokenKey);
//     print('   - Key exists: ${_preferences.containsKey(_refreshTokenKey)}');
//     print('   - Stored value: ${storedRefreshToken != null ? '${storedRefreshToken.substring(0, 20)}...' : 'NULL'}');
//     print('   - _refreshToken variable: ${_refreshToken != null ? '${_refreshToken!.substring(0, 20)}...' : 'NULL'}');
//     print('   - Refresh token length: ${storedRefreshToken?.length ?? 0}');
    
//     // Print user data
//     print('\n👤 User Data Status:');
//     final userDataString = _preferences.getString(_userDataKey);
//     print('   - Key exists: ${_preferences.containsKey(_userDataKey)}');
//     print('   - User data stored: ${userDataString != null ? 'YES' : 'NO'}');
    
//     if (userDataString != null) {
//       try {
//         final decodedData = jsonDecode(userDataString);
//         print('   - User data type: ${decodedData.runtimeType}');
//         print('   - User data keys: ${(decodedData as Map<String, dynamic>).keys.toList()}');
        
//         // Print specific user fields
//         if (_userData != null) {
//           print('\n   📋 User Details:');
//           print('      • Email: ${_userData!['email'] ?? 'N/A'}');
//           print('      • ID: ${_userData!['id'] ?? 'N/A'}');
//           print('      • First Name: ${_userData!['first_name'] ?? 'N/A'}');
//           print('      • Last Name: ${_userData!['last_name'] ?? 'N/A'}');
//           print('      • Subscription: ${_userData!['subscription_type'] ?? 'N/A'}');
//           print('      • Is Premium: ${_userData!['is_premium'] ?? 'N/A'}');
//           print('      • Free Scans: ${_userData!['free_scans_remaining'] ?? 'N/A'}');
//         }
//       } catch (e) {
//         print('   ❌ Error decoding user data: $e');
//         print('   Raw user data string: $userDataString');
//       }
//     }
    
//     // Print isLoggedIn status
//     print('\n✅ Login Status:');
//     print('   - isLoggedIn: $isLoggedIn');
//     print('   - Token exists: ${_token != null}');
//     print('   - Token not empty: ${_token?.isNotEmpty ?? false}');
    
//     print('══════════════════════════════════════════\n');
//   }

//   // ✅ NEW METHOD: Print raw stored data (for debugging)
//   static void printRawStoredData() {
//     print('\n📊 RAW STORED DATA:');
//     print('Token: ${_preferences.getString(_tokenKey)}');
//     print('Refresh Token: ${_preferences.getString(_refreshTokenKey)}');
//     print('User Data JSON: ${_preferences.getString(_userDataKey)}');
//   }

//   // Check if a token exists
//   static bool get isLoggedIn => _token != null && _token!.isNotEmpty;

//   // Save authentication data from login response
//   static Future<void> saveLoginData(Map<String, dynamic> responseData) async {
//     try {
//       print('\n💾 SAVING LOGIN DATA...');
//       print('Response data keys: ${responseData.keys.toList()}');
      
//       // Save tokens
//       final tokens = responseData['tokens'] as Map<String, dynamic>;
//       print('Tokens received: ${tokens.keys.toList()}');
      
//       await saveToken(tokens['access'] as String);
//       await saveRefreshToken(tokens['refresh'] as String);
      
//       // Save user data
//       final userData = responseData['user'] as Map<String, dynamic>;
//       print('User data received: ${userData.keys.toList()}');
//       await saveUserData(userData);
      
//       print('✅ Login data saved successfully');
      
//       // Print verification after save
//       printAllStoredData();
//     } catch (e) {
//       print('❌ Error saving login data: $e');
//       print('Stack trace: ${e.toString()}');
//       rethrow;
//     }
//   }

//   // ✅ NEW METHOD: Save Google login data
//   static Future<void> saveGoogleLoginData(Map<String, dynamic> responseData) async {
//     try {
//       print('\n💾 SAVING GOOGLE LOGIN DATA...');
//       print('Response data keys: ${responseData.keys.toList()}');
      
//       // Check if response has 'success' and 'data' structure
//       Map<String, dynamic> actualData;
      
//       if (responseData.containsKey('data')) {
//         // Response structure: {"success": true, "data": {"user": {...}, "tokens": {...}}}
//         actualData = responseData['data'] as Map<String, dynamic>;
//       } else {
//         // Direct structure: {"user": {...}, "tokens": {...}}
//         actualData = responseData;
//       }
      
//       print('Actual data keys: ${actualData.keys.toList()}');
      
//       // Save tokens
//       final tokens = actualData['tokens'] as Map<String, dynamic>;
//       print('Tokens received: ${tokens.keys.toList()}');
      
//       await saveToken(tokens['access'] as String);
//       await saveRefreshToken(tokens['refresh'] as String);
      
//       // Save user data
//       final userData = actualData['user'] as Map<String, dynamic>;
//       print('User data received: ${userData.keys.toList()}');
//       await saveUserData(userData);
      
//       print('✅ Google login data saved successfully');
      
//       // Print verification after save
//       printAllStoredData();
//     } catch (e) {
//       print('❌ Error saving Google login data: $e');
//       print('Stack trace: ${e.toString()}');
//       rethrow;
//     }
//   }

//   // Save access token
//   static Future<void> saveToken(String token) async {
//     try {
//       print('\n🔐 Saving token...');
//       print('Token length: ${token.length}');
//       print('Token preview: ${token.substring(0, 50)}...');
      
//       await _preferences.setString(_tokenKey, token);
//       _token = token;
      
//       // Verify save
//       final savedToken = _preferences.getString(_tokenKey);
//       print('✅ Token saved successfully');
//       print('   - Verification: ${savedToken != null ? 'Saved' : 'NOT Saved'}');
//       print('   - Length match: ${savedToken?.length == token.length}');
//     } catch (e) {
//       print('❌ Error saving token: $e');
//       rethrow;
//     }
//   }

//   // Save refresh token
//   static Future<void> saveRefreshToken(String refreshToken) async {
//     try {
//       print('\n🔄 Saving refresh token...');
//       print('Refresh token length: ${refreshToken.length}');
//       print('Refresh token preview: ${refreshToken.substring(0, 50)}...');
      
//       await _preferences.setString(_refreshTokenKey, refreshToken);
//       _refreshToken = refreshToken;
      
//       // Verify save
//       final savedRefreshToken = _preferences.getString(_refreshTokenKey);
//       print('✅ Refresh token saved successfully');
//       print('   - Verification: ${savedRefreshToken != null ? 'Saved' : 'NOT Saved'}');
//     } catch (e) {
//       print('❌ Error saving refresh token: $e');
//       rethrow;
//     }
//   }

//   // Save user data
//   static Future<void> saveUserData(Map<String, dynamic> userData) async {
//     try {
//       print('\n👤 Saving user data...');
//       print('User data to save:');
//       userData.forEach((key, value) {
//         print('   - $key: $value');
//       });
      
//       final jsonString = jsonEncode(userData);
//       print('JSON encoded length: ${jsonString.length}');
      
//       await _preferences.setString(_userDataKey, jsonString);
//       _userData = userData;
      
//       // Verify save
//       final savedUserData = _preferences.getString(_userDataKey);
//       print('✅ User data saved successfully');
//       print('   - Verification: ${savedUserData != null ? 'Saved' : 'NOT Saved'}');
//       print('   - Can decode: ${jsonDecode(savedUserData!) != null}');
//     } catch (e) {
//       print('❌ Error saving user data: $e');
//       print('User data that caused error: $userData');
//       rethrow;
//     }
//   }

//   // Get user data
//   static Map<String, dynamic>? get userData => _userData;

//   // Get specific user field with type safety
//   static String? getUserField(String key) {
//     final value = _userData?[key]?.toString();
//     print('📝 Getting user field "$key": $value');
//     return value;
//   }

//   // Get user email
//   static String? get userEmail => getUserField('email');

//   // Get user name
//   static String? get userName {
//     final firstName = getUserField('first_name') ?? '';
//     final lastName = getUserField('last_name') ?? '';
//     final name = '$firstName $lastName'.trim();
//     print('👤 User name calculated: $name');
//     return name;
//   }

//   // Get subscription status
//   static bool get isPremium {
//     final premium = getUserField('is_premium')?.toLowerCase() == 'true';
//     print('⭐ Is premium: $premium');
//     return premium;
//   }

//   // Get remaining scans
//   static int get freeScansRemaining {
//     final scans = getUserField('free_scans_remaining');
//     final result = scans != null ? int.tryParse(scans) ?? 0 : 0;
//     print('🔍 Free scans remaining: $result');
//     return result;
//   }

//   // Clear authentication data
//   static Future<void> logoutUser() async {
//     try {
//       print('\n🚪 Logging out user...');
//       print('Before logout:');
//       print('   - Token exists: ${_preferences.containsKey(_tokenKey)}');
//       print('   - User data exists: ${_preferences.containsKey(_userDataKey)}');
      
//       await _preferences.clear();
//       _token = null;
//       _refreshToken = null;
//       _userData = null;
      
//       print('✅ User logged out successfully');
//       print('After logout:');
//       print('   - Token exists: ${_preferences.containsKey(_tokenKey)}');
//       print('   - User data exists: ${_preferences.containsKey(_userDataKey)}');
//     } catch (e) {
//       print('❌ Error during logout: $e');
//       rethrow;
//     }
//   }

//   // Get refresh token
//   static String? get refreshToken {
//     print('🔄 Getting refresh token: ${_refreshToken != null ? "Available" : "NULL"}');
//     return _refreshToken;
//   }
  
//   // Getter for token
//   static String? get token {
//     print('🔑 Getting access token: ${_token != null ? "Available" : "NULL"}');
//     return _token;
//   }
  
//   // ✅ NEW METHOD: Test method to verify data persistence
//   static Future<void> testDataPersistence() async {
//     print('\n🧪 TESTING DATA PERSISTENCE');
//     print('============================');
    
//     // Test 1: Check if data survives app restart
//     print('\n1️⃣ Simulating app restart...');
//     await init();
    
//     // Test 2: Verify all data is loaded
//     print('\n2️⃣ Verifying loaded data:');
//     print('   - Token loaded: ${_token != null}');
//     print('   - Refresh token loaded: ${_refreshToken != null}');
//     print('   - User data loaded: ${_userData != null}');
    
//     // Test 3: Check SharedPreferences directly
//     print('\n3️⃣ Direct SharedPreferences check:');
//     print('   - Token in prefs: ${_preferences.getString(_tokenKey) != null}');
//     print('   - Keys in prefs: ${_preferences.getKeys().length}');
    
//     print('\n✅ Test completed\n');
//   }

//   // For terms and condition part 
//   static Future<bool> isFirstTimeUser() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getBool('is_first_time') ?? true;
//     } catch (e) {
//       print('Error checking first time user: $e');
//       return true;
//     }
//   }

//   static Future<void> setFirstTimeUser(bool value) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('is_first_time', value);
//     } catch (e) {
//       print('Error setting first time user: $e');
//     }
//   }

//   static Future<bool> shouldShowTerms() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final termsAccepted = prefs.getBool('terms_accepted') ?? false;
//       final isFirstTime = prefs.getBool('is_first_time') ?? true;
      
//       // Terms দেখাবে যদি:
//       // 1. প্রথমবার অ্যাপ ব্যবহার করছে (isFirstTime = true) AND
//       // 2. Terms এখনো accept করেনি
//       return isFirstTime && !termsAccepted;
//     } catch (e) {
//       print('Error checking shouldShowTerms: $e');
//       return true; // Safe default - show terms
//     }
//   }

//   static Future<bool> signInWithGoogle() async {
//     try {
//       // 1️⃣ Google SignIn
//       final googleSignIn = GoogleSignIn(scopes: ['email']);
//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) return false; // user cancelled

//       final googleAuth = await googleUser.authentication;

//       // 2️⃣ Firebase credential
//       final credential = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//         accessToken: googleAuth.accessToken,
//       );

//       // 3️⃣ Firebase sign in
//       final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

//       // 4️⃣ Get Firebase ID Token
//       final idToken = await userCredential.user?.getIdToken();
//       print('🔥 Firebase ID Token: $idToken');

//       if (idToken == null) return false;

//       // 5️⃣ POST to backend using NetworkCaller
//       final networkCaller = NetworkCaller();
//       final response = await networkCaller.postRequest(
//         Endpoints.googleAuth, // Your backend endpoint
//         body: {'id_token': idToken}, // JSON body
//       );

//       if (response.isSuccess && response.responseData != null) {
//         print('✅ Backend login successful: ${response.responseData}');
        
//         // ✅ Save Google login data using the new method
//         await saveGoogleLoginData(response.responseData!);
        
//         // Test data persistence
//         await testDataPersistence();
        
//         return true;
//       } else {
//         print('❌ Backend login failed: ${response.errorMessage}');
//         return false;
//       }
//     } catch (e) {
//       print('❌ Google login error: $e');
//       return false;
//     }
//   }
// }





// import 'dart:convert';
// import 'package:flutter_extension/core/services/endpoints.dart';
// import 'package:flutter_extension/core/services/network_caller.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   static const String _tokenKey = 'token';
//   static const String _refreshTokenKey = 'refresh_token';
//   static const String _userDataKey = 'user_data';

//   static late SharedPreferences _preferences;
//   static String? _token;
//   static String? _refreshToken;
//   static Map<String, dynamic>? _userData;
//   static const String _hasSeenTermsKey = 'has_seen_terms';

//   // Initialize SharedPreferences
//   static Future<void> init() async {
//     _preferences = await SharedPreferences.getInstance();
//     _token = _preferences.getString(_tokenKey);
//     _refreshToken = _preferences.getString(_refreshTokenKey);
    
//     // Load user data
//     final userDataString = _preferences.getString(_userDataKey);
//     if (userDataString != null) {
//       try {
//         _userData = jsonDecode(userDataString) as Map<String, dynamic>;
//       } catch (e) {
//         // Error parsing user data
//       }
//     }
//   }

//   // Check if a token exists
//   static bool get isLoggedIn => _token != null && _token!.isNotEmpty;

//   // Save authentication data from login response
//   static Future<void> saveLoginData(Map<String, dynamic> responseData) async {
//     try {
//       // Save tokens
//       final tokens = responseData['tokens'] as Map<String, dynamic>;
      
//       await saveToken(tokens['access'] as String);
//       await saveRefreshToken(tokens['refresh'] as String);
      
//       // Save user data
//       // final userData = responseData['user'] as Map<String, dynamic>;
//       // await saveUserData(userData);
//     } catch (e) {
//       // Error saving login data
//       rethrow;
//     }
//   }

//   // Save Google login data
//   static Future<void> saveGoogleLoginData(Map<String, dynamic> responseData) async {
//     try {
//       // Check if response has 'success' and 'data' structure
//       Map<String, dynamic> actualData;
      
//       if (responseData.containsKey('data')) {
//         // Response structure: {"success": true, "data": {"user": {...}, "tokens": {...}}}
//         actualData = responseData['data'] as Map<String, dynamic>;
//       } else {
//         // Direct structure: {"user": {...}, "tokens": {...}}
//         actualData = responseData;
//       }
      
//       // Save tokens
//       final tokens = actualData['tokens'] as Map<String, dynamic>;
//       await saveToken(tokens['access'] as String);
//       await saveRefreshToken(tokens['refresh'] as String);
      
//       // Save user data
//       // final userData = actualData['user'] as Map<String, dynamic>;
//       // await saveUserData(userData);
//     } catch (e) {
//       // Error saving Google login data
//       rethrow;
//     }
//   }

//   // Save access token
//   static Future<void> saveToken(String token) async {
//     try {
//       await _preferences.setString(_tokenKey, token);
//       _token = token;
//     } catch (e) {
//       // Error saving token
//       rethrow;
//     }
//   }

//   // Save refresh token
//   static Future<void> saveRefreshToken(String refreshToken) async {
//     try {
//       await _preferences.setString(_refreshTokenKey, refreshToken);
//       _refreshToken = refreshToken;
//     } catch (e) {
//       // Error saving refresh token
//       rethrow;
//     }
//   }

//   // Save user data
//   static Future<void> saveUserData(Map<String, dynamic> userData) async {
//     try {
//       final jsonString = jsonEncode(userData);
//       await _preferences.setString(_userDataKey, jsonString);
//       _userData = userData;
//     } catch (e) {
//       // Error saving user data
//       rethrow;
//     }
//   }

//   // Get user data
//   static Map<String, dynamic>? get userData => _userData;

//   // Get specific user field with type safety
//   static String? getUserField(String key) {
//     return _userData?[key]?.toString();
//   }

//   // Get user email
//   static String? get userEmail => getUserField('email');

//   // Get user name
//   static String? get userName {
//     final firstName = getUserField('first_name') ?? '';
//     final lastName = getUserField('last_name') ?? '';
//     return '$firstName $lastName'.trim();
//   }

//   // Get subscription status
//   static bool get isPremium {
//     return getUserField('is_premium')?.toLowerCase() == 'true';
//   }

//   // Get remaining scans
//   static int get freeScansRemaining {
//     final scans = getUserField('free_scans_remaining');
//     return scans != null ? int.tryParse(scans) ?? 0 : 0;
//   }

//   // Clear authentication data
//   static Future<void> logoutUser() async {
//     try {
//       await _preferences.clear();
//       _token = null;
//       _refreshToken = null;
//       _userData = null;
//     } catch (e) {
//       // Error during logout
//       rethrow;
//     }
//   }

//   // Get refresh token
//   static String? get refreshToken => _refreshToken;
  
//   // Getter for token
//   static String? get token => _token;

//   // For terms and condition part 
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
//       // Error setting first time user
//     }
//   }

//   static Future<bool> shouldShowTerms() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final termsAccepted = prefs.getBool('terms_accepted') ?? false;
//       final isFirstTime = prefs.getBool('is_first_time') ?? true;
      
//       // Terms দেখাবে যদি:
//       // 1. প্রথমবার অ্যাপ ব্যবহার করছে (isFirstTime = true) AND
//       // 2. Terms এখনো accept করেনি
//       return isFirstTime && !termsAccepted;
//     } catch (e) {
//       return true; // Safe default - show terms
//     }
//   }

//   static Future<bool> signInWithGoogle() async {
//     try {
//       // 1️⃣ Google SignIn
//       final googleSignIn = GoogleSignIn(scopes: ['email']);
//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) return false; // user cancelled

//       final googleAuth = await googleUser.authentication;

//       // 2️⃣ Firebase credential
//       final credential = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//         accessToken: googleAuth.accessToken,
//       );

//       // 3️⃣ Firebase sign in
//       final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

//       // 4️⃣ Get Firebase ID Token
//       final idToken = await userCredential.user?.getIdToken();
//       if (idToken == null) return false;

//       // 5️⃣ POST to backend using NetworkCaller
//       final networkCaller = NetworkCaller();
//       final response = await networkCaller.postRequest(
//         Endpoints.googleAuth, // Your backend endpoint
//         body: {'id_token': idToken}, // JSON body
//       );

//       if (response.isSuccess && response.responseData != null) {
//         // Save Google login data using the new method
//         await saveGoogleLoginData(response.responseData!);
//         return true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       // Google login error
//       return false;
//     }
//   }
  



//    static Future<void> testDataPersistence() async {
//     print('\n🧪 TESTING DATA PERSISTENCE');
//     // print('============================');
    
//     // // Test 1: Check if data survives app restart
//     // print('\n1️⃣ Simulating app restart...');
//     // await init();
    
//     // // Test 2: Verify all data is loaded
//     // print('\n2️⃣ Verifying loaded data:');
//     // print('   - Token loaded: ${_token != null}');
//     // print('   - Refresh token loaded: ${_refreshToken != null}');
//     // print('   - User data loaded: ${_userData != null}');
    
//     // // Test 3: Check SharedPreferences directly
//     // print('\n3️⃣ Direct SharedPreferences check:');
//     // print('   - Token in prefs: ${_preferences.getString(_tokenKey) != null}');
//     // print('   - Keys in prefs: ${_preferences.getKeys().length}');
    
//     // print('\n✅ Test completed\n');
//   }
// }



import 'dart:convert';
import 'package:flutter_extension/core/services/endpoints.dart';
import 'package:flutter_extension/core/services/network_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
 import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  static const String _tokenKey = 'token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _hasSeenTermsKey = 'has_seen_terms';
  
  // ✨ Currency Management Keys
  static const String _selectedCurrencyKey = 'selected_currency';

  static late SharedPreferences _preferences;
  static String? _token;
  static String? _refreshToken;
  static Map<String, dynamic>? _userData;
  
  // ✨ Currency State
  static String _selectedCurrency = 'USD'; // Default

  // Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences.getString(_tokenKey);
    _refreshToken = _preferences.getString(_refreshTokenKey);
    
    // Load user data
    final userDataString = _preferences.getString(_userDataKey);
    if (userDataString != null) {
      try {
        _userData = jsonDecode(userDataString) as Map<String, dynamic>;
      } catch (e) {
        // Error parsing user data
      }
    }
    
    // ✨ Load saved currency
    _selectedCurrency = _preferences.getString(_selectedCurrencyKey) ?? 'USD';
    print('✅ Currency loaded: $_selectedCurrency');
  }

  // Check if a token exists
  static bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  // Save authentication data from login response
  static Future<void> saveLoginData(Map<String, dynamic> responseData) async {
    try {
      // Save tokens
      final tokens = responseData['tokens'] as Map<String, dynamic>;
      
      await saveToken(tokens['access'] as String);
      await saveRefreshToken(tokens['refresh'] as String);
      
      // Save user data
      final userData = responseData['user'] as Map<String, dynamic>;
      await saveUserData(userData);
    } catch (e) {
      // Error saving login data
      rethrow;
    }
  }

  // Save Google login data
  static Future<void> saveGoogleLoginData(Map<String, dynamic> responseData) async {
    try {
      Map<String, dynamic> actualData;
      if (responseData.containsKey('data')) {
        
        actualData = responseData['data'] as Map<String, dynamic>;
      } else {
        actualData = responseData;
      }
      
      // Save tokens
      final tokens = actualData['tokens'] as Map<String, dynamic>;
      await saveToken(tokens['access'] as String);
      await saveRefreshToken(tokens['refresh'] as String);
      
      // Save user data
      final userData = actualData['user'] as Map<String, dynamic>;
      await saveUserData(userData);
    } catch (e) {
      // Error saving Google login data
      rethrow;
    }
  }

  // Save access token
  static Future<void> saveToken(String token) async {
    try {
      await _preferences.setString(_tokenKey, token);
      _token = token;
    } catch (e) {
      // Error saving token
      rethrow;
    }
  }

  // Save refresh token
  static Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _preferences.setString(_refreshTokenKey, refreshToken);
      _refreshToken = refreshToken;
    } catch (e) {
      // Error saving refresh token
      rethrow;
    }
  }

  // Save user data
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final jsonString = jsonEncode(userData);
      await _preferences.setString(_userDataKey, jsonString);
      _userData = userData;
    } catch (e) {
      // Error saving user data
      rethrow;
    }
  }

  // Get user data
  static Map<String, dynamic>? get userData => _userData;

  // Get specific user field with type safety
  static String? getUserField(String key) {
    return _userData?[key]?.toString();
  }

  // Get user email
  static String? get userEmail => getUserField('email');

  // Get user name
  static String? get userName {
    final firstName = getUserField('first_name') ?? '';
    final lastName = getUserField('last_name') ?? '';
    return '$firstName $lastName'.trim();
  }

  // Get subscription status
  static bool get isPremium {
    return getUserField('is_premium')?.toLowerCase() == 'true';
  }

  // Get remaining scans
  static int get freeScansRemaining {
    final scans = getUserField('free_scans_remaining');
    return scans != null ? int.tryParse(scans) ?? 0 : 0;
  }

  // Clear authentication data
  static Future<void> logoutUser() async {
    try {
      await _preferences.clear();
      _token = null;
      _refreshToken = null;
      _userData = null;
      // ⚠️ Currency will also be cleared, so it will reset to default (USD) on next login
      // If you want to keep currency after logout, save it before clear and restore after
      final savedCurrency = _selectedCurrency;
      _selectedCurrency = 'USD';
      // Optionally restore: await saveCurrency(savedCurrency);
    } catch (e) {
      // Error during logout
      rethrow;
    }
  }

  // Get refresh token
  static String? get refreshToken => _refreshToken;
  
  // Getter for token
  static String? get token => _token;

  // For terms and condition part 
  static Future<bool> isFirstTimeUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('is_first_time') ?? true;
    } catch (e) {
      return true;
    }
  }

  static Future<void> setFirstTimeUser(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_first_time', value);
    } catch (e) {
      // Error setting first time user
    }
  }

  static Future<bool> shouldShowTerms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final termsAccepted = prefs.getBool('terms_accepted') ?? false;
      final isFirstTime = prefs.getBool('is_first_time') ?? true;
      
      // Terms দেখাবে যদি:
      // 1. প্রথমবার অ্যাপ ব্যবহার করছে (isFirstTime = true) AND
      // 2. Terms এখনো accept করেনি
      return isFirstTime && !termsAccepted;
    } catch (e) {
      return true; // Safe default - show terms
    }
  }

  static Future<bool> signInWithGoogle() async {
    try {
      // 1️⃣ Google SignIn
      final googleSignIn = GoogleSignIn(scopes: ['email']);
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false; // user cancelled

      final googleAuth = await googleUser.authentication;

      // 2️⃣ Firebase credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // 3️⃣ Firebase sign in
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // 4️⃣ Get Firebase ID Token
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) return false;

      // 5️⃣ POST to backend using NetworkCaller
      final networkCaller = NetworkCaller();
      final response = await networkCaller.postRequest(
        Endpoints.googleAuth, // Your backend endpoint
        body: {'id_token': idToken}, // JSON body
      );

      if (response.isSuccess && response.responseData != null) {
        // Save Google login data using the new method
        await saveGoogleLoginData(response.responseData!);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Google login error
      return false;
    }
  }
  
  
  
  
  
 

static Future<bool> signInWithApple() async {
  try {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      // ✅ Android এর জন্য এটা লাগবে
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'com.chronoverify.app', // ← আপনার bundle ID দিন
        redirectUri: Uri.parse(
          'https://chronoverify-app.firebaseapp.com/__/auth/handler', // ← Firebase callback URL
        ),
      ),
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final userCredential = await FirebaseAuth.instance
        .signInWithCredential(oauthCredential);

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
    } else {
      return false;
    }
  } catch (e) {
    print('❌ Apple login error: $e');
    return false;
  }
}
  
  
  
  
  static Future<void> testDataPersistence() async {
    print('\n🧪 TESTING DATA PERSISTENCE');
    // print('============================');
    
    // // Test 1: Check if data survives app restart
    // print('\n1️⃣ Simulating app restart...');
    // await init();
    
    // // Test 2: Verify all data is loaded
    // print('\n2️⃣ Verifying loaded data:');
    // print('   - Token loaded: ${_token != null}');
    // print('   - Refresh token loaded: ${_refreshToken != null}');
    // print('   - User data loaded: ${_userData != null}');
    
    // // Test 3: Check SharedPreferences directly
    // print('\n3️⃣ Direct SharedPreferences check:');
    // print('   - Token in prefs: ${_preferences.getString(_tokenKey) != null}');
    // print('   - Keys in prefs: ${_preferences.getKeys().length}');
    
    // print('\n✅ Test completed\n');
  }

  // ==========================================
  // ✨ CURRENCY MANAGEMENT METHODS
  // ==========================================

  /// Get current selected currency
  static String get selectedCurrency => _selectedCurrency;

  /// Available currencies
  static const List<String> availableCurrencies = ['USD', 'EUR', 'Auto'];

  /// Save currency selection
  static Future<void> saveCurrency(String currency) async {
    try {
      if (!availableCurrencies.contains(currency)) {
        print('❌ Invalid currency: $currency');
        return;
      }

      await _preferences.setString(_selectedCurrencyKey, currency);
      _selectedCurrency = currency;
      print('✅ Currency saved: $currency');
    } catch (e) {
      print('❌ Error saving currency: $e');
      rethrow;
    }
  }

  /// Get currency symbol
  static String get currencySymbol {
    switch (_selectedCurrency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'Auto':
        return '\$'; // Default to USD for Auto
      default:
        return '\$';
    }
  }

  /// Get currency code
  static String get currencyCode => _selectedCurrency;

  /// Check if currency is Auto
  static bool get isCurrencyAuto => _selectedCurrency == 'Auto';

  /// Reset currency to default (USD)
  static Future<void> resetCurrency() async {
    await saveCurrency('USD');
  }
}