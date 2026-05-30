// // import 'package:flutter_extension/core/services/Auth_service.dart';
// // import 'package:flutter_extension/core/services/endpoints.dart';
// // import 'package:flutter_extension/core/services/network_caller.dart';
// // import 'package:flutter_extension/core/utils/constants/app_colors.dart';
// // import 'package:flutter_extension/routes/app_routes.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:file_picker/file_picker.dart';
// // import 'dart:io';

// // class UploadController extends GetxController {
// //   final RxList<File> selectedFiles = <File>[].obs;
// //   final RxList<String> fileNames = <String>[].obs;
// //   final RxList<int> fileSizes = <int>[].obs;
// //   final RxBool isUploading = false.obs;

// //   static const int maxFiles = 15;
// //   static const int maxFileSizeMB = 20; // 20MB per file

// //   // ── Allowed extensions ──
// //   static const List<String> allowedExtensions = [
// //     'pdf',
// //     'jpg',
// //     'jpeg',
// //     'png',
// //     'doc',
// //     'docx',
// //   ];

// //   int get remainingSlots => maxFiles - selectedFiles.length;
// //   bool get canAddMore => selectedFiles.length < maxFiles;
// //   bool get hasFiles => selectedFiles.isNotEmpty;

// //   // ── Browse files from device ──
// //   Future<void> browseFiles() async {
// //     if (!canAddMore) {
// //       Get.snackbar(
// //         'fileLimitReached'.tr,
// //         'maxFilesAllowed'.tr,
// //         snackPosition: SnackPosition.TOP,
// //         backgroundColor: AppColors.error,
// //         colorText: Colors.white,
// //         margin: EdgeInsets.all(16),
// //         borderRadius: 8,
// //         duration: Duration(seconds: 2),
// //       );
// //       return;
// //     }

// //     try {
// //       FilePickerResult? result = await FilePicker.platform.pickFiles(
// //         type: FileType.custom,
// //         allowedExtensions: allowedExtensions,
// //         allowMultiple: true,
// //       );

// //       if (result != null) {
// //         final newFiles = <File>[];
// //         final newNames = <String>[];
// //         final newSizes = <int>[];

// //         for (var platformFile in result.files) {
// //           if (platformFile.path == null) continue;

// //           final file = File(platformFile.path!);

// //           // Check file size
// //           final fileSize = await file.length();
// //           final fileSizeMB = fileSize / (1024 * 1024);
// //           if (fileSizeMB > maxFileSizeMB) {
// //             Get.snackbar(
// //               'fileTooLarge'.tr,
// //               '${platformFile.name}: ${fileSizeMB.toStringAsFixed(1)}MB > ${maxFileSizeMB}MB',
// //               snackPosition: SnackPosition.TOP,
// //               backgroundColor: AppColors.error,
// //               colorText: Colors.white,
// //               margin: EdgeInsets.all(16),
// //               borderRadius: 8,
// //               duration: Duration(seconds: 3),
// //             );
// //             continue;
// //           }

// //           // Check remaining slots
// //           if (newFiles.length + selectedFiles.length >= maxFiles) {
// //             Get.snackbar(
// //               'fileLimitReached'.tr,
// //               'maxFilesAllowed'.tr,
// //               snackPosition: SnackPosition.TOP,
// //               backgroundColor: Colors.orange,
// //               colorText: Colors.white,
// //               margin: EdgeInsets.all(16),
// //               borderRadius: 8,
// //             );
// //             break;
// //           }

// //           newFiles.add(file);
// //           newNames.add(platformFile.name);
// //           newSizes.add(fileSize);
// //         }

// //         selectedFiles.addAll(newFiles);
// //         fileNames.addAll(newNames);
// //         fileSizes.addAll(newSizes);
// //       }
// //     } catch (e) {
// //       print('❌ Error picking files: $e');
// //       Get.snackbar(
// //         'error'.tr,
// //         'filePickFailed'.tr,
// //         snackPosition: SnackPosition.TOP,
// //         backgroundColor: AppColors.error,
// //         colorText: Colors.white,
// //         margin: EdgeInsets.all(16),
// //         borderRadius: 8,
// //       );
// //     }
// //   }

