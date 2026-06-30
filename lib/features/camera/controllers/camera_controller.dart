import 'package:country_picker/country_picker.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/country_confirmation_modal.dart';
import 'package:clause_verify/core/utils/constants/country_helper.dart';
import 'package:clause_verify/features/analysis/model/analysis_result_model.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraController extends GetxController {
  final RxList<File> capturedPhotos = <File>[].obs;
  final RxBool isUploading = false.obs;
  final ImagePicker _picker = ImagePicker();

  static const int maxPhotos = 10;
  static const int maxFileSizeMB = 20;

  // ✅ Country Variables
  final Rx<Country?> detectedCountry = Rx<Country?>(null);

  int get remainingSlots => maxPhotos - capturedPhotos.length;
  bool get canAddMore => capturedPhotos.length < maxPhotos;
  bool get hasPhotos => capturedPhotos.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _fetchUserCountry(); // Fetch country in background
  }

  Future<void> _fetchUserCountry() async {
    try {
      final country = await CountryHelper.getCurrentCountry();
      if (country != null) {
        detectedCountry.value = country;
        print('✅ Detected Country: ${country.name}');
      } else {
        detectedCountry.value = Country.parse('CA');
        print('⚠️ Location denied, defaulting to Canada');
      }
    } catch (e) {
      print('❌ Error fetching country: $e');
      detectedCountry.value = Country.parse('CA');
    }
  }

  // ── Take photo with camera ──
  Future<void> takePhoto() async {
    if (!canAddMore) {
      _showLimitWarning();
      return;
    }

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (photo != null) {
        final file = File(photo.path);
        final fileSize = await file.length();
        final fileSizeMB = fileSize / (1024 * 1024);

        if (fileSizeMB > maxFileSizeMB) {
          Get.snackbar(
            'File Too Large',
            'Image size is ${fileSizeMB.toStringAsFixed(1)}MB. Maximum allowed is ${maxFileSizeMB}MB.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
            margin: EdgeInsets.all(16),
            borderRadius: 8,
          );
          return;
        }
        capturedPhotos.add(file);
      }
    } catch (e) {
      print('❌ Camera error: $e');
      Get.snackbar(
        'Camera Error',
        'Could not access the camera. Please check permissions.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  // ── Pick from gallery ──
  Future<void> pickFromGallery() async {
    if (!canAddMore) {
      _showLimitWarning();
      return;
    }

    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 100,
      );

      if (images.isNotEmpty) {
        final remaining = remainingSlots;
        if (images.length > remaining) {
          Get.snackbar(
            'Selection Exceeded',
            'You selected ${images.length} photos, but only $remaining more can be added. Please select up to $remaining photos.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            margin: EdgeInsets.all(16),
            borderRadius: 8,
            duration: Duration(seconds: 4),
          );
          return;
        }

        final newPhotos = <File>[];
        for (var xFile in images) {
          final file = File(xFile.path);
          final fileSize = await file.length();
          final fileSizeMB = fileSize / (1024 * 1024);
          if (fileSizeMB > maxFileSizeMB) continue;
          newPhotos.add(file);
        }
        capturedPhotos.addAll(newPhotos);
      }
    } catch (e) {
      print('❌ Gallery error: $e');
      Get.snackbar(
        'Gallery Error',
        'Could not access the gallery. Please check permissions.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  void _showLimitWarning() {
    Get.snackbar(
      'Limit Reached',
      'You can upload a maximum of $maxPhotos photos per scan.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      duration: Duration(seconds: 2),
    );
  }

  void removePhoto(int index) {
    if (index >= 0 && index < capturedPhotos.length) {
      capturedPhotos.removeAt(index);
    }
  }

  void clearAll() {
    capturedPhotos.clear();
  }

  // ══════════════════════════════════════
  //  SUBMIT FLOW
  // ══════════════════════════════════════
  Future<void> submitForAnalysis() async {
    if (capturedPhotos.isEmpty) {
      Get.snackbar(
        'No Photos',
        'Please take or select at least one photo to continue.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }

    final Country? confirmedCountry = await _showCountryConfirmation();
    if (confirmedCountry == null) return; // User cancelled

    _performUpload(confirmedCountry);
  }

  Future<Country?> _showCountryConfirmation() async {
    final defaultCountry = detectedCountry.value ?? Country.parse('CA');
    return await Get.dialog<Country>(
      CountryConfirmationModal(initialCountry: defaultCountry),
      barrierDismissible: true,
    );
  }

  Future<void> _performUpload(Country country) async {
  try {
    isUploading.value = true;

    final fileList = capturedPhotos
        .map((file) => MapEntry('files', file.path))
        .toList();

    final networkCaller = NetworkCaller();
    final response = await networkCaller.multipartRequest(
      Endpoints.fileUpload,
      files: fileList,
      fields: {'law_country': country.name},
    );

    if (response.isSuccess && response.responseData != null) {
      final dataMap = response.responseData!['data'] as Map<String, dynamic>?;
      if (dataMap == null) {
        Get.snackbar('Error', 'Invalid response format.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
        return;
      }

      final resultModel = AnalysisResultModel.fromJson(dataMap);
      clearAll();
      Get.toNamed(AppRoute.analysisResultScreen, arguments: resultModel);
    } else {
      // ✅ Low resolution check
      final errorData = response.responseData;
      if (errorData != null && errorData['status'] == 'fail' && errorData['reason'] == 'low_resolution') {
        final width = errorData['width'];
        final height = errorData['height'];
        final minRes = errorData['min_resolution'] ?? '300x300';
        Get.snackbar(
          'Image Resolution Too Low',
          'Your image is ${width}x${height}px. Minimum required is $minRes.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar('Error', response.errorMessage ?? 'Upload failed.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    }
  } catch (e) {
    Get.snackbar('Error', 'Something went wrong: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white);
  } finally {
    isUploading.value = false;
  }
}
}
