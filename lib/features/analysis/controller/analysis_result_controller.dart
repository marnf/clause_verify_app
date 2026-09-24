// import 'package:clause_verify/core/services/endpoints.dart';
// import 'package:clause_verify/core/services/network_caller.dart';
// import 'package:clause_verify/features/analysis/model/analysis_result_model.dart';
// import 'package:clause_verify/routes/app_routes.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';

// class AnalysisResultController extends GetxController {
//   final Rx<AnalysisResultModel?> result = Rx<AnalysisResultModel?>(null);
//   final RxSet<int> expandedIndexes = <int>{}.obs;
//   final RxString activeFilter = 'all'.obs;

//   // ✅ PDF Generate States
//   final RxBool isGeneratingPdf = false.obs;
//   final RxString pdfUrl = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments;
//     if (args is AnalysisResultModel) {
//       result.value = args;
//     } else if (args is Map<String, dynamic>) {
//       result.value = AnalysisResultModel.fromJson(args);
//     }
//   }

//   void toggleExpand(int index) {
//     if (expandedIndexes.contains(index)) {
//       expandedIndexes.remove(index);
//     } else {
//       expandedIndexes.add(index);
//     }
//   }

//   bool isExpanded(int index) => expandedIndexes.contains(index);

//   void setFilter(String filter) {
//     activeFilter.value = filter;
//     expandedIndexes.clear();
//   }

//   List<ImportantTerm> get filteredTerms {
//     final terms = result.value?.aiResponse.importantTerms ?? [];
//     if (activeFilter.value == 'all') return terms;
//     return terms.where((t) => t.riskLevel == activeFilter.value).toList();
//   }

//   String get overallRiskLabel => result.value?.aiResponse.summary.overallRisk ?? '';
//   int get confidenceScore => result.value?.aiResponse.summary.confidenceScore ?? 0;
//   String get country => result.value?.aiResponse.summary.country ?? '';
//   String get recommendation => result.value?.aiResponse.summary.recommendation ?? '';
//   String get recommendationGuidance => result.value?.aiResponse.summary.recommendationGuidance ?? '';
//   RiskBreakdown? get riskBreakdown => result.value?.aiResponse.riskBreakdown;
//   List<String> get positivePoints => result.value?.aiResponse.positivePoints ?? [];
//   int get totalTerms => result.value?.aiResponse.importantTerms.length ?? 0;

//   // ✅ নতুন যোগ করা গেটারস (পেজ সংখ্যা এবং তারিখ)
//   int get totalPages => result.value?.totalPages ?? 0;
//   String get createdAt => result.value?.createdAt ?? '';

//   // ✅ তারিখ সুন্দর করে ফরম্যাট করার জন্য (যেমন: 01-07-2026 01:13)
//   String get formattedDate {
//     final dateStr = createdAt;
//     if (dateStr.isEmpty) return '';
//     try {
//       final dateTime = DateTime.parse(dateStr);
//       return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return dateStr;
//     }
//   }

//   // ══════════════════════════════════════
//   //  PDF GENERATE & VIEW
//   // ══════════════════════════════════════
//   Future<void> generatePdfReport() async {
//     final String? id = result.value?.id; 
    
//     if (id == null || id.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Analysis ID not found. Cannot generate PDF.',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     try {
//       isGeneratingPdf.value = true;

//       final networkCaller = NetworkCaller();
//       final response = await networkCaller.postRequest(
//         '${Endpoints.generateReport}$id/',
//         requiresAuth: true,
//       );

//       if (response.isSuccess && response.responseData != null) {
//         final data = response.responseData!['data'] as Map<String, dynamic>?;
//         if (data != null && data['pdf_file'] != null) {
//           pdfUrl.value = data['pdf_file'] as String;
          
//           // ✅ PDF Viewer Screen এ নেভিগেট করুন
//           Get.toNamed(
//             AppRoute.pdfViewerScreen, 
//             arguments: pdfUrl.value,
//           );
//         } else {
//           Get.snackbar(
//             'Error',
//             'PDF link not found in response.',
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Colors.redAccent,
//             colorText: Colors.white,
//           );
//         }
//       } else {
//         Get.snackbar(
//           'Error',
//           response.errorMessage ?? 'Failed to generate PDF report.',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Something went wrong: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } finally {
//       isGeneratingPdf.value = false;
//     }
//   }
// }