// //   // ── Remove a file ──
// //   void removeFile(int index) {
// //     if (index >= 0 && index < selectedFiles.length) {
// //       selectedFiles.removeAt(index);
// //       fileNames.removeAt(index);
// //       fileSizes.removeAt(index);
// //     }
// //   }

// //   // ── Clear all files ──
// //   void clearAll() {
// //     selectedFiles.clear();
// //     fileNames.clear();
// //     fileSizes.clear();
// //   }

// //   // ── Get file icon based on extension ──
// //   IconData getFileIcon(String fileName) {
// //     final ext = fileName.split('.').last.toLowerCase();
// //     switch (ext) {
// //       case 'pdf':
// //         return Icons.picture_as_pdf_rounded;
// //       case 'jpg':
// //       case 'jpeg':
// //       case 'png':
// //         return Icons.image_rounded;
// //       case 'doc':
// //       case 'docx':
// //         return Icons.description_rounded;
// //       default:
// //         return Icons.insert_drive_file_rounded;
// //     }
// //   }

// //   // ── Get file color based on extension ──
// //   Color getFileColor(String fileName) {
// //     final ext = fileName.split('.').last.toLowerCase();
// //     switch (ext) {
// //       case 'pdf':
// //         return Colors.redAccent;
// //       case 'jpg':
// //       case 'jpeg':
// //       case 'png':
// //         return Colors.blueAccent;
// //       case 'doc':
// //       case 'docx':
// //         return Colors.blue;
// //       default:
// //         return AppColors.textMuted;
// //     }
// //   }

// //   // ── Format file size ──
// //   String formatFileSize(int bytes) {
// //     if (bytes < 1024) return '$bytes B';
// //     if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
// //     return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
// //   }

// //   // ── Submit files for analysis using NetworkCaller ──
// //   Future<void> submitForAnalysis() async {
// //     if (selectedFiles.isEmpty) {
// //       Get.snackbar(
// //         'error'.tr,
// //         'noFilesSelected'.tr,
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
// //       // ✅ Prepare files map for NetworkCaller
// //       final Map<String, String> filesMap = {};
// //       for (int i = 0; i < selectedFiles.length; i++) {
// //         filesMap['file_$i'] = selectedFiles[i].path;
// //       }

// //       // ✅ Call API using NetworkCaller
// //       final NetworkCaller networkCaller = NetworkCaller();
// //       final response = await networkCaller.multipartRequest(
// //         Endpoints.scan,
// //         files: filesMap,
// //         // fields: {'type': 'document'}, // Optional: if backend needs extra text fields
// //       );

// //       if (response.isSuccess) {
// //         Get.snackbar(
// //           'success'.tr,
// //           'analysisStarted'.tr,
// //           snackPosition: SnackPosition.TOP,
// //           backgroundColor: AppColors.success,
// //           colorText: Colors.white,
// //           margin: EdgeInsets.all(16),
// //           borderRadius: 8,
// //           duration: Duration(seconds: 3),
// //         );

// //         clearAll();

// //         // Navigate to main screen after delay
// //         Future.delayed(Duration(seconds: 1), () {
// //           Get.offAllNamed(AppRoute.homeScreen);
// //         });
// //       } else {
// //         Get.snackbar(
// //           'error'.tr,
// //           response.errorMessage.isNotEmpty
// //               ? response.errorMessage
// //               : 'uploadFailed'.tr,
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
// //         'error'.tr,
// //         'networkError'.tr,
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




// import 'package:flutter_extension/core/services/endpoints.dart';
// import 'package:flutter_extension/core/services/network_caller.dart';
// import 'package:flutter_extension/core/utils/constants/app_colors.dart';
// import 'package:flutter_extension/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';

// class UploadController extends GetxController {
//   final RxList<File> selectedFiles = <File>[].obs;
//   final RxList<String> fileNames = <String>[].obs;
//   final RxList<int> fileSizes = <int>[].obs;
//   final RxBool isUploading = false.obs;

//   // ✅ Dynamic Mode: null = not set, true = Document (PDF/DOC), false = Image
//   final Rx<bool?> isDocumentMode = Rx<bool?>(null);

//   static const int maxFileSizeMB = 20;

//   static const List<String> imageExtensions = ['jpg', 'jpeg', 'png'];
//   static const List<String> docExtensions = ['pdf', 'doc', 'docx'];
//   static const List<String> allowedExtensions = [...imageExtensions, ...docExtensions];

