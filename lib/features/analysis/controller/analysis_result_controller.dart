// lib/controllers/analysis_result_controller.dart

import 'package:flutter_extension/features/analysis/model/analysis_result_model.dart';
import 'package:get/get.dart';

class AnalysisResultController extends GetxController {
  // The result data passed when navigating to this screen
  final Rx<AnalysisResultModel?> result = Rx<AnalysisResultModel?>(null);

  // Track which term cards are expanded
  final RxSet<int> expandedIndexes = <int>{}.obs;

  // Active filter tab: 'all', 'high', 'medium', 'low'
  final RxString activeFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    // Accept data passed via Get.arguments
    final args = Get.arguments;
    if (args is AnalysisResultModel) {
      result.value = args;
    } else if (args is Map<String, dynamic>) {
      result.value = AnalysisResultModel.fromJson(args);
    }
  }

  /// Toggle expand/collapse of a term card
  void toggleExpand(int index) {
    if (expandedIndexes.contains(index)) {
      expandedIndexes.remove(index);
    } else {
      expandedIndexes.add(index);
    }
  }

  bool isExpanded(int index) => expandedIndexes.contains(index);

  /// Filter setter
  void setFilter(String filter) {
    activeFilter.value = filter;
    expandedIndexes.clear();
  }

  /// Returns filtered terms based on activeFilter
  List<ImportantTerm> get filteredTerms {
    final terms = result.value?.aiResponse.importantTerms ?? [];
    if (activeFilter.value == 'all') return terms;
    return terms
        .where((t) => t.riskLevel == activeFilter.value)
        .toList();
  }

  /// Overall risk color label
  String get overallRiskLabel =>
      result.value?.aiResponse.summary.overallRisk ?? '';

  int get confidenceScore =>
      result.value?.aiResponse.summary.confidenceScore ?? 0;

  String get country => result.value?.aiResponse.summary.country ?? '';

  String get recommendation =>
      result.value?.aiResponse.summary.recommendation ?? '';

  String get recommendationGuidance =>
      result.value?.aiResponse.summary.recommendationGuidance ?? '';

  RiskBreakdown? get riskBreakdown =>
      result.value?.aiResponse.riskBreakdown;

  List<String> get positivePoints =>
      result.value?.aiResponse.positivePoints ?? [];

  int get totalTerms =>
      result.value?.aiResponse.importantTerms.length ?? 0;
}