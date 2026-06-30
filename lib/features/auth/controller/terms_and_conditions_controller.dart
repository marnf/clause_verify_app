
import 'package:clause_verify/routes/app_routes.dart';
import 'package:get/get.dart';

class TermsConditionsController extends GetxController {
  // Observable variable for checkbox
  final RxBool isAgreed = false.obs;

  // Toggle checkbox
  void toggleCheckbox() {
    isAgreed.value = !isAgreed.value;
  }

  // Accept button action
  void onAcceptPressed() {
    if (!isAgreed.value) {
      // Get.snackbar(
      //   'Error',          
      //   'Please agree to the terms and conditions',
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      return;
    }

    // Save acceptance to local storage or state management
    saveTermsAcceptance();



    // Navigate to next screen
    // Get.offAll(() => HomeScreen()); // Replace with your screen
    // Or just go back
     Get.offNamed(AppRoute.navBar);
  }

  // Save terms acceptance (can be stored in SharedPreferences or similar)
  void saveTermsAcceptance() {
    // Example: Store in GetStorage or SharedPreferences
    // final storage = GetStorage();
    // storage.write('terms_accepted', true);
    // storage.write('terms_accepted_date', DateTime.now().toString());
    
    print('Terms accepted at: ${DateTime.now()}');
  }

  // Check if terms are already accepted (call this on app start)
  bool checkTermsAcceptance() {
    // Example: Check from GetStorage or SharedPreferences
    // final storage = GetStorage();
    // return storage.read('terms_accepted') ?? false;
    
    return false;
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}