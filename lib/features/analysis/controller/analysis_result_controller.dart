

// import 'package:clause_verify/core/models/response_data.dart';
// import 'package:clause_verify/core/services/endpoints.dart';
// import 'package:clause_verify/core/services/network_caller.dart';
// import 'package:clause_verify/features/analysis/model/analysis_result_model.dart';
// import 'package:clause_verify/features/subscription/widgets/pdf_purchase_sheet.dart';
// import 'package:clause_verify/routes/app_routes.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';

// class AnalysisResultController extends GetxController {
//   final Rx<AnalysisResultModel?> result = Rx<AnalysisResultModel?>(null);
//   final RxSet<int> expandedIndexes = <int>{}.obs;
//   final RxString activeFilter = 'all'.obs;

//   // PDF states
//   final RxBool isGeneratingPdf = false.obs;
//   final RxString pdfUrl = ''.obs;

//   /// null = জানা নেই (unlock ধরা হয়), 0 = lock (backend 402 দিলে set হয়)
//   final RxnInt pdfCredits = RxnInt();

//   /// কেনার পর webhook পৌঁছানো পর্যন্ত অপেক্ষা
//   final RxBool pdfPurchasePending = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments;
//     if (args is AnalysisResultModel) {
//       result.value = args;
//     } else if (args is Map<String, dynamic>) {
//       result.value = AnalysisResultModel.fromJson(args);
//     }

//     // High risk clause গুলো শুরুতেই খোলা থাকবে, user সরাসরি জরুরি জিনিস দেখবে
//     final terms = result.value?.aiResponse.importantTerms ?? [];
//     for (int i = 0; i < terms.length; i++) {
//       if (terms[i].level == 'high') expandedIndexes.add(i);
//     }
//   }

//   // ══════════ Expand / Filter ══════════
//   void toggleExpand(int index) {
//     if (expandedIndexes.contains(index)) {
//       expandedIndexes.remove(index);
//     } else {
//       expandedIndexes.add(index);
//     }
//   }

//   bool isExpanded(int index) => expandedIndexes.contains(index);

//   void setFilter(String filter) => activeFilter.value = filter;

//   List<ImportantTerm> get allTerms =>
//       result.value?.aiResponse.importantTerms ?? [];

//   /// (original index, term) — expand state original index দিয়ে থাকে,
//   /// তাই filter বদলালেও কোনটা খোলা ছিল মনে থাকে
//   List<MapEntry<int, ImportantTerm>> get filteredEntries {
//     final entries = allTerms.asMap().entries.toList();
//     if (activeFilter.value == 'all') return entries;
//     return entries.where((e) => e.value.level == activeFilter.value).toList();
//   }

//   // ══════════ Response getters ══════════
//   String get overallRisk => result.value?.aiResponse.summary.overallRisk ?? '';
//   String get country => result.value?.aiResponse.summary.country ?? '';
//   String get recommendation =>
//       result.value?.aiResponse.summary.recommendation ?? '';
//   String get recommendationGuidance =>
//       result.value?.aiResponse.summary.recommendationGuidance ?? '';
//   RiskBreakdown? get riskBreakdown => result.value?.aiResponse.riskBreakdown;
//   List<String> get positivePoints =>
//       result.value?.aiResponse.positivePoints ?? [];
//   int get totalPages => result.value?.totalPages ?? 0;
//   String get createdAt => result.value?.createdAt ?? '';

//   /// যে level এ অন্তত ১টা clause আছে
//   int countOfLevel(String level) =>
//       allTerms.where((t) => t.level == level).length;

//   String get formattedDate {
//     final dateStr = createdAt;
//     if (dateStr.isEmpty) return '';
//     try {
//       final d = DateTime.parse(dateStr).toLocal();
//       String two(int n) => n.toString().padLeft(2, '0');
//       return '${two(d.day)}-${two(d.month)}-${d.year} ${two(d.hour)}:${two(d.minute)}';
//     } catch (e) {
//       return dateStr;
//     }
//   }

//   // ══════════ PDF LOCK STATE ══════════
//   bool get isPdfLocked {
//     if (pdfUrl.value.isNotEmpty) return false;
//     if (pdfPurchasePending.value) return false;
//     final credits = pdfCredits.value;
//     return credits != null && credits <= 0;
//   }

//   Future<void> onPdfButtonTap() async {
//     if (isGeneratingPdf.value) return;

