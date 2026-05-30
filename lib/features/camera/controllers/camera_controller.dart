// // import 'package:flutter_extension/core/services/endpoints.dart';
// // import 'package:flutter_extension/core/services/network_caller.dart';
// // import 'package:flutter_extension/core/utils/constants/app_colors.dart';
// // import 'package:flutter_extension/routes/app_routes.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'dart:io';

// // class CameraController extends GetxController {
// //   final RxList<File> capturedPhotos = <File>[].obs;
// //   final RxBool isUploading = false.obs;
// //   final ImagePicker _picker = ImagePicker();

// //   static const int maxPhotos = 10; // ✅ Changed from 15 to 10
// //   static const int maxFileSizeMB = 20;

// //   int get remainingSlots => maxPhotos - capturedPhotos.length;
// //   bool get canAddMore => capturedPhotos.length < maxPhotos;
// //   bool get hasPhotos => capturedPhotos.isNotEmpty;

// //   // ── Take photo with camera ──
// //   Future<void> takePhoto() async {
// //     if (!canAddMore) {
// //       _showLimitWarning();
// //       return;
// //     }

// //     try {
// //       final XFile? photo = await _picker.pickImage(
// //         source: ImageSource.camera,
// //         imageQuality: 100,
// //       );

// //       if (photo != null) {
// //         final file = File(photo.path);
// //         final fileSize = await file.length();
// //         final fileSizeMB = fileSize / (1024 * 1024);
        
// //         if (fileSizeMB > maxFileSizeMB) {
// //           Get.snackbar(
// //             'File Too Large',
// //             'Image size is ${fileSizeMB.toStringAsFixed(1)}MB. Maximum allowed is ${maxFileSizeMB}MB.',
// //             snackPosition: SnackPosition.TOP,
// //             backgroundColor: AppColors.error,
// //             colorText: Colors.white,
// //             margin: EdgeInsets.all(16),
// //             borderRadius: 8,
// //           );
// //           return;
// //         }

// //         capturedPhotos.add(file);
// //       }
// //     } catch (e) {
// //       print('❌ Camera error: $e');
// //       Get.snackbar(
// //         'Camera Error',
// //         'Could not access the camera. Please check permissions.',
// //         snackPosition: SnackPosition.TOP,
// //         backgroundColor: AppColors.error,
// //         colorText: Colors.white,
// //         margin: EdgeInsets.all(16),
// //         borderRadius: 8,
// //       );
// //     }
// //   }

// //   // ── Pick from gallery ──
// //   Future<void> pickFromGallery() async {
// //     if (!canAddMore) {
// //       _showLimitWarning();
// //       return;
// //     }

// //     try {
// //       final List<XFile> images = await _picker.pickMultiImage(
// //         imageQuality: 100,
// //       );

// //       if (images.isNotEmpty) {
// //         final remaining = remainingSlots;

// //         // ✅ NEW LOGIC: If user selected more than remaining, reject ALL and warn them
// //         if (images.length > remaining) {
// //           Get.snackbar(
// //             'Selection Exceeded',
// //             'You selected ${images.length} photos, but only $remaining more can be added. Please select up to $remaining photos.',
// //             snackPosition: SnackPosition.TOP,
// //             backgroundColor: Colors.orange,
// //             colorText: Colors.white,
// //             margin: EdgeInsets.all(16),
// //             borderRadius: 8,
// //             duration: Duration(seconds: 4),
// //           );
// //           return; // Don't add any photo so user understands the limit
// //         }

// //         // If selected <= remaining, validate size and add
// //         final newPhotos = <File>[];
// //         for (var xFile in images) {
// //           final file = File(xFile.path);
// //           final fileSize = await file.length();
// //           final fileSizeMB = fileSize / (1024 * 1024);

// //           if (fileSizeMB > maxFileSizeMB) continue;

// //           newPhotos.add(file);
// //         }

// //         capturedPhotos.addAll(newPhotos);
// //       }
// //     } catch (e) {
// //       print('❌ Gallery error: $e');
// //       Get.snackbar(
// //         'Gallery Error',
// //         'Could not access the gallery. Please check permissions.',
// //         snackPosition: SnackPosition.TOP,
// //         backgroundColor: AppColors.error,
// //         colorText: Colors.white,
// //         margin: EdgeInsets.all(16),
// //         borderRadius: 8,
// //       );
// //     }
// //   }

