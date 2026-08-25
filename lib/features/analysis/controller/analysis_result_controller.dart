import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/features/analysis/model/analysis_result_model.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AnalysisResultController extends GetxController {
  final Rx<AnalysisResultModel?> result = Rx<AnalysisResultModel?>(null);
  final RxSet<int> expandedIndexes = <int>{}.obs;
  final RxString activeFilter = 'all'.obs;

  // ✅ PDF Generate States
  final RxBool isGeneratingPdf = false.obs;
  final RxString pdfUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is AnalysisResultModel) {
      result.value = args;
    } else if (args is Map<String, dynamic>) {
      result.value = AnalysisResultModel.fromJson(args);
    }
  }

  void toggleExpand(int index) {
    if (expandedIndexes.contains(index)) {
      expandedIndexes.remove(index);
    } else {
      expandedIndexes.add(index);
    }
  }

  bool isExpanded(int index) => expandedIndexes.contains(index);

  void setFilter(String filter) {
    activeFilter.value = filter;
    expandedIndexes.clear();
  }

  List<ImportantTerm> get filteredTerms {
    final terms = result.value?.aiResponse.importantTerms ?? [];
    if (activeFilter.value == 'all') return terms;
    return terms.where((t) => t.riskLevel == activeFilter.value).toList();
  }

  String get overallRiskLabel => result.value?.aiResponse.summary.overallRisk ?? '';
  int get confidenceScore => result.value?.aiResponse.summary.confidenceScore ?? 0;
  String get country => result.value?.aiResponse.summary.country ?? '';
  String get recommendation => result.value?.aiResponse.summary.recommendation ?? '';
  String get recommendationGuidance => result.value?.aiResponse.summary.recommendationGuidance ?? '';
  RiskBreakdown? get riskBreakdown => result.value?.aiResponse.riskBreakdown;
  List<String> get positivePoints => result.value?.aiResponse.positivePoints ?? [];
  int get totalTerms => result.value?.aiResponse.importantTerms.length ?? 0;

  // ✅ নতুন যোগ করা গেটারস (পেজ সংখ্যা এবং তারিখ)
  int get totalPages => result.value?.totalPages ?? 0;
  String get createdAt => result.value?.createdAt ?? '';

  // ✅ তারিখ সুন্দর করে ফরম্যাট করার জন্য (যেমন: 01-07-2026 01:13)
  String get formattedDate {
    final dateStr = createdAt;
    if (dateStr.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateStr);
      return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  // ══════════════════════════════════════
  //  PDF GENERATE & VIEW
  // ══════════════════════════════════════
  Future<void> generatePdfReport() async {
    final String? id = result.value?.id; 
    
    if (id == null || id.isEmpty) {
      Get.snackbar(
        'Error',
        'Analysis ID not found. Cannot generate PDF.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isGeneratingPdf.value = true;

      final networkCaller = NetworkCaller();
      final response = await networkCaller.postRequest(
        '${Endpoints.generateReport}$id/',
        requiresAuth: true,
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData!['data'] as Map<String, dynamic>?;
        if (data != null && data['pdf_file'] != null) {
          pdfUrl.value = data['pdf_file'] as String;
          
          // ✅ PDF Viewer Screen এ নেভিগেট করুন
          Get.toNamed(
            AppRoute.pdfViewerScreen, 
            arguments: pdfUrl.value,
          );
        } else {
          Get.snackbar(
            'Error',
            'PDF link not found in response.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to generate PDF report.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isGeneratingPdf.value = false;
    }
  }
}