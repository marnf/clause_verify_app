
import 'package:flutter_extension/core/services/endpoints.dart';
import 'package:flutter_extension/core/services/network_caller.dart';
import 'package:flutter_extension/features/history/model/history_model.dart';
import 'package:flutter_extension/routes/app_routes.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();
  
  // Observable list - using RxList properly
  var historyList = <HistoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistoryData();
  }

  // Fetch history data from API
  Future<void> fetchHistoryData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _networkCaller.getRequest(
        Endpoints.history,
      );
      

      if (response.isSuccess && response.responseData != null) {
        // Parse the response
        final List<dynamic> data = response.responseData as List<dynamic>;
        
        // Convert to HistoryModel list
        final List<HistoryModel> newList = data.map((json) {
          final apiModel = HistoryApiModel.fromJson(json as Map<String, dynamic>);
          return HistoryModel.fromApiModel(apiModel);
        }).toList();

        // Update RxList
        historyList.assignAll(newList);

        print('✅ History data loaded: ${historyList.length} items');
      } else {
        errorMessage.value = response.errorMessage ?? 'Failed to load history';
        print('❌ Error: ${errorMessage.value}');
        
        // Get.snackbar(
        //   'Error',
        //   errorMessage.value,
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Color(0xFF1A1A1A),
        //   colorText: Color(0xFFFFFFFF),
        // );
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print('❌ Exception: $e');
      
      // Get.snackbar(
      //   'Error',
      //   'Failed to load history data',
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Color(0xFF1A1A1A),
      //   colorText: Color(0xFFFFFFFF),
      // );
    } finally {
      isLoading.value = false;
    }
  }

  // Navigate to details with ID
  void navigateToDetails(HistoryModel item) {
    if (item.id == null || item.id!.isEmpty) {
      // Get.snackbar(
      //   'Error',
      //   'Invalid history item',
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Color(0xFF1A1A1A),
      //   colorText: Color(0xFFFFFFFF),
      // );
      return;
    }

    print('✅ Navigating to details with ID: ${item.id}');
    
    // Navigate to preview screen with the ID as argument
    Get.toNamed(
      AppRoute.historyPreview,
      arguments: {'id': item.id},
    );
  }

  // Refresh data
  Future<void> refreshData() async {
    await fetchHistoryData();
  }

  @override
  void onClose() {
    historyList.clear();
    super.onClose();
  }
}