//     if (pdfUrl.value.isNotEmpty) {
//       _openPdfViewer();
//       return;
//     }

//     if (isPdfLocked) {
//       final purchased = await PdfPurchaseSheet.show();
//       if (!purchased) return;

//       pdfPurchasePending.value = true;
//       await generatePdfReport();
//       return;
//     }

//     await generatePdfReport();
//   }

//   Future<void> generatePdfReport() async {
//     final String? id = result.value?.id;

//     if (id == null || id.isEmpty) {
//       _snack('Error', 'Analysis ID not found. Cannot generate PDF.',
//           Colors.redAccent);
//       return;
//     }

//     try {
//       isGeneratingPdf.value = true;

//       final networkCaller = NetworkCaller();

//       final int maxAttempts = pdfPurchasePending.value ? 6 : 1;
//       late ResponseData response;

//       for (int attempt = 1; attempt <= maxAttempts; attempt++) {
//         response = await networkCaller.postRequest(
//           '${Endpoints.generateReport}$id/',
//           requiresAuth: true,
//         );
//         if (response.statusCode != 402) break;
//         if (attempt < maxAttempts) {
//           await Future.delayed(const Duration(seconds: 2));
//         }
//       }

//       if (response.isSuccess && response.responseData != null) {
//         final data = response.responseData!['data'] as Map<String, dynamic>?;
//         if (data != null && data['pdf_file'] != null) {
//           pdfUrl.value = data['pdf_file'] as String;
//           pdfPurchasePending.value = false;
//           _updateCreditsAfterGenerate(response.responseData, data);
//           _openPdfViewer();
//         } else {
//           _snack('Error', 'PDF link not found in response.', Colors.redAccent);
//         }
//       } else if (response.statusCode == 402) {
//         if (pdfPurchasePending.value) {
//           _snack(
//               'Processing',
//               'Your purchase is being processed. Please tap again in a few seconds.',
//               Colors.orange);
//         } else {
//           pdfCredits.value = 0; // button lock হয়ে যাবে
//           _snack('PDF locked', 'Unlock the PDF report to view it.',
//               Colors.orange);
//         }
//       } else {
//         _snack(
//             'Error',
//             response.errorMessage.isNotEmpty
//                 ? response.errorMessage
//                 : 'Failed to generate PDF report.',
//             Colors.redAccent);
//       }
//     } catch (e) {
//       _snack('Error', 'Something went wrong: $e', Colors.redAccent);
//     } finally {
//       isGeneratingPdf.value = false;
//     }
//   }

//   void _snack(String title, String message, Color color) {
//     Get.snackbar(
//       title,
//       message,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: color,
//       colorText: Colors.white,
//     );
//   }

//   void _openPdfViewer() {
//     Get.toNamed(AppRoute.pdfViewerScreen, arguments: pdfUrl.value);
//   }

//   void _updateCreditsAfterGenerate(dynamic body, Map<String, dynamic> data) {
//     dynamic raw = data['pdf_credits'];
//     if (raw == null && body is Map) raw = body['pdf_credits'];

//     int? serverCredits;
//     if (raw is num) {
//       serverCredits = raw.toInt();
//     } else if (raw != null) {
//       serverCredits = int.tryParse(raw.toString());
//     }