import 'package:clause_verify/core/models/response_data.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/features/analysis/model/analysis_result_model.dart';
import 'package:clause_verify/features/subscription/widgets/pdf_purchase_sheet.dart';
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

  // ✅ PDF credit (backend থেকে আসে)
  // null  = backend এখনো এই তথ্য পাঠায়নি → button unlock ধরা হয়
  // 0     = lock
  // 1+    = unlock
  final RxnInt pdfCredits = RxnInt();

  // ✅ user PDF কিনেছে, কিন্তু backend-এ webhook পৌঁছানো পর্যন্ত অপেক্ষা চলছে
  final RxBool pdfPurchasePending = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is AnalysisResultModel) {
      result.value = args;
    } else if (args is Map<String, dynamic>) {
      result.value = AnalysisResultModel.fromJson(args);
    }
    pdfCredits.value = result.value?.pdfCredits;
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
  //  PDF LOCK STATE
  // ══════════════════════════════════════

  /// PDF button lock থাকবে কিনা।
  /// - এই screen-এ PDF আগেই generate হয়ে থাকলে → unlock (আবার credit কাটবে না)
  /// - কেনার পর webhook-এর অপেক্ষা চলছে → unlock
  /// - backend credit 0 বললে → lock
  bool get isPdfLocked {
    if (pdfUrl.value.isNotEmpty) return false;
    if (pdfPurchasePending.value) return false;
    final credits = pdfCredits.value;
    return credits != null && credits <= 0;
  }

  // ══════════════════════════════════════
  //  PDF BUTTON TAP
  // ══════════════════════════════════════
  Future<void> onPdfButtonTap() async {
    if (isGeneratingPdf.value) return;

    // এই screen-এ আগেই generate হয়েছে → API call ছাড়াই খোলো
    if (pdfUrl.value.isNotEmpty) {
      _openPdfViewer();
      return;
    }

    // Lock থাকলে কেনার sheet, কিনলে আগের পেজেই থেকে PDF generate
    if (isPdfLocked) {
      final purchased = await PdfPurchaseSheet.show();
      if (!purchased) return;

      pdfPurchasePending.value = true;
      await generatePdfReport();
      return;
    }

    await generatePdfReport();
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

      // সদ্য কিনলে backend-এ webhook পৌঁছাতে কয়েক সেকেন্ড লাগতে পারে,
      // তাই তখন 402 এলে ২ সেকেন্ড পরপর কয়েকবার আবার চেষ্টা করা হয়।
      final int maxAttempts = pdfPurchasePending.value ? 6 : 1;
      late ResponseData response;

      for (int attempt = 1; attempt <= maxAttempts; attempt++) {
        response = await networkCaller.postRequest(
          '${Endpoints.generateReport}$id/',
          requiresAuth: true,
        );
        if (response.statusCode != 402) break;
        if (attempt < maxAttempts) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData!['data'] as Map<String, dynamic>?;
        if (data != null && data['pdf_file'] != null) {
          pdfUrl.value = data['pdf_file'] as String;
          pdfPurchasePending.value = false;
          _updateCreditsAfterGenerate(response.responseData, data);

          // ✅ PDF Viewer Screen এ নেভিগেট করুন
          _openPdfViewer();
        } else {
          Get.snackbar(
            'Error',
            'PDF link not found in response.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else if (response.statusCode == 402) {
        // Backend বলছে PDF credit নেই
        if (pdfPurchasePending.value) {
          Get.snackbar(
            'Processing',
            'Your purchase is being processed. Please tap again in a few seconds.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        } else {
          pdfCredits.value = 0; // button lock হয়ে যাবে
          Get.snackbar(
            'PDF locked',
            'Unlock the PDF report to view it.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to generate PDF report.',
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

  void _openPdfViewer() {
    Get.toNamed(
      AppRoute.pdfViewerScreen,
      arguments: pdfUrl.value,
    );
  }

  /// PDF generate সফল হলে credit-এর সংখ্যা আপডেট:
  /// backend নতুন সংখ্যা পাঠালে সেটা, না পাঠালে locally ১ কমাও।
  void _updateCreditsAfterGenerate(dynamic body, Map<String, dynamic> data) {
    dynamic raw = data['pdf_credits'];
    if (raw == null && body is Map) raw = body['pdf_credits'];

    int? serverCredits;
    if (raw is num) {
      serverCredits = raw.toInt();
    } else if (raw != null) {
      serverCredits = int.tryParse(raw.toString());
    }

    if (serverCredits != null) {
      pdfCredits.value = serverCredits;
    } else if (pdfCredits.value != null) {
      final next = pdfCredits.value! - 1;
      pdfCredits.value = next < 0 ? 0 : next;
    }
  }
}