//   int get effectiveMaxFiles {
//     if (isDocumentMode.value == true) return 1; // Document mode: only 1 file
//     return 10; // Image mode: max 10 files
//   }

//   int get remainingSlots => effectiveMaxFiles - selectedFiles.length;
//   bool get canAddMore => selectedFiles.length < effectiveMaxFiles;
//   bool get hasFiles => selectedFiles.isNotEmpty;
//   bool get isImageMode => isDocumentMode.value == false;

//   // ── Browse files from device ──
//   Future<void> browseFiles() async {
//     if (!canAddMore) {
//       Get.snackbar(
//         'Limit Reached',
//         isDocumentMode.value == true 
//             ? 'You can only upload 1 document at a time.'
//             : 'You can upload a maximum of 10 images.',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: AppColors.error,
//         colorText: Colors.white,
//         margin: EdgeInsets.all(16),
//         borderRadius: 8,
//       );
//       return;
//     }

//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: allowedExtensions,
//         allowMultiple: true,
//       );

//       if (result != null && result.files.isNotEmpty) {
//         // 1. Check what type of files user selected
//         bool? pickedIsDoc;
//         for (var file in result.files) {
//           final ext = file.name.split('.').last.toLowerCase();
//           final isDoc = docExtensions.contains(ext);
          
//           if (pickedIsDoc == null) {
//             pickedIsDoc = isDoc; // Set mode based on first file
//           } else if (pickedIsDoc != isDoc) {
//             // MIXED SELECTION (e.g., 1 PDF + 1 JPG)
//             Get.snackbar(
//               'Invalid Selection',
//               'Please select either a document OR images, not both.',
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.orange,
//               colorText: Colors.white,
//               margin: EdgeInsets.all(16),
//               borderRadius: 8,
//             );
//             return;
//           }
//         }

//         // 2. Check compatibility with already selected files
//         if (isDocumentMode.value != null && isDocumentMode.value != pickedIsDoc) {
//           String msg = isDocumentMode.value == true 
//               ? 'You already selected a document. Clear it first to upload images.' 
//               : 'You already selected images. Clear them first to upload a document.';
//           Get.snackbar(
//             'Type Mismatch',
//             msg,
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//             margin: EdgeInsets.all(16),
//             borderRadius: 8,
//           );
//           return;
//         }

//         // 3. Check limits specifically
//         final remaining = remainingSlots;
//         if (pickedIsDoc == true && result.files.length > 1) {
//           Get.snackbar(
//             'Limit Exceeded',
//             'You can only upload 1 document at a time.',
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//             margin: EdgeInsets.all(16),
//             borderRadius: 8,
//           );
//           return;
//         }

//         if (pickedIsDoc == false && result.files.length > remaining) {
//           Get.snackbar(
//             'Selection Exceeded',
//             'You selected ${result.files.length} images, but only $remaining more can be added. Please select up to $remaining images.',
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//             margin: EdgeInsets.all(16),
//             borderRadius: 8,
//           );
//           return;
//         }

//         // 4. If all checks pass, add files
//         final newFiles = <File>[];
//         final newNames = <String>[];
//         final newSizes = <int>[];

//         for (var platformFile in result.files) {
//           if (platformFile.path == null) continue;

//           final file = File(platformFile.path!);
//           final fileSize = await file.length();
//           final fileSizeMB = fileSize / (1024 * 1024);
          
//           if (fileSizeMB > maxFileSizeMB) {
//             Get.snackbar(
//               'File Too Large',
//               '${platformFile.name}: ${fileSizeMB.toStringAsFixed(1)}MB > ${maxFileSizeMB}MB',
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: AppColors.error,
//               colorText: Colors.white,
//               margin: EdgeInsets.all(16),
//               borderRadius: 8,
//             );
//             continue;
//           }

//           newFiles.add(file);
//           newNames.add(platformFile.name);
//           newSizes.add(fileSize);
//         }

//         if (newFiles.isNotEmpty) {
//           isDocumentMode.value = isDocumentMode.value ?? pickedIsDoc; // Lock the mode
//           selectedFiles.addAll(newFiles);
//           fileNames.addAll(newNames);
//           fileSizes.addAll(newSizes);
//         }
//       }
//     } catch (e) {
//       print('❌ Error picking files: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to pick files. Please try again.',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: AppColors.error,
//         colorText: Colors.white,
//         margin: EdgeInsets.all(16),
//         borderRadius: 8,
//       );
//     }
//   }

