
import 'package:flutter_extension/core/services/auth_service.dart';
import 'package:flutter_extension/core/services/endpoints.dart';
import 'package:flutter_extension/core/services/network_caller.dart';
import 'package:flutter_extension/features/price_estimation/model/price_estimation_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceEstimationController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();
  
  final Rx<PriceEstimationModel?> priceData = Rx<PriceEstimationModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  
  String? analysisId;

  @override
  void onInit() {
    super.onInit();
    
    // Get analysis ID from arguments
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      analysisId = args['id'];
    }
    
    if (analysisId != null) {
      loadPriceEstimation();
    } else {
      errorMessage.value = 'Analysis ID not found';
      isLoading.value = false;
      print('❌ Analysis ID not found in arguments');
    }
  }

  Future<void> loadPriceEstimation() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('📊 Fetching price estimation for ID: $analysisId');
      
      // Call API with analysis ID
      final response = await _networkCaller.getRequest(
        '${Endpoints.historyDetails}$analysisId/',
      );

      if (response.isSuccess && response.responseData != null) {
        print('✅ Price estimation data received');
        
        // Parse response to model
        priceData.value = PriceEstimationModel.fromJson(response.responseData);
        
        // ✨ Log with current currency from AuthService
        final currency = AuthService.selectedCurrency;
        print('💰 Selected Currency: $currency');
        print('💵 Estimated Price: ${priceData.value?.getEstimatedPrice(currency)}');
        print('📈 Average Score: ${priceData.value?.averageComponentScore}');
        print('🎁 Accessories Count: ${priceData.value?.accessoriesCount}');
        
      } else {
        errorMessage.value = response.errorMessage;
        print('❌ Failed to load price estimation: ${response.errorMessage}');
        
        // Show error snackbar
        Get.snackbar(
          'Error',
          response.errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Color(0xFF1A1A1A),
          colorText: Color(0xFFEF4444),
          duration: Duration(seconds: 3),
        );
      }
      
    } catch (e) {
      errorMessage.value = 'An error occurred while loading data';
      print('💥 Error loading price estimation: $e');
      
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to load price estimation. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF1A1A1A),
        colorText: Color(0xFFEF4444),
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool get hasData => priceData.value != null;
  
  bool get hasError => errorMessage.value.isNotEmpty;

  void refreshData() {
    if (analysisId != null) {
      loadPriceEstimation();
    } else {
      Get.snackbar(
        'Error',
        'Cannot refresh: Analysis ID not found',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF1A1A1A),
        colorText: Color(0xFFEF4444),
      );
    }
  }
  
  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}