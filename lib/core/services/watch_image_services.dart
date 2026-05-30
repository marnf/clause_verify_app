import 'package:get/get.dart';

class WatchImagesService extends GetxService {
  static WatchImagesService get instance => Get.find<WatchImagesService>();

  // Observable image paths
  final Rx<String> frontViewImage = ''.obs;
  final Rx<String> backViewImage = ''.obs;
  final Rx<String> braceletClaspImage = ''.obs;

  // Observable accessories
  final RxBool hasBox = false.obs;
  final RxBool hasCertificate = false.obs;
  final RxBool hasInvoice = false.obs;

  /// Check if all images are captured
  bool get hasAllImages {
    return frontViewImage.value.isNotEmpty &&
           backViewImage.value.isNotEmpty &&
           braceletClaspImage.value.isNotEmpty;
  }

  /// ✅ Check if ANY image exists (for detecting incomplete sessions)
  bool get hasAnyImage {
    return frontViewImage.value.isNotEmpty ||
           backViewImage.value.isNotEmpty ||
           braceletClaspImage.value.isNotEmpty;
  }

  /// ✅ Check if session is incomplete (some images but not all)
  bool get hasIncompleteSession {
    return hasAnyImage && !hasAllImages;
  }

  /// Set all images at once
  void setAllImages({
    required String frontImage,
    required String backImage,
    required String braceletImage,
  }) {
    frontViewImage.value = frontImage;
    backViewImage.value = backImage;
    braceletClaspImage.value = braceletImage;
    print('✅ All watch images saved to service');
  }

  /// Set accessories
  void setAccessories({
    required bool box,
    required bool certificate,
    required bool invoice,
  }) {
    hasBox.value = box;
    hasCertificate.value = certificate;
    hasInvoice.value = invoice;
    print('✅ Accessories saved to service');
  }

  /// Clear all data
  void clearAll() {
    frontViewImage.value = '';
    backViewImage.value = '';
    braceletClaspImage.value = '';
    hasBox.value = false;
    hasCertificate.value = false;
    hasInvoice.value = false;
    print('🗑️ All service data cleared');
  }

  /// ✅ Clear only images (keep accessories)
  void clearImages() {
    frontViewImage.value = '';
    backViewImage.value = '';
    braceletClaspImage.value = '';
    print('🗑️ Images cleared from service');
  }

  /// ✅ Clear only accessories (keep images)
  void clearAccessories() {
    hasBox.value = false;
    hasCertificate.value = false;
    hasInvoice.value = false;
    print('🗑️ Accessories cleared from service');
  }

  /// Debug print current state
  void printCurrentState() {
    print('📊 Service State:');
    print('Front: ${frontViewImage.value.isEmpty ? 'Empty' : 'Has image'}');
    print('Back: ${backViewImage.value.isEmpty ? 'Empty' : 'Has image'}');
    print('Bracelet: ${braceletClaspImage.value.isEmpty ? 'Empty' : 'Has image'}');
    print('Box: ${hasBox.value}');
    print('Certificate: ${hasCertificate.value}');
    print('Invoice: ${hasInvoice.value}');
    print('Has All Images: $hasAllImages');
    print('Has Any Image: $hasAnyImage');
    print('Has Incomplete Session: $hasIncompleteSession');
  }
}