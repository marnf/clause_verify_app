import 'package:flutter_extension/core/services/watch_image_services.dart';
import 'package:flutter_extension/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class WatchCaptureController extends GetxController {
  final WatchImagesService _imagesService = WatchImagesService.instance;

  final RxInt currentStep = 1.obs;
  final Rx<String?> frontViewImage = Rx<String?>(null);
  final Rx<String?> backViewImage = Rx<String?>(null);
  final Rx<String?> braceletClaspImage = Rx<String?>(null);
  final ImagePicker _picker = ImagePicker();
  final RxBool isLoading = false.obs;

  final List<Map<String, String>> steps = [
    {
      'title': 'frontView'.tr,
      'description': 'captureTheWatchDialStraightOnWithClearDetails'.tr,
    },
    {
      'title': 'backView'.tr,
      'description': 'showTheCasebackWithEngravingsClearlyVisible'.tr,
    },
    {
      'title': 'braceletAndClasp'.tr,
      'description': 'captureTheBraceletAndClaspDetailsClearly'.tr,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    
    // ✅ CRITICAL: সবসময় fresh start - service clear করুন
    print('🔄 WatchCaptureController onInit called');
    _forceFreshStart();
  }

  /// ✅ সবসময় fresh start - এটাই সবচেয়ে ভালো solution
  void _forceFreshStart() {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🧹 Forcing fresh start...');
    
    // Step 1: Service clear করুন
    _imagesService.clearAll();
    print('✅ Service cleared');
    
    // Step 2: Local controller reset করুন
    resetAll();
    print('✅ Controller reset');
    
    // Step 3: Verify করুন
    _debugPrintState();
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  /// Debug: Current state print করুন
  void _debugPrintState() {
    print('📊 Current State:');
    print('   Step: ${currentStep.value}');
    print('   Front: ${frontViewImage.value ?? 'NULL'}');
    print('   Back: ${backViewImage.value ?? 'NULL'}');
    print('   Bracelet: ${braceletClaspImage.value ?? 'NULL'}');
    print('   Service Front: ${_imagesService.frontViewImage.value}');
    print('   Service Back: ${_imagesService.backViewImage.value}');
    print('   Service Bracelet: ${_imagesService.braceletClaspImage.value}');
  }

  String getCurrentStepTitle() {
    return steps[currentStep.value - 1]['title'] ?? '';
  }

  String getCurrentStepDescription() {
    return steps[currentStep.value - 1]['description'] ?? '';
  }

  String? getCapturedImage() {
    switch (currentStep.value) {
      case 1:
        return frontViewImage.value;
      case 2:
        return backViewImage.value;
      case 3:
        return braceletClaspImage.value;
      default:
        return null;
    }
  }

  void setCapturedImage(String imagePath) {
    print('📸 Setting image for step ${currentStep.value}: $imagePath');
    
    switch (currentStep.value) {
      case 1:
        frontViewImage.value = imagePath;
        break;
      case 2:
        backViewImage.value = imagePath;
        break;
      case 3:
        braceletClaspImage.value = imagePath;
        break;
    }
    
    _debugPrintState();
  }

  bool canProceedToNext() {
    return getCapturedImage() != null;
  }

  Future<void> capturePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo != null) {
        setCapturedImage(photo.path);
        print('✅ Photo captured: ${photo.path}');
      }
    } catch (e) {
      print('❌ Camera error: $e');
    }
  }

  Future<void> uploadFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setCapturedImage(image.path);
        print('✅ Photo uploaded: ${image.path}');
      }
    } catch (e) {
      print('❌ Gallery error: $e');
    }
  }

  void goToNextStep() {
    if (!canProceedToNext()) {
      return;
    }

    if (currentStep.value < 3) {
      currentStep.value++;
      print('📍 Moved to step ${currentStep.value}');
    } else {
      completeCapture();
    }
  }

  void goToPreviousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
      print('📍 Moved back to step ${currentStep.value}');
    }
  }

  void completeCapture() {
    if (frontViewImage.value == null ||
        backViewImage.value == null ||
        braceletClaspImage.value == null) {
      print('❌ All images not captured');
      return;
    }

    // ✅ Service এ save করুন
    _imagesService.setAllImages(
      frontImage: frontViewImage.value!,
      backImage: backViewImage.value!,
      braceletImage: braceletClaspImage.value!,
    );

    print('✅ All images saved to WatchImagesService');
    print('Front: ${_imagesService.frontViewImage.value}');
    print('Back: ${_imagesService.backViewImage.value}');
    print('Bracelet: ${_imagesService.braceletClaspImage.value}');

    Get.toNamed(AppRoute.accessoriesScreen);
  }

  void retakeCurrentPhoto() {
    setCapturedImage('');
  }

  void resetAll() {
    currentStep.value = 1;
    frontViewImage.value = null;
    backViewImage.value = null;
    braceletClaspImage.value = null;
    print('🔄 Controller reset completed');
  }

  Map<String, String?> getAllCapturedImages() {
    return {
      'front_view': frontViewImage.value,
      'back_view': backViewImage.value,
      'bracelet_clasp': braceletClaspImage.value,
    };
  }

  bool areAllPhotosCaptured() {
    return frontViewImage.value != null &&
        backViewImage.value != null &&
        braceletClaspImage.value != null;
  }

  @override
  void onClose() {
    print('🔴 WatchCaptureController onClose called');
    super.onClose();
  }
}