//   // ── Remove a file ──
//   void removeFile(int index) {
//     if (index >= 0 && index < selectedFiles.length) {
//       selectedFiles.removeAt(index);
//       fileNames.removeAt(index);
//       fileSizes.removeAt(index);
      
//       // If list becomes empty, reset the mode
//       if (selectedFiles.isEmpty) {
//         isDocumentMode.value = null;
//       }
//     }
//   }

//   // ── Clear all files ──
//   void clearAll() {
//     selectedFiles.clear();
//     fileNames.clear();
//     fileSizes.clear();
//     isDocumentMode.value = null; // Reset mode
//   }

//   // ── Get file icon based on extension ──
//   IconData getFileIcon(String fileName) {
//     final ext = fileName.split('.').last.toLowerCase();
//     switch (ext) {
//       case 'pdf':
//         return Icons.picture_as_pdf_rounded;
//       case 'jpg':
//       case 'jpeg':
//       case 'png':
//         return Icons.image_rounded;
//       case 'doc':
//       case 'docx':
//         return Icons.description_rounded;
//       default:
//         return Icons.insert_drive_file_rounded;
//     }
//   }

//   // ── Get file color based on extension ──
//   Color getFileColor(String fileName) {
//     final ext = fileName.split('.').last.toLowerCase();
//     switch (ext) {
//       case 'pdf':
//         return Colors.redAccent;
//       case 'jpg':
//       case 'jpeg':
//       case 'png':
//         return Colors.blueAccent;
//       case 'doc':
//       case 'docx':
//         return Colors.blue;
//       default:
//         return AppColors.textMuted;
//     }
//   }

//   // ── Format file size ──
//   String formatFileSize(int bytes) {
//     if (bytes < 1024) return '$bytes B';
//     if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
//     return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
//   }

//   // ── Submit files for analysis ──
//   Future<void> submitForAnalysis() async {
//     if (selectedFiles.isEmpty) {
//       Get.snackbar(
//         'No Files',
//         'Please select at least one file to continue.',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: AppColors.error,
//         colorText: Colors.white,
//         margin: EdgeInsets.all(16),
//         borderRadius: 8,
//       );
//       return;
//     }

//     isUploading.value = true;

//     try {
//       final Map<String, String> filesMap = {};
//       for (int i = 0; i < selectedFiles.length; i++) {
//         filesMap['file_$i'] = selectedFiles[i].path;
//       }

