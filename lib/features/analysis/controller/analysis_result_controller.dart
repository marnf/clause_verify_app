import 'package:clause_verify/core/utils/constants/app_colors.dart';
import 'package:clause_verify/core/models/response_data.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/features/analysis/model/analysis_result_model.dart';
import 'package:clause_verify/features/history/controller/history_controller.dart';
import 'package:clause_verify/features/subscription/widgets/pdf_purchase_sheet.dart';
import 'package:clause_verify/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AnalysisResultController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  final Rx<AnalysisResultModel?> result = Rx<AnalysisResultModel?>(null);
  final RxSet<int> expandedIndexes = <int>{}.obs;
  final RxString activeFilter = 'all'.obs;

  // ── Id diye load korar state ──
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  String _analysisId = '';
  bool _isMarkingRead = false;

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

    if (args is String && args.trim().isNotEmpty) {
      // ── Notun way: shudhu id ashe -> API theke report ane ──
      _analysisId = args.trim();
      loadAnalysis();
    } else if (args is AnalysisResultModel) {
      // ── Age theke load kora model (jemon notun scan er por) ──
      _applyResult(args);
    } else if (args is Map<String, dynamic>) {
      _applyResult(AnalysisResultModel.fromJson(args));
    } else {
      errorMessage.value = 'failedToLoadAnalysisDetails'.tr;
    }
  }

  // ══════════ Load by id + mark as read ══════════

  /// GET /analysis/{id}/ -> result set -> is_read false hole mark-as-read PATCH
  Future<void> loadAnalysis() async {
    if (_analysisId.isEmpty || isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _networkCaller
          .getRequest('${Endpoints.fileAnalysis}$_analysisId/');

      if (response.isSuccess && response.responseData != null) {
        final model = AnalysisResultModel.fromJson(
          Map<String, dynamic>.from(response.responseData as Map),
        );
        _applyResult(model);
      } else {
        errorMessage.value = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'failedToLoadAnalysisDetails'.tr;
      }
    } catch (e) {
      errorMessage.value = 'failedToLoadAnalysisDetails'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  /// Result set kore, high risk clause gulo khule dey, r dorkar hole read mark kore
  void _applyResult(AnalysisResultModel model) {
    result.value = model;

    // High risk clause গুলো শুরুতেই খোলা থাকবে
    expandedIndexes.clear();
    final terms = allTerms;
    for (int i = 0; i < terms.length; i++) {
      if (terms[i].level == 'high') expandedIndexes.add(i);
    }

    _markAsReadIfNeeded(model);
  }

  /// is_read true hole kichu hit korbe na.
  /// false hole PATCH /analyses/{id}/mark-as-read/ (body nai, shudhu token)
  Future<void> _markAsReadIfNeeded(AnalysisResultModel model) async {
    if (model.isRead) return;
    if (model.id.isEmpty || _isMarkingRead) return;

    _isMarkingRead = true;
    try {
      final response = await _networkCaller.patchRequest(
        '${Endpoints.fileAnalyses}${model.id}/mark-as-read/',
      );

      // Empty body (200/204) hole _handleResponse isSuccess false dite pare,
      // tai status code o dekhi
      final bool ok = response.isSuccess ||
          response.statusCode == 200 ||
          response.statusCode == 204;

      if (ok) {
        // Local result eo read kore rakhi, jate abar hit na hoy
        result.value = AnalysisResultModel(
          id: model.id,
          totalPages: model.totalPages,
          createdAt: model.createdAt,
          aiResponse: model.aiResponse,
          isRead: true,
        );

        // History screen e "New" badge sathe sathe soriye dei
        if (Get.isRegistered<HistoryController>()) {
          Get.find<HistoryController>().markAsReadLocally(model.id);
        }
      } else {
        debugPrint(
            'mark-as-read failed: ${response.statusCode} ${response.errorMessage}');
      }
    } catch (e) {
      // Mark-as-read fail korle user er experience nosto korbo na, silent
      debugPrint('mark-as-read failed: $e');
    } finally {
      _isMarkingRead = false;
    }
  }

  // ══════════ Terms ══════════

  List<ImportantTerm> get _rawTerms =>
      result.value?.aiResponse.importantTerms ?? [];

  List<ImportantTerm> get _rawMissing =>
      result.value?.aiResponse.missingProtections ?? [];

  /// contract-এ যে clause গুলো আসলে পাওয়া গেছে (missing বাদে)।
  /// High/Medium/Low count, tab আর card list সব এখান থেকেই আসে।
  List<ImportantTerm> get allTerms =>
      _rawTerms.where((t) => !t.isMissing).toList();

  /// contract-এ নেই এমন clause — কোনো risk count-এ ঢুকবে না।
  /// নতুন format: missing_protections লিস্ট। পুরনো format: article_number "Not in contract"।
  List<ImportantTerm> get missingTerms => [
        ..._rawMissing,
        ..._rawTerms.where((t) => t.isMissing),
      ];

  // ── Count fallback: clause লিস্ট একদম খালি এলে backend-এর risk_breakdown থেকে count নেওয়া হবে ──
  RiskBreakdown? get _breakdown => result.value?.aiResponse.riskBreakdown;

  bool get _useBreakdown {
    final b = _breakdown;
    if (b == null) return false;
    if (allTerms.isNotEmpty || missingTerms.isNotEmpty) return false;
    return (b.total + b.missingClause) > 0;
  }

  /// Clauses Found = High + Medium + Standard(low)
  int get foundCount => _useBreakdown ? _breakdown!.total : allTerms.length;

  /// Missing Protections
  int get missingCount =>
      _useBreakdown ? _breakdown!.missingClause : missingTerms.length;

  int countOfLevel(String level) {
    if (_useBreakdown) {
      final b = _breakdown!;
      switch (level) {
        case 'high':
          return b.highRisk;
        case 'medium':
          return b.mediumRisk;
        case 'low':
          return b.lowRisk;
        default:
          return 0;
      }
    }
    return allTerms.where((t) => t.level == level).length;
  }

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

  // ══════════ Verdict level ══════════

  /// high >= medium && high >= low -> high
  /// medium >= low                 -> medium
  /// otherwise                     -> low
  /// সব count 0 হলে '' (neutral)
  String _pickLevel(int high, int medium, int low) {
    if (high + medium + low == 0) return '';
    if (high >= medium && high >= low) return 'high';
    if (medium >= low) return 'medium';
    return 'low';
  }

  /// শেষ ভরসা: backend-এর text থেকে (শুধু English keyword)
  String _normalizeLevel(String risk) {
    final r = risk.toLowerCase();
    if (r.contains('high')) return 'high';
    if (r.contains('medium') || r.contains('moderate')) return 'medium';
    if (r.contains('low') || r.contains('standard')) return 'low';
    return '';
  }

  /// Verdict card-er level (language-independent):
  /// 1) risk_breakdown-er count
  /// 2) না পেলে found clause গুলোর level count
  /// 3) তাও না পেলে overall_risk text (English keyword)
  /// Screen-এ label ও color দুটোই এই level থেকে আসবে, backend text না।
  String get verdictLevel {
    final b = result.value?.aiResponse.riskBreakdown;
    if (b != null) {
      final fromBreakdown = _pickLevel(b.highRisk, b.mediumRisk, b.lowRisk);
      if (fromBreakdown.isNotEmpty) return fromBreakdown;
    }

    final fromTerms = _pickLevel(
      countOfLevel('high'),
      countOfLevel('medium'),
      countOfLevel('low'),
    );
    if (fromTerms.isNotEmpty) return fromTerms;

    return _normalizeLevel(overallRisk);
  }

  String get formattedDate {
    final dateStr = createdAt;
    if (dateStr.isEmpty) return '';
    try {
      DateTime parsed = DateTime.parse(dateStr);

      final hasTimezone = RegExp(r'(Z|[+-]\d{2}:?\d{2})$').hasMatch(dateStr);
      if (!hasTimezone) {
        parsed = DateTime.utc(
          parsed.year,
          parsed.month,
          parsed.day,
          parsed.hour,
          parsed.minute,
          parsed.second,
        );
      }

      final d = parsed.toLocal();

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
          AppColors.error);
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
          _snack('Error', 'PDF link not found in response.', AppColors.error);
        }
      } else if (response.statusCode == 402) {
        if (pdfPurchasePending.value) {
          _snack(
              'Processing',
              'Your purchase is being processed. Please tap again in a few seconds.',
              AppColors.warning);
        } else {
          pdfCredits.value = 0; // button lock হয়ে যাবে
          _snack('PDF locked', 'Unlock the PDF report to view it.',
              AppColors.warning);
        }
      } else {
        _snack(
            'Error',
            response.errorMessage.isNotEmpty
                ? response.errorMessage
                : 'Failed to generate PDF report.',
            AppColors.error);
      }
    } catch (e) {
      _snack('Error', 'Something went wrong: $e', AppColors.error);
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
      colorText: AppColors.white,
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