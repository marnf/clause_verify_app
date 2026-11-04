import 'package:clause_verify/core/common/widgets/scan_live_status.dart';
import 'package:clause_verify/core/utils/timezone_helper.dart';
import 'package:country_picker/country_picker.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/core/services/profile_refresh_service.dart';
import 'package:clause_verify/core/services/scan_job_poller.dart';
import 'package:clause_verify/core/services/scan_warning_service.dart';
import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/utils/constants/country_confirmation_modal.dart';
import 'package:clause_verify/core/utils/constants/country_helper.dart';

import 'package:clause_verify/core/utils/image_converter.dart';
import 'package:clause_verify/features/analysis/model/analysis_result_model.dart';
import 'package:clause_verify/features/subscription/utils/paywall_guard.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';


class UploadController extends GetxController {
  final RxList<File> selectedFiles = <File>[].obs;
  final RxList<String> fileNames = <String>[].obs;
  final RxList<int> fileSizes = <int>[].obs;
  final RxBool isUploading = false.obs;
  final RxBool isProcessingImages = false.obs;
  final Rx<bool?> isDocumentMode = Rx<bool?>(null);
  final Rx<Country?> detectedCountry = Rx<Country?>(null);

  /// Backend থেকে আসা live progress message (polling)
  final RxString liveMessage = ''.obs;
  late final ScanJobPoller _poller = ScanJobPoller(
    onMessage: (msg) => liveMessage.value = msg,
  );