//       final NetworkCaller networkCaller = NetworkCaller();
//       final response = await networkCaller.multipartRequest(
//         Endpoints.scan,
//         files: filesMap,
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
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class UploadController extends GetxController {
  final RxList<File> selectedFiles = <File>[].obs;
  final RxList<String> fileNames = <String>[].obs;
  final RxList<int> fileSizes = <int>[].obs;
  final RxBool isUploading = false.obs;

  final Rx<bool?> isDocumentMode = Rx<bool?>(null);

  // ✅ Country Variables
  final Rx<Country?> detectedCountry = Rx<Country?>(null);

  static const int maxFileSizeMB = 20;
  static const List<String> imageExtensions = ['jpg', 'jpeg', 'png'];
  static const List<String> docExtensions = ['pdf', 'doc', 'docx'];
  static const List<String> allowedExtensions = [...imageExtensions, ...docExtensions];

  int get effectiveMaxFiles {
    if (isDocumentMode.value == true) return 1;
    return 10;
  }

  int get remainingSlots => effectiveMaxFiles - selectedFiles.length;
  bool get canAddMore => selectedFiles.length < effectiveMaxFiles;
  bool get hasFiles => selectedFiles.isNotEmpty;
  bool get isImageMode => isDocumentMode.value == false;

  @override
  void onInit() {
    super.onInit();
    _fetchUserCountry(); // ✅ Fetch country in background
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

  // ── Browse files from device ──
  Future<void> browseFiles() async {
    if (!canAddMore) {
      Get.snackbar('Limit Reached', isDocumentMode.value == true ? 'You can only upload 1 document at a time.' : 'You can upload a maximum of 10 images.', snackPosition: SnackPosition.TOP, backgroundColor: AppColors.error, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8);
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        bool? pickedIsDoc;
        for (var file in result.files) {
          final ext = file.name.split('.').last.toLowerCase();
          final isDoc = docExtensions.contains(ext);
          if (pickedIsDoc == null) { pickedIsDoc = isDoc; } 
          else if (pickedIsDoc != isDoc) {
            Get.snackbar('Invalid Selection', 'Please select either a document OR images, not both.', snackPosition: SnackPosition.TOP, backgroundColor: Colors.orange, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8);
            return;
          }
        }

        if (isDocumentMode.value != null && isDocumentMode.value != pickedIsDoc) {
          String msg = isDocumentMode.value == true ? 'You already selected a document. Clear it first to upload images.' : 'You already selected images. Clear them first to upload a document.';
          Get.snackbar('Type Mismatch', msg, snackPosition: SnackPosition.TOP, backgroundColor: Colors.orange, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8);
          return;
        }

        final remaining = remainingSlots;
        if (pickedIsDoc == true && result.files.length > 1) {
          Get.snackbar('Limit Exceeded', 'You can only upload 1 document at a time.', snackPosition: SnackPosition.TOP, backgroundColor: Colors.orange, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8);
          return;
        }

        if (pickedIsDoc == false && result.files.length > remaining) {
          Get.snackbar('Selection Exceeded', 'You selected ${result.files.length} images, but only $remaining more can be added. Please select up to $remaining images.', snackPosition: SnackPosition.TOP, backgroundColor: Colors.orange, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8);
          return;
        }

        final newFiles = <File>[];
        final newNames = <String>[];
        final newSizes = <int>[];

        for (var platformFile in result.files) {
          if (platformFile.path == null) continue;
          final file = File(platformFile.path!);
          final fileSize = await file.length();
          final fileSizeMB = fileSize / (1024 * 1024);
          if (fileSizeMB > maxFileSizeMB) {
            Get.snackbar('File Too Large', '${platformFile.name}: ${fileSizeMB.toStringAsFixed(1)}MB > ${maxFileSizeMB}MB', snackPosition: SnackPosition.TOP, backgroundColor: AppColors.error, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8);
            continue;
          }
          newFiles.add(file);
          newNames.add(platformFile.name);
          newSizes.add(fileSize);
        }

        if (newFiles.isNotEmpty) {
          isDocumentMode.value = isDocumentMode.value ?? pickedIsDoc;
          selectedFiles.addAll(newFiles);
          fileNames.addAll(newNames);
          fileSizes.addAll(newSizes);
        }
      }
    } catch (e) {
      print('❌ Error picking files: $e');
      Get.snackbar('Error', 'Failed to pick files. Please try again.', snackPosition: SnackPosition.TOP, backgroundColor: AppColors.error, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8);
    }
  }

  void removeFile(int index) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles.removeAt(index);
      fileNames.removeAt(index);
      fileSizes.removeAt(index);
      if (selectedFiles.isEmpty) { isDocumentMode.value = null; }
    }
  }

  void clearAll() {
    selectedFiles.clear();
    fileNames.clear();
    fileSizes.clear();
    isDocumentMode.value = null;
  }

  IconData getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf': return Icons.picture_as_pdf_rounded;
      case 'jpg': case 'jpeg': case 'png': return Icons.image_rounded;
      case 'doc': case 'docx': return Icons.description_rounded;
      default: return Icons.insert_drive_file_rounded;
    }
  }

  Color getFileColor(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf': return Colors.redAccent;
      case 'jpg': case 'jpeg': case 'png': return Colors.blueAccent;
      case 'doc': case 'docx': return Colors.blue;
      default: return AppColors.textMuted;
    }
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // ══════════════════════════════════════
  //  SUBMIT FLOW
  // ══════════════════════════════════════
  Future<void> submitForAnalysis() async {
    if (selectedFiles.isEmpty) {
      Get.snackbar('No Files', 'Please select at least one file to continue.', snackPosition: SnackPosition.TOP, backgroundColor: AppColors.error, colorText: Colors.white, margin: EdgeInsets.all(16), borderRadius: 8);
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
      for (int i = 0; i < selectedFiles.length; i++) {
        filesMap['file_$i'] = selectedFiles[i].path;
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