// //   void _showLimitWarning() {
// //     Get.snackbar(
// //       'Limit Reached',
// //       'You can upload a maximum of $maxPhotos photos per scan.',
// //       snackPosition: SnackPosition.TOP,
// //       backgroundColor: AppColors.error,
// //       colorText: Colors.white,
// //       margin: EdgeInsets.all(16),
// //       borderRadius: 8,
// //       duration: Duration(seconds: 2),
// //     );
// //   }

// //   // ── Remove a photo ──
// //   void removePhoto(int index) {
// //     if (index >= 0 && index < capturedPhotos.length) {
// //       capturedPhotos.removeAt(index);
// //     }
// //   }

// //   // ── Clear all ──
// //   void clearAll() {
// //     capturedPhotos.clear();
// //   }

// //   // ── Submit photos for analysis ──
// //   Future<void> submitForAnalysis() async {
// //     if (capturedPhotos.isEmpty) {
// //       Get.snackbar(
// //         'No Photos',
// //         'Please take or select at least one photo to continue.',
// //         snackPosition: SnackPosition.TOP,
// //         backgroundColor: AppColors.error,
// //         colorText: Colors.white,
// //         margin: EdgeInsets.all(16),
// //         borderRadius: 8,
// //       );
// //       return;
// //     }

// //     isUploading.value = true;

// //     try {
// //       final Map<String, String> filesMap = {};
// //       for (int i = 0; i < capturedPhotos.length; i++) {
// //         filesMap['photo_$i'] = capturedPhotos[i].path;
// //       }

// //       final NetworkCaller networkCaller = NetworkCaller();
// //       final response = await networkCaller.multipartRequest(
// //         Endpoints.scan,
// //         files: filesMap,
// //       );

// //       if (response.isSuccess) {
// //         Get.snackbar(
// //           'Success',
// //           'Your contract is being analysed!',
// //           snackPosition: SnackPosition.TOP,
// //           backgroundColor: AppColors.success,
// //           colorText: Colors.white,
// //           margin: EdgeInsets.all(16),
// //           borderRadius: 8,
// //           duration: Duration(seconds: 3),
// //         );

// //         clearAll();

// //         Future.delayed(Duration(seconds: 1), () {
// //           Get.offAllNamed(AppRoute.homeScreen);
// //         });
// //       } else {
// //         Get.snackbar(
// //           'Upload Failed',
// //           response.errorMessage.isNotEmpty
// //               ? response.errorMessage
// //               : 'Something went wrong. Please try again.',
// //           snackPosition: SnackPosition.TOP,
// //           backgroundColor: AppColors.error,
// //           colorText: Colors.white,
// //           margin: EdgeInsets.all(16),
// //           borderRadius: 8,
// //         );
// //       }
// //     } catch (e) {
// //       print('❌ Upload error: $e');
// //       Get.snackbar(
// //         'Network Error',
// //         'Please check your internet connection and try again.',
// //         snackPosition: SnackPosition.TOP,
// //         backgroundColor: AppColors.error,
// //         colorText: Colors.white,
// //         margin: EdgeInsets.all(16),
// //         borderRadius: 8,
// //       );
// //     } finally {
// //       isUploading.value = false;
// //     }
// //   }
// // }





// import 'package:country_picker/country_picker.dart';
// import 'package:flutter_extension/core/services/endpoints.dart';
// import 'package:flutter_extension/core/services/network_caller.dart';
// import 'package:flutter_extension/core/utils/constants/app_colors.dart';
// import 'package:flutter_extension/core/utils/constants/country_confirmation_modal.dart';
// import 'package:flutter_extension/core/utils/constants/country_helper.dart';
// import 'package:flutter_extension/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class CameraController extends GetxController {
//   final RxList<File> capturedPhotos = <File>[].obs;
//   final RxBool isUploading = false.obs;
//   final ImagePicker _picker = ImagePicker();

//   static const int maxPhotos = 10;
//   static const int maxFileSizeMB = 20;