//     if (serverCredits != null) {
//       pdfCredits.value = serverCredits;
//     } else if (pdfCredits.value != null) {
//       final next = pdfCredits.value! - 1;
//       pdfCredits.value = next < 0 ? 0 : next;
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

  // PDF states
  final RxBool isGeneratingPdf = false.obs;
  final RxString pdfUrl = ''.obs;

  /// null = জানা নেই (unlock ধরা হয়), 0 = lock (backend 402 দিলে set হয়)
  final RxnInt pdfCredits = RxnInt();

  /// কেনার পর webhook পৌঁছানো পর্যন্ত অপেক্ষা
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

    // High risk clause গুলো শুরুতেই খোলা থাকবে
    final terms = allTerms;
    for (int i = 0; i < terms.length; i++) {
      if (terms[i].level == 'high') expandedIndexes.add(i);
    }
  }

  // ══════════ Terms ══════════

  List<ImportantTerm> get _rawTerms =>
      result.value?.aiResponse.importantTerms ?? [];

  /// contract-এ যে clause গুলো আসলে পাওয়া গেছে (missing বাদে)।
  /// High/Medium/Low count, tab আর card list সব এখান থেকেই আসে।
  List<ImportantTerm> get allTerms =>
      _rawTerms.where((t) => !t.isMissing).toList();

  /// contract-এ নেই এমন clause — কোনো risk count-এ ঢুকবে না
  List<ImportantTerm> get missingTerms =>
      _rawTerms.where((t) => t.isMissing).toList();

  int get foundCount => allTerms.length;
  int get missingCount => missingTerms.length;

  int countOfLevel(String level) =>
      allTerms.where((t) => t.level == level).length;

  // ══════════ Expand / Filter ══════════
  void toggleExpand(int index) {
    if (expandedIndexes.contains(index)) {
      expandedIndexes.remove(index);
    } else {
      expandedIndexes.add(index);
    }
  }

  bool isExpanded(int index) => expandedIndexes.contains(index);

  void setFilter(String filter) => activeFilter.value = filter;

  /// (allTerms-এর index, term)। filter বদলালেও কোনটা খোলা ছিল মনে থাকে
  List<MapEntry<int, ImportantTerm>> get filteredEntries {
    final entries = allTerms.asMap().entries.toList();
    if (activeFilter.value == 'all') return entries;
    return entries.where((e) => e.value.level == activeFilter.value).toList();
  }

  // ══════════ Response getters ══════════
  String get overallRisk => result.value?.aiResponse.summary.overallRisk ?? '';
  String get country => result.value?.aiResponse.summary.country ?? '';
  String get recommendation =>
      result.value?.aiResponse.summary.recommendation ?? '';
  String get recommendationGuidance =>
      result.value?.aiResponse.summary.recommendationGuidance ?? '';
  List<String> get positivePoints =>
      result.value?.aiResponse.positivePoints ?? [];
  int get totalPages => result.value?.totalPages ?? 0;
  String get createdAt => result.value?.createdAt ?? '';

  String get formattedDate {
    final dateStr = createdAt;
    if (dateStr.isEmpty) return '';
    try {
      final d = DateTime.parse(dateStr).toLocal();
      String two(int n) => n.toString().padLeft(2, '0');
      return '${two(d.day)}-${two(d.month)}-${d.year} ${two(d.hour)}:${two(d.minute)}';
    } catch (e) {
      return dateStr;
    }
  }

  // ══════════ PDF LOCK STATE ══════════
  bool get isPdfLocked {
    if (pdfUrl.value.isNotEmpty) return false;
    if (pdfPurchasePending.value) return false;
    final credits = pdfCredits.value;
    return credits != null && credits <= 0;
  }

  Future<void> onPdfButtonTap() async {
    if (isGeneratingPdf.value) return;

    if (pdfUrl.value.isNotEmpty) {
      _openPdfViewer();
      return;
    }

    if (isPdfLocked) {
      final purchased = await PdfPurchaseSheet.show();
      if (!purchased) return;

      pdfPurchasePending.value = true;
      await generatePdfReport();
      return;
    }

    await generatePdfReport();
  }

  Future<void> generatePdfReport() async {
    final String? id = result.value?.id;

    if (id == null || id.isEmpty) {
      _snack('Error', 'Analysis ID not found. Cannot generate PDF.',
          Colors.redAccent);
      return;
    }

    try {
      isGeneratingPdf.value = true;

      final networkCaller = NetworkCaller();

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
          _openPdfViewer();
        } else {
          _snack('Error', 'PDF link not found in response.', Colors.redAccent);
        }
      } else if (response.statusCode == 402) {
        if (pdfPurchasePending.value) {
          _snack(
              'Processing',
              'Your purchase is being processed. Please tap again in a few seconds.',
              Colors.orange);
        } else {
          pdfCredits.value = 0; // button lock হয়ে যাবে
          _snack('PDF locked', 'Unlock the PDF report to view it.',
              Colors.orange);
        }
      } else {
        _snack(
            'Error',
            response.errorMessage.isNotEmpty
                ? response.errorMessage
                : 'Failed to generate PDF report.',
            Colors.redAccent);
      }
    } catch (e) {
      _snack('Error', 'Something went wrong: $e', Colors.redAccent);
    } finally {
      isGeneratingPdf.value = false;
    }
  }

  void _snack(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      colorText: Colors.white,
    );
  }

  void _openPdfViewer() {
    Get.toNamed(AppRoute.pdfViewerScreen, arguments: pdfUrl.value);
  }

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