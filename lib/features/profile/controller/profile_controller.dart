// import 'package:clause_verify/core/services/auth_service.dart';
// import 'package:clause_verify/core/services/endpoints.dart';
// import 'package:clause_verify/core/services/network_caller.dart';
// import 'package:clause_verify/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ProfileController extends GetxController {

//   // ✨ User data from AuthService (reactive)
//   var userName = ''.obs;
//   var userEmail = ''.obs;
//   var isPremium = false.obs;
//   var isLoading = false.obs;

//   // ✅ Delete account er jonno variables
//   var isDeleting = false.obs;
//   TextEditingController deleteConfirmController = TextEditingController();

//   @override
//   void onInit() {
//     super.onInit();
//     // ✨ Load user data from AuthService
//     isLoading.value = true;
//     _loadUserData();
//   }

//   // ✅ এটা call করুন যখন profile screen visible হবে
//   @override
//   void onReady() {
//     super.onReady();
//     // API থেকে latest data fetch করুন
//     refreshFromAPI();
//   }

//   // Load user data from AuthService (local storage)
//   void _loadUserData() {
//     final name = AuthService.userName ?? '';
//     final email = AuthService.userEmail ?? '';
    

//     if (name.isEmpty && email.isEmpty) {
//       print('⚠️ No local data found, will refresh from API');
//       userName.value = '';
//       userEmail.value = '';
//     } else {
//       userName.value = name;
//       userEmail.value = email;
//       isPremium.value = AuthService.isPremium;
//     }
    
//     print('👤 User loaded: name=$name, email=$email');
//   }

//   // ✅ API থেকে fresh data fetch করুন
//   Future<void> refreshFromAPI() async {
//     try {
//       isLoading.value = true;
      
//       final networkCaller = NetworkCaller();
//       final response = await networkCaller.getRequest(
//         Endpoints.user,
//         token: AuthService.token,
//       );
      
//       if (response.isSuccess && response.responseData != null) {
//         final data = response.responseData!['data'] as Map<String, dynamic>;
//         await AuthService.saveUserData(data);
        
//         // ✅ API থেকে directly set করুন
//         userName.value = data['first_name']?.toString() ?? '' + 
//                          ' ' + (data['last_name']?.toString() ?? '');
//         userName.value = userName.value.trim();
//         userEmail.value = data['email']?.toString() ?? '';
//         isPremium.value = data['is_premium'] == true;
        
//       } else {
//         // API fail হলে local data
//         _loadUserData();
//       }
//     } catch (e) {
//       print('❌ refreshFromAPI error: $e');
//       _loadUserData();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Refresh user data (call this if user data updates)
//   void refreshUserData() {
//     _loadUserData();
//     update(); // Force UI update
//   }

//   // ✅ Account Delete API Call
//   Future<void> deleteAccount() async {
//     // Check if the user typed the exact phrase
//     if (deleteConfirmController.text.trim().toLowerCase() != 'i want to delete my account') {
//       Get.snackbar(
//         'Error',
//         'Please type exactly "i want to delete my account" to confirm.',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     isDeleting.value = true;

//     try {
//       final networkCaller = NetworkCaller();
//       // এখানে শুধু header এ token পাঠানো হচ্ছে, কোনো body নেই
//       final response = await networkCaller.deleteRequest(
//         Endpoints.deleteAccount,
//         AuthService.token, // null দিলে NetworkCaller নিজে থেকে token নিবে, তবে স্পষ্ট করে দেওয়া হলো
//       );

//       if (response.isSuccess) {
//         Get.back(); // Dialog বন্ধ করো
//         Get.snackbar(
//           'Success',
//           'Your account has been deleted successfully.',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
        
//         // Log out and clear all data
//         await AuthService.logoutUser();
//         Get.offAllNamed(AppRoute.loginScreen);
//       } else {
//         Get.snackbar(
//           'Error',
//           response.errorMessage ?? 'Failed to delete account. Please try again.',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'An error occurred: ${e.toString()}',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isDeleting.value = false;
//     }
//   }

//   void logout() {
//     AuthService.logoutUser();
//     Get.offAllNamed(AppRoute.loginScreen);
//   }

//   @override
//   void onClose() {
//     deleteConfirmController.dispose();
//     super.onClose();
//   }
// }




import 'package:clause_verify/core/services/auth_service.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {

  var userName = ''.obs;
  var userEmail = ''.obs;
  var isPremium = false.obs;
  var isLoading = false.obs;

  var isDeleting = false.obs;
  TextEditingController deleteConfirmController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    _loadUserData();
  }

  @override
  void onReady() {
    super.onReady();
    refreshFromAPI();
  }

  void _loadUserData() {
    final name = AuthService.userName ?? '';
    final email = AuthService.userEmail ?? '';

    userName.value = name;
    userEmail.value = email;
    isPremium.value = AuthService.isPremium;

    print('👤 User loaded (local): name=$name, email=$email');
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
        // ✅ FIX: response এ কোনো 'data' wrapper নেই, পুরো object টাই root এ
        final data = response.responseData as Map<String, dynamic>;

        await AuthService.saveUserData(data);

        userName.value = AuthService.userName ?? '';
        userEmail.value = AuthService.userEmail ?? '';
        isPremium.value = AuthService.isPremium;

        print('✅ Profile refreshed: name=${userName.value}, email=${userEmail.value}, premium=${isPremium.value}');
      } else {
        print('❌ API Failed: ${response.errorMessage}');
        _loadUserData();
      }
    } catch (e) {
      print('❌ refreshFromAPI error: $e');
      _loadUserData();
    } finally {
      isLoading.value = false;
    }
  }

  void refreshUserData() {
    _loadUserData();
    update();
  }

  Future<void> deleteAccount() async {
    if (deleteConfirmController.text.trim().toLowerCase() != 'i want to delete my account') {
      Get.snackbar(
        'Error',
        'Please type exactly "i want to delete my account" to confirm.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isDeleting.value = true;

    try {
      final networkCaller = NetworkCaller();
      final response = await networkCaller.deleteRequest(
        Endpoints.deleteAccount,
        AuthService.token,
      );

      if (response.isSuccess) {
        Get.back();
        Get.snackbar(
          'Success',
          'Your account has been deleted successfully.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await AuthService.logoutUser();
        Get.offAllNamed(AppRoute.loginScreen);
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to delete account. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  void logout() {
    AuthService.logoutUser();
    Get.offAllNamed(AppRoute.loginScreen);
  }

  @override
  void onClose() {
    deleteConfirmController.dispose();
    super.onClose();
  }
}