//   // ✅ Country Variables
//   final Rx<Country?> detectedCountry = Rx<Country?>(null);

//   int get remainingSlots => maxPhotos - capturedPhotos.length;
//   bool get canAddMore => capturedPhotos.length < maxPhotos;
//   bool get hasPhotos => capturedPhotos.isNotEmpty;

//   @override
//   void onInit() {
//     super.onInit();
//     _fetchUserCountry(); // ✅ Fetch country on background
//   }

//   // ✅ Fetch User Country in Background
//   Future<void> _fetchUserCountry() async {
//     try {
//       final country = await CountryHelper.getCurrentCountry();
//       if (country != null) {
//         detectedCountry.value = country;
//         print('✅ Detected Country: ${country.name}');
//       } else {
//         // Default to Canada if location is denied (As per your app info: Qlox Inc. Ontario, Canada)
//         detectedCountry.value = Country.parse('CA');
//         print('⚠️ Location denied, defaulting to Canada');
//       }
//     } catch (e) {
//       print('❌ Error fetching country: $e');
//       detectedCountry.value = Country.parse('CA');
//     }
//   }

//   // ... (Keep all existing methods: takePhoto, pickFromGallery, removePhoto, clearAll exactly as they are) ...

//   Future<void> takePhoto() async {
//     // existing code
//   }

//   Future<void> pickFromGallery() async {
//     // existing code
//   }

//   void removePhoto(int index) {
//     // existing code
//   }

//   void clearAll() {
//     capturedPhotos.clear();
//   }

//   // ══════════════════════════════════════
//   //  SUBMIT FLOW (Updated)
//   // ══════════════════════════════════════
//   Future<void> submitForAnalysis() async {
//     if (capturedPhotos.isEmpty) {
//       Get.snackbar(
//         'No Photos',
//         'Please take or select at least one photo to continue.',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: AppColors.error,
//         colorText: Colors.white,
//         margin: EdgeInsets.all(16),
//         borderRadius: 8,
//       );
//       return;
//     }

//     // ✅ STEP 1: Show Country Confirmation Modal First
//     final Country? confirmedCountry = await _showCountryConfirmation();
//     if (confirmedCountry == null) return; // User cancelled

//     // ✅ STEP 2: If confirmed, proceed to upload
//     _performUpload(confirmedCountry);
//   }

//   // ✅ Show Country Confirmation Modal
//   Future<Country?> _showCountryConfirmation() async {
//     // If country detection is still loading, wait a bit or default
//     final defaultCountry = detectedCountry.value ?? Country.parse('CA');

//     return await Get.dialog<Country>(
//       CountryConfirmationModal(
//         initialCountry: defaultCountry,
//         onConfirm: (Country country) {
//           // This just pops the dialog, the return is handled by Get.dialog
//         },
//       ),
//       barrierDismissible: true,
//     );
//   }

//   // ✅ Actual Upload Process
//   Future<void> _performUpload(Country country) async {
//     isUploading.value = true;

//     try {
//       final Map<String, String> filesMap = {};
//       for (int i = 0; i < capturedPhotos.length; i++) {
//         filesMap['photo_$i'] = capturedPhotos[i].path;
//       }

//       final NetworkCaller networkCaller = NetworkCaller();
//       final response = await networkCaller.multipartRequest(
//         Endpoints.scan,
//         files: filesMap,
//         fields: {
//           'country_code': country.countryCode, // ✅ Sending Country Code to API
//         },
//       );

//       if (response.isSuccess) {
//         Get.snackbar(
//           'Success',
//           'Your contract is being analysed!',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: AppColors.success,
//           colorText: Colors.white,
//           margin: EdgeInsets.all(16),
//           borderRadius: 8,
//           duration: Duration(seconds: 3),
//         );
//         clearAll();
//         Future.delayed(Duration(seconds: 1), () {
//           Get.offAllNamed(AppRoute.homeScreen);
//         });
//       } else {
//         Get.snackbar(
//           'Upload Failed',
//           response.errorMessage.isNotEmpty
//               ? response.errorMessage
//               : 'Something went wrong. Please try again.',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: AppColors.error,
//           colorText: Colors.white,
//           margin: EdgeInsets.all(16),
//           borderRadius: 8,
//         );
//       }
//     } catch (e) {
//       print('❌ Upload error: $e');
//       Get.snackbar(
//         'Network Error',
//         'Please check your internet connection and try again.',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: AppColors.error,
//         colorText: Colors.white,
//         margin: EdgeInsets.all(16),
//         borderRadius: 8,
//       );
//     } finally {
//       isUploading.value = false;
//     }
//   }
// }



