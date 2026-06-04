import 'package:flutter_extension/core/services/endpoints.dart';
import 'package:flutter_extension/core/services/network_caller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_extension/features/history/model/history_details_model.dart';
import 'package:get/get.dart';

class HistoryPreviewController extends GetxController {
  // Observable variables
  final Rx<AnalysisModel?> analysisData = Rx<AnalysisModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Get ID from arguments
  String? analysisId;

  @override
  void onInit() {
    super.onInit();
    // Get ID from navigation arguments
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      analysisId = args['id'];
    }

    if (analysisId != null) {
      fetchAnalysisFromAPI();
    } else {
      errorMessage.value = 'Analysis ID not found';
      isLoading.value = false;
    }
  }

  // Fetch data from API
  Future<void> fetchAnalysisFromAPI() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔍 Fetching analysis for ID: $analysisId');

      // API call using NetworkCaller
      final response = await NetworkCaller().getRequest(
        '${Endpoints.historyDetails}$analysisId/',
      );
      print('here is the response:${response.responseData}');

      print('📡 API Response Status: ${response.isSuccess}');
      print('📦 Response Data: ${response.responseData}');

      if (response.isSuccess && response.responseData != null) {
        // Parse JSON to Model
        analysisData.value = AnalysisModel.fromJson(response.responseData);

        print('✅ Data parsed successfully');
        print('Score: ${aiConfidenceLevel}');
        print('Score: ${authenticityScore}');
        print('Status: ${authenticityStatus}');
        print('Status: ${authenticityLevel}');
        print('Status: ${authenticityVerdict}');
        print('Status: ${categoryTitle}');
        print('Status: ${categorySubtitle}');
        print('Categories: ${categoryItems.length}');
        print('Status: ${commentaryTitle}');
        print('Status: ${commentarySubtitle}');
        print('Comments: ${commentItems.length}');
        print('pdf available: ${isPdfAvailable}');
        print('watch brand: ${watchBrand}');
        print('Model: ${watchModel}');
        print('serial number: ${watchSerial}');
        print('estimated price: ${estimatedPrice}');
        print('price currency: ${priceCurrency}');
        print('price condition: ${priceCondition}');
        print('front image: ${frontImage}');
        print('back image: ${backImage}');
        print('belt image: ${braceletImage}');
        print('avrage component score: ${averageComponentScore}');
        print('total component analyzed: ${totalComponentsAnalyzed}');
        print('report ID: ${reportId}');
        print('Date of issue: ${dateOfIssue}');
        print('note: ${expertNote}');
        print('Comments: ${conclusionVerdict}');
        print('Comments: ${conclusionOverallScore}');
        print('invoice: ${invoice}');
        print('box: ${originalBox}');
        print('certificate: ${originalBrandCertificate}');

        // Get.snackbar(
        //   'Success',
        //   'Analysis data loaded successfully',
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Color(0xFF0D3B2B),
        //   colorText: Color(0xFF4ADE80),
        //   duration: Duration(seconds: 2),
        // );
      } else {
        errorMessage.value = response.errorMessage;
        print('❌ API Error: ${response.errorMessage}');

        // Get.snackbar(
        //   'Error',
        //   response.errorMessage,
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Color(0xFF1A1A1A),
        //   colorText: Color(0xFFEF4444),
        //   duration: Duration(seconds: 3),
        // );
      }
    } catch (e, stackTrace) {
      errorMessage.value = e.toString();
      print('💥 Exception occurred: $e');
      print('Stack trace: $stackTrace');

      Get.snackbar(
        'Error',
        'Failed to load analysis data: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF1A1A1A),
        colorText: Color(0xFFEF4444),
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool get isPdfAvailable {
    try {
      return analysisData.value?.pdfAvailable ?? false;
    } catch (e) {
      print('Error getting isPdfAvailable: $e');
      return false;
    }
  }

  int get authenticityScore {
    try {
      return analysisData.value?.authenticityScore ?? 0;
    } catch (e) {
      print('Error getting authenticityScore: $e');
      return 0;
    }
  }

  String get authenticityStatus {
    try {
      return analysisData.value?.authenticityStatus ?? 'UNKNOWN';
    } catch (e) {
      print('Error getting authenticityStatus: $e');
      return 'UNKNOWN';
    }
  }

  String get authenticityLevel {
    try {
      return analysisData.value?.authenticity.level ?? '';
    } catch (e) {
      print('Error getting authenticityLevel: $e');
      return '';
    }
  }

  String get authenticityVerdict {
    try {
      return analysisData.value?.authenticity.verdict ?? '';
    } catch (e) {
      print('Error getting authenticityVerdict: $e');
      return '';
    }
  }

  // Category Analysis Getters
  List<CategoryItem> get categoryItems {
    try {
      return analysisData.value?.categoryAnalysis.items ?? [];
    } catch (e) {
      print('Error getting categoryItems: $e');
      return [];
    }
  }

  String get categoryTitle {
    try {
      return analysisData.value?.categoryAnalysis.title ?? 'Category Analysis';
    } catch (e) {
      print('Error getting categoryTitle: $e');
      return 'Category Analysis';
    }
  }

  String get categorySubtitle {
    try {
      return analysisData.value?.categoryAnalysis.subtitle ??
          'Component evaluation';
    } catch (e) {
      print('Error getting categorySubtitle: $e');
      return 'Component evaluation';
    }
  }

  // Expert Commentary Getters
  List<CommentItem> get commentItems {
    try {
      return analysisData.value?.expertCommentary.comments ?? [];
    } catch (e) {
      print('Error getting commentItems: $e');
      return [];
    }
  }

  String get commentaryTitle {
    try {
      return analysisData.value?.expertCommentary.title ?? 'Expert Commentary';
    } catch (e) {
      print('Error getting commentaryTitle: $e');
      return 'Expert Commentary';
    }
  }

  String get commentarySubtitle {
    try {
      return analysisData.value?.expertCommentary.subtitle ??
          'Detailed findings';
    } catch (e) {
      print('Error getting commentarySubtitle: $e');
      return 'Detailed findings';
    }
  }

  // AI Confidence Level
  int get aiConfidenceLevel {
    try {
      return analysisData.value?.aiConfidenceLevel ?? 0;
    } catch (e) {
      print('Error getting aiConfidenceLevel: $e');
      return 0;
    }
  }

  // Watch Information Getters
  String get watchBrand {
    try {
      return analysisData.value?.watchInformation.brand ?? '';
    } catch (e) {
      print('Error getting watchBrand: $e');
      return '';
    }
  }

  String get watchModel {
    try {
      return analysisData.value?.watchInformation.model ?? '';
    } catch (e) {
      print('Error getting watchModel: $e');
      return '';
    }
  }

  String get watchSerial {
    try {
      return analysisData.value?.watchInformation.serialRefNo ?? '';
    } catch (e) {
      print('Error getting watchSerial: $e');
      return '';
    }
  }

  // Price Estimation Getters
  String get estimatedPrice {
    try {
      return analysisData.value?.priceEstimation.estimatedPrice ?? '0';
    } catch (e) {
      print('Error getting estimatedPrice: $e');
      return '0';
    }
  }

  String get priceCurrency {
    try {
      return analysisData.value?.priceEstimation.currency ?? 'USD';
    } catch (e) {
      print('Error getting priceCurrency: $e');
      return 'USD';
    }
  }

  String get priceCondition {
    try {
      return analysisData.value?.priceEstimation.conditionAssumed ?? '';
    } catch (e) {
      print('Error getting priceCondition: $e');
      return '';
    }
  }

  // Images Getters
  String? get frontImage {
    try {
      return analysisData.value?.images.front;
    } catch (e) {
      print('Error getting frontImage: $e');
      return null;
    }
  }

  String? get backImage {
    try {
      return analysisData.value?.images.back;
    } catch (e) {
      print('Error getting backImage: $e');
      return null;
    }
  }

  String? get braceletImage {
    try {
      return analysisData.value?.images.bracelet;
    } catch (e) {
      print('Error getting braceletImage: $e');
      return null;
    }
  }

  // Statistics Getters
  double get averageComponentScore {
    try {
      return analysisData.value?.statistics.averageComponentScore ?? 0.0;
    } catch (e) {
      print('Error getting averageComponentScore: $e');
      return 0.0;
    }
  }

  int get totalComponentsAnalyzed {
    try {
      return analysisData.value?.statistics.totalComponentsAnalyzed ?? 0;
    } catch (e) {
      print('Error getting totalComponentsAnalyzed: $e');
      return 0;
    }
  }

  // Report Info Getters
  String get reportId {
    try {
      return analysisData.value?.reportId ?? '';
    } catch (e) {
      print('Error getting reportId: $e');
      return '';
    }
  }

  String get dateOfIssue {
    try {
      return analysisData.value?.dateOfIssue ?? '';
    } catch (e) {
      print('Error getting dateOfIssue: $e');
      return '';
    }
  }

  // Expert Note
  String get expertNote {
    try {
      return analysisData.value?.expertNote ?? '';
    } catch (e) {
      print('Error getting expertNote: $e');
      return '';
    }
  }

  // Conclusion Getters
  String get conclusionVerdict {
    try {
      return analysisData.value?.conclusion.verdict ?? '';
    } catch (e) {
      print('Error getting conclusionVerdict: $e');
      return '';
    }
  }

  double get conclusionOverallScore {
    try {
      return analysisData.value?.conclusion.overallScore ?? 0.0;
    } catch (e) {
      print('Error getting conclusionOverallScore: $e');
      return 0.0;
    }
  }

  bool get invoice {
    try {
      return analysisData.value?.certificateAndDocumentation.invoice ?? false;
    } catch (e) {
      print('Error getting isPdfAvailable: $e');
      return false;
    }
  }

  bool get originalBox {
    try {
      return analysisData.value?.certificateAndDocumentation.originalBox ?? false;
    } catch (e) {
      print('Error getting isPdfAvailable: $e');
      return false;
    }
  }

  bool get originalBrandCertificate {
    try {
      return analysisData.value?.certificateAndDocumentation.originalBrandCertificate ?? false;
    } catch (e) {
      print('Error getting isPdfAvailable: $e');
      return false;
    }
  }

  // Check if data is available
  bool get hasData => analysisData.value != null;

  // Get color based on percentage
  Color getColorBasedOnPercentage(int percentage) {
    if (percentage >= 80) {
      return Color(0xFF4ADE80); // Green
    } else if (percentage >= 60) {
      return Color(0xFFD4A574); // Gold
    } else {
      return Color(0xFFEF4444); // Red
    }
  }

  // Get icon based on comment type
  IconData getIconForComment(String iconType) {
    switch (iconType.toLowerCase()) {
      case 'check':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning_amber;
      case 'error':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  // Download report action
  void downloadReport() {
    if (!hasData) {
      Get.snackbar(
        'Error',
        'No data available to download',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF1A1A1A),
        colorText: Color(0xFFFFFFFF),
      );
      return;
    }

    // TODO: Implement actual download logic
    Get.snackbar(
      'Download Started',
      'Your AI Pre-Expertise Report is being downloaded',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Color(0xFF1A1A1A),
      colorText: Color(0xFFFFFFFF),
      duration: Duration(seconds: 2),
    );

    // Simulate download
    Future.delayed(Duration(seconds: 2), () {
      Get.snackbar(
        'Download Complete',
        'Report saved successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF0D3B2B),
        colorText: Color(0xFF4ADE80),
        duration: Duration(seconds: 2),
      );
    });
  }

  // View price estimation action
  void viewPriceEstimation() {
    if (!hasData) {
      Get.snackbar(
        'Error',
        'No data available',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF1A1A1A),
        colorText: Color(0xFFFFFFFF),
      );
      return;
    }

    try {
      // Price estimation data check
      final priceEstimation =
          analysisData.value?.analysisDetails.priceEstimation;

      if (priceEstimation != null) {
        Get.snackbar(
          'Price Estimation',
          '${priceEstimation.currency} ${priceEstimation.estimatedPrice} - ${priceEstimation.conditionAssumed} condition',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Color(0xFF1A1A1A),
          colorText: Color(0xFFFFFFFF),
        );
      } else {
        Get.snackbar(
          'Info',
          'Price estimation not available',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Color(0xFF1A1A1A),
          colorText: Color(0xFFFFFFFF),
        );
      }
    } catch (e) {
      print('Error viewing price estimation: $e');
      Get.snackbar(
        'Error',
        'Unable to load price estimation',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF1A1A1A),
        colorText: Color(0xFFEF4444),
      );
    }

    // Navigate to price estimation screen if needed
    // Get.toNamed(AppRoute.priceEstimationScreen);
  }

  // Refresh data
  void refreshData() {
    if (analysisId != null) {
      fetchAnalysisFromAPI();
    }
  }

  // Share report
  void shareReport() {
    if (!hasData) {
      Get.snackbar(
        'Error',
        'No data available to share',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF1A1A1A),
        colorText: Color(0xFFFFFFFF),
      );
      return;
    }

    Get.snackbar(
      'Share',
      'Opening share options',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Color(0xFF1A1A1A),
      colorText: Color(0xFFFFFFFF),
    );

    // TODO: Implement share logic
  }

  @override
  void onClose() {
    // Cleanup if needed
    super.onClose();
  }
}
