import 'dart:async';
import 'package:flutter_extension/core/services/watch_image_services.dart';
import 'package:flutter_extension/routes/app_routes.dart';
import 'package:get/get.dart';

class AccessoriesController extends GetxController {
  final WatchImagesService _imagesService = WatchImagesService.instance;

  // Observable list for selected accessories
  final RxList<String> selectedAccessories = <String>[].obs;

  // Toggle selection
  void toggleSelection(String accessoryId) {
    if (selectedAccessories.contains(accessoryId)) {
      selectedAccessories.remove(accessoryId);
    } else {
      selectedAccessories.add(accessoryId);
    }
  }

  // Check if accessory is selected
  bool isSelected(String accessoryId) {
    return selectedAccessories.contains(accessoryId);
  }

  // Get selected count
  int get selectedCount => selectedAccessories.length;

  // Check if any accessory is selected
  bool get hasSelection => selectedAccessories.isNotEmpty;

  // Start AI Analysis - Navigate immediately and upload in background
  Future<void> startAiAnalysis() async {
    // Check if all images are available
    if (!_imagesService.hasAllImages) {
      Get.snackbar(
        'Error',
        'Please capture all watch images first',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Save accessories selection to service
    _imagesService.setAccessories(
      box: selectedAccessories.contains('original_box'),
      certificate: selectedAccessories.contains('original_certificate'),
      invoice: selectedAccessories.contains('invoice'),
    );

    print('📦 Accessories saved:');
    print('Box: ${_imagesService.hasBox.value}');
    print('Certificate: ${_imagesService.hasCertificate.value}');
    print('Invoice: ${_imagesService.hasInvoice.value}');

    // Immediately navigate to AI Analysis Screen
    Get.offNamed(
      AppRoute.aiAnalysisScreen,
      arguments: {'startUpload': true},
    );

    // Clear local data after navigation
    Future.delayed(Duration(milliseconds: 100), () {
      selectedAccessories.clear();
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}