import 'package:country_picker/country_picker.dart';
import 'package:flutter_extension/core/services/endpoints.dart';
import 'package:flutter_extension/core/services/network_caller.dart';
import 'package:flutter_extension/core/utils/constants/app_colors.dart';
import 'package:flutter_extension/core/utils/constants/country_confirmation_modal.dart';
import 'package:flutter_extension/core/utils/constants/country_helper.dart';
import 'package:flutter_extension/routes/app_routes.dart';
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
          Get.snackbar('File Too Large', 'Image size is ${fileSizeMB.toStringAsFixed(1)}MB. Maximum allowed is ${maxFileSizeMB}MB.', snackPosition: SnackPosition.TOP, backgroundColor: AppColors.error, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8);
          return;
        }
        capturedPhotos.add(file);
      }
    } catch (e) {
      print('❌ Camera error: $e');
      Get.snackbar('Camera Error', 'Could not access the camera. Please check permissions.', snackPosition: SnackPosition.TOP, backgroundColor: AppColors.error, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8);
    }
  }

  // ── Pick from gallery ──
  Future<void> pickFromGallery() async {
    if (!canAddMore) {
      _showLimitWarning();
      return;
    }

    try {
      final List<XFile> images = await _picker.pickMultiImage(imageQuality: 100);

      if (images.isNotEmpty) {
        final remaining = remainingSlots;
        if (images.length > remaining) {
          Get.snackbar('Selection Exceeded', 'You selected ${images.length} photos, but only $remaining more can be added. Please select up to $remaining photos.', snackPosition: SnackPosition.TOP, backgroundColor: Colors.orange, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8, duration: Duration(seconds: 4));
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
      Get.snackbar('Gallery Error', 'Could not access the gallery. Please check permissions.', snackPosition: SnackPosition.TOP, backgroundColor: AppColors.error, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8);
    }
  }

  void _showLimitWarning() {
    Get.snackbar('Limit Reached', 'You can upload a maximum of $maxPhotos photos per scan.', snackPosition: SnackPosition.TOP, backgroundColor: AppColors.error, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8, duration: Duration(seconds: 2));
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
      Get.snackbar('No Photos', 'Please take or select at least one photo to continue.', snackPosition: SnackPosition.TOP, backgroundColor: AppColors.error, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8);
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
    isUploading.value = true;

    try {
      final Map<String, String> filesMap = {};
      for (int i = 0; i < capturedPhotos.length; i++) {
        filesMap['photo_$i'] = capturedPhotos[i].path;
      }

      final NetworkCaller networkCaller = NetworkCaller();
      final response = await networkCaller.multipartRequest(
        Endpoints.scan,
        files: filesMap,
        fields: {
          'country_code': country.countryCode, // ✅ Country Code sent
        },
      );

      if (response.isSuccess) {
        Get.snackbar('Success', 'Your contract is being analysed!', snackPosition: SnackPosition.TOP, backgroundColor: AppColors.success, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8, duration: Duration(seconds: 3));
        clearAll();
        Future.delayed(Duration(seconds: 1), () {
          Get.offAllNamed(AppRoute.homeScreen);
        });
      } else {
        Get.snackbar('Upload Failed', response.errorMessage.isNotEmpty ? response.errorMessage : 'Something went wrong. Please try again.', snackPosition: SnackPosition.TOP, backgroundColor: AppColors.error, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8);
      }
    } catch (e) {
      print('❌ Upload error: $e');
      Get.snackbar('Network Error', 'Please check your internet connection and try again.', snackPosition: SnackPosition.TOP, backgroundColor: AppColors.error, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8);
    } finally {
      isUploading.value = false;
    }
  }
}