  static const int maxFileSizeMB = 20;
  static const List<String> imageExtensions = ['jpg', 'jpeg', 'png'];
  static const List<String> docExtensions = ['pdf', 'doc', 'docx'];
  static const List<String> allowedExtensions = [
    ...imageExtensions,
    ...docExtensions,
  ];

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
    _fetchUserCountry(); // Fetch country in background
    ScanWarningService.load(); // saved warning (থাকলে) load করো
  }

  @override
  void onClose() {
    _poller.stop();
    ScanLiveStatus.close();
    super.onClose();
  }

  Future<void> _fetchUserCountry() async {
    try {
      final country = await CountryHelper.getCurrentCountry();
      if (country != null) {
        detectedCountry.value = country;
      } else {
        detectedCountry.value = Country.parse('CA');
      }
    } catch (e) {
      detectedCountry.value = Country.parse('CA');
    }
  }

  Future<void> browseFiles() async {
    if (!canAddMore) {
      Get.snackbar(
        'limitReached'.tr,
        isDocumentMode.value == true
            ? 'onlyOneDocumentAllowed'.tr
            : 'maxImagesAllowed'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
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

          if (pickedIsDoc == null) {
            pickedIsDoc = isDoc;
          } else if (pickedIsDoc != isDoc) {
            Get.snackbar(
              'invalidSelection'.tr,
              'invalidSelectionMessage'.tr,
              snackPosition: SnackPosition.TOP,
              backgroundColor: AppColors.warning,
              colorText: AppColors.white,
              margin: const EdgeInsets.all(16),
              borderRadius: 8,
            );
            return;
          }
        }

        if (isDocumentMode.value != null &&
            isDocumentMode.value != pickedIsDoc) {
          String msg = isDocumentMode.value == true
              ? 'clearDocFirst'.tr
              : 'clearImagesFirst'.tr;
          Get.snackbar(
            'typeMismatch'.tr,
            msg,
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.warning,
            colorText: AppColors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
          );
          return;
        }

        final remaining = remainingSlots;

        if (pickedIsDoc == true && result.files.length > 1) {
          Get.snackbar(
            'limitExceeded'.tr,
            'onlyOneDocumentAllowed'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.warning,
            colorText: AppColors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
          );
          return;
        }

        if (pickedIsDoc == false && result.files.length > remaining) {
          Get.snackbar(
            'selectionExceeded'.tr,
            'selectionExceededMessage'.trParams({
              'selected': result.files.length.toString(),
              'remaining': remaining.toString()
            }),
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.warning,
            colorText: AppColors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
          );
          return;
        }

        if (pickedIsDoc == false) {
          isProcessingImages.value = true;
        }

        final newFiles = <File>[];
        final newNames = <String>[];
        final newSizes = <int>[];

        try {
          for (var platformFile in result.files) {
            if (platformFile.path == null) continue;

            File file = File(platformFile.path!);
            final ext = platformFile.name.split('.').last.toLowerCase();

            if (imageExtensions.contains(ext)) {
              file = await ImageConverter.convertToJpegIfNeeded(file);
            }

            final fileSize = await file.length();
            final fileSizeMB = fileSize / (1024 * 1024);

            if (fileSizeMB > maxFileSizeMB) {
              Get.snackbar(
                'fileTooLarge'.tr,
                'fileTooLargeMessageDetails'.trParams({
                  'name': platformFile.name,
                  'size': fileSizeMB.toStringAsFixed(1),
                  'max': maxFileSizeMB.toString()
                }),
                snackPosition: SnackPosition.TOP,
                backgroundColor: AppColors.error,
                colorText: AppColors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 8,
              );
              continue;
            }

            newFiles.add(file);
            newNames.add(platformFile.name);
            newSizes.add(fileSize);
          }
        } finally {
          isProcessingImages.value = false;
        }

        if (newFiles.isNotEmpty) {
          isDocumentMode.value = isDocumentMode.value ?? pickedIsDoc;
          selectedFiles.addAll(newFiles);
          fileNames.addAll(newNames);
          fileSizes.addAll(newSizes);
        }
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'filePickFailed'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  void removeFile(int index) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles.removeAt(index);
      fileNames.removeAt(index);
      fileSizes.removeAt(index);

      if (selectedFiles.isEmpty) {
        isDocumentMode.value = null;
      }
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
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color getFileColor(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return AppColors.error;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return AppColors.primaryColor;
      case 'doc':
      case 'docx':
        return AppColors.primaryColor;
      default:
        return AppColors.textMuted;
    }
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> submitForAnalysis() async {
    if (selectedFiles.isEmpty) {
      Get.snackbar(
        'noFiles'.tr,
        'noFilesMessage'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }

    // Scan type + AI consent — modal-এ (country আর দেখানো হয় না)
    final ScanSelection? selection = await _showScanConfirmation();
    if (selection == null) return; // User cancelled

    _performUpload(selection);
  }

  Future<ScanSelection?> _showScanConfirmation() async {
    return await Get.dialog<ScanSelection>(
      const CountryConfirmationModal(),
      barrierDismissible: true,
    );
  }

  /// Backend বলছে document analyze করা যায়নি (scan কাটা হয়নি)
  void _showAnalysisFailed(String message) {
    Get.snackbar(
      'error'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
      colorText: AppColors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 8), // message বড়, তাই বেশি সময়
    );
  }

  Future<void> _performUpload(ScanSelection selection) async {
    try {
      isUploading.value = true;
      liveMessage.value = '';

      // Analysis শুরু হতেই live status modal (screen-এর মাঝখানে, পেছনে dark overlay)
      ScanLiveStatus.show(liveMessage);

      // আগে detect করা country (UI-তে দেখানো হয় না)। কোনো অপেক্ষা নেই:
      // detect না হয়ে থাকলে আগের মতোই fallback Canada।
      final lawCountry = (detectedCountry.value ?? Country.parse('CA')).name;

      final fileList = selectedFiles
          .map((file) => MapEntry('files', file.path))
          .toList();

      // Frontend থেকে UUID generate → upload header + polling দুই জায়গাতেই এটাই যাবে
      final scanJobId = ScanJobHelper.newJobId();
      final timezone = await getUserTimezone();

      debugPrint(
          '📤 UPLOAD START → files: ${fileList.length}, law_country: $lawCountry, scan_type: ${selection.scanType.apiValue}, job: $scanJobId, tz: $timezone');

      // Scan-এর date: আজকের তারিখ, YYYY-MM-DD format-এ (user-কে কিছু করতে হবে না)
      final now = DateTime.now();
      final scanDate =
          '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      // Upload request চলাকালীন background-এ polling শুরু
      _poller.start(scanJobId);

      final networkCaller = NetworkCaller();
      final response = await networkCaller.multipartRequest(
        Endpoints.fileUpload,
        files: fileList,
        headers: {
          'X-Timezone': timezone,
          'X-Scan-Job-ID': scanJobId,
        },
        fields: {
          'law_country': lawCountry,
          'scan_type': selection.scanType.apiValue,
          'scan_date': scanDate,
        },
      );

      // Response এসে গেছে: polling বন্ধ, modal বন্ধ, তারপর result/error দেখাও
      _poller.stop();
      ScanLiveStatus.close();

      debugPrint(
          '📥 UPLOAD DONE → status: ${response.statusCode}, success: ${response.isSuccess}');

      // ✅ প্রতিটা upload response-এর পরেই profile আবার fetch করো।
      // কারণ:
      //   - success হলে scan credit কমেছে
      //   - not_a_contract হলে free_rejections_remaining বদলে গেছে
      //   - document_analysis_failed হলেও scan credit কমে থাকতে পারে
      //   - অন্য কোনো error হলেও নিরাপদ থাকার জন্য refresh করাই ভালো
      // fire-and-forget: নিচের logic বা navigation ব্লক করবে না।
      ProfileRefreshService.refresh();

      if (response.isSuccess && response.responseData != null) {
        // HTTP 200 হলেও backend যদি success:false পাঠায়
        if (response.responseData!['success'] == false) {
          // Contract না হলে: selected file clear + message popup + Warning save/clear
          if (response.responseData!['code'] == 'not_a_contract') {
            clearAll(); // ✅ Contract না হলে selected file অটো clear
            await ScanWarningService.handleNotAContract(
                response.responseData!);
          } else {
            _showAnalysisFailed(
              (response.responseData!['message'] ?? 'somethingWentWrong'.tr)
                  .toString(),
            );
          }
          return;
        }

        final dataMap = response.responseData!['data'] as Map<String, dynamic>?;

        if (dataMap == null) {
          Get.snackbar(
            'error'.tr,
            'invalidResponseFormat'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.error,
            colorText: AppColors.white,
          );
          return;
        }

        final resultModel = AnalysisResultModel.fromJson(dataMap);

        // Scan সফল হয়েছে → আগের warning চলে যাবে
        await ScanWarningService.clear();

        clearAll();
        Get.toNamed(AppRoute.analysisResultScreen, arguments: resultModel);
      } else {
        // Backend বলছে scan credit/plan নেই: Subscription page-এ পাঠাও
        if (response.statusCode == 402) {
          isUploading.value = false;
          await PaywallGuard.handle(response);
          return;
        }

        final errorData = response.responseData;

        // Backend: contract না (error status-এ এলেও handle হবে)
        if (errorData != null && errorData['code'] == 'not_a_contract') {
          clearAll(); // ✅ Contract না হলে selected file অটো clear
          await ScanWarningService.handleNotAContract(errorData);
        }
        // Backend: document পড়া/analyze করা যায়নি (scan কাটা হয়নি)
        else if (errorData != null &&
            errorData['code'] == 'document_analysis_failed') {
          _showAnalysisFailed(
            (errorData['message'] ?? response.errorMessage).toString(),
          );
        } else if (errorData != null &&
            errorData['status'] == 'fail' &&
            errorData['reason'] == 'low_resolution') {
          final width = errorData['width'];
          final height = errorData['height'];
          final minRes = errorData['min_resolution'] ?? '300x300';

          Get.snackbar(
            'imageResolutionTooLow'.tr,
            'imageResolutionTooLowMessage'.trParams({
              'width': width.toString(),
              'height': height.toString(),
              'minRes': minRes.toString()
            }),
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.warning,
            colorText: AppColors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            duration: const Duration(seconds: 4),
          );
        } else {
          Get.snackbar(
            'error'.tr,
            response.errorMessage,
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.error,
            colorText: AppColors.white,
          );
        }
      }
    } catch (e) {
      debugPrint('❌ UPLOAD EXCEPTION: $e');
      _poller.stop();
      ScanLiveStatus.close();
      Get.snackbar(
        'error'.tr,
        'somethingWentWrong'.trParams({'error': e.toString()}),
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } finally {
      _poller.stop();
      ScanLiveStatus.close();
      isUploading.value = false;
      liveMessage.value = '';
    }
  }
}