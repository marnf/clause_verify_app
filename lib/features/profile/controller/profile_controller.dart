
import 'package:clause_verify/core/services/auth_service.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {

  // ✨ User data from AuthService (reactive)
  var userName = ''.obs;
  var userEmail = ''.obs;
  var isPremium = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();


    // ✨ Load user data from AuthService
    isLoading.value = true;
    _loadUserData();
  }

  // ✅ এটা call করুন যখন profile screen visible হবে
  @override
  void onReady() {
    super.onReady();
    // API থেকে latest data fetch করুন
    refreshFromAPI();
  }

  // Load user data from AuthService (local storage)
  void _loadUserData() {
  final name = AuthService.userName ?? '';
  final email = AuthService.userEmail ?? '';
  

  if (name.isEmpty && email.isEmpty) {
    print('⚠️ No local data found, will refresh from API');
    userName.value = '';
    userEmail.value = '';
  } else {
    userName.value = name;
    userEmail.value = email;
    isPremium.value = AuthService.isPremium;
  }
  
  print('👤 User loaded: name=$name, email=$email');
}

  // ✅ API থেকে fresh data fetch করুন
Future<void> refreshFromAPI() async {
  try {
    isLoading.value = true;
    
    final networkCaller = NetworkCaller();
    final response = await networkCaller.getRequest(
      Endpoints.user,
      token: AuthService.token,
    );
    
    if (response.isSuccess && response.responseData != null) {
      final data = response.responseData!['data'] as Map<String, dynamic>;
      await AuthService.saveUserData(data);
      
      // ✅ API থেকে directly set করুন
      userName.value = data['first_name']?.toString() ?? '' + 
                       ' ' + (data['last_name']?.toString() ?? '');
      userName.value = userName.value.trim();
      userEmail.value = data['email']?.toString() ?? '';
      isPremium.value = data['is_premium'] == true;
      
    } else {
      // API fail হলে local data
      _loadUserData();
    }
  } catch (e) {
    print('❌ refreshFromAPI error: $e');
    _loadUserData();
  } finally {
    isLoading.value = false;
  }
}

  // Refresh user data (call this if user data updates)
  void refreshUserData() {
    _loadUserData();
    update(); // Force UI update
  }

 

  void logout() {
    AuthService.logoutUser();
    Get.offAllNamed(AppRoute.loginScreen);
  }
}