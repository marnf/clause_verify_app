// lib/features/analysis/model/analysis_result_model.dart

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

String _toStr(dynamic value) => value?.toString().trim() ?? '';

class AnalysisResultModel {
  final String id;
  final int totalPages;
  final String createdAt;
  final AiResponse aiResponse;

  AnalysisResultModel({
    required this.id,
    required this.totalPages,
    required this.createdAt,
    required this.aiResponse,
  });

  factory AnalysisResultModel.fromJson(Map<String, dynamic> json) {
    return AnalysisResultModel(
      id: _toStr(json['id']),
      totalPages: _toInt(json['total_pages']),
      createdAt: _toStr(json['created_at']),
      aiResponse: AiResponse.fromJson(
        (json['ai_response'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'total_pages': totalPages,
        'created_at': createdAt,
        'ai_response': aiResponse.toJson(),
      };
}

class AiResponse {
  final AnalysisSummary summary;
  final RiskBreakdown riskBreakdown;
  final List<String> positivePoints;
  final List<ImportantTerm> importantTerms;

  AiResponse({
    required this.summary,
    required this.riskBreakdown,
    required this.positivePoints,
    required this.importantTerms,
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      summary: AnalysisSummary.fromJson(
        (json['summary'] as Map<String, dynamic>?) ?? {},
      ),
      riskBreakdown: RiskBreakdown.fromJson(
        (json['risk_breakdown'] as Map<String, dynamic>?) ?? {},
      ),
      positivePoints: (json['positive_points'] as List<dynamic>? ?? [])
          .map((e) => _toStr(e))
          .where((e) => e.isNotEmpty)
          .toList(),
      importantTerms: (json['important_terms'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ImportantTerm.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'summary': summary.toJson(),
        'risk_breakdown': riskBreakdown.toJson(),
        'positive_points': positivePoints,
        'important_terms': importantTerms.map((e) => e.toJson()).toList(),
      };
}

class AnalysisSummary {
  final String country;
  final String overallRisk;
  final String recommendation;
  final String recommendationGuidance;

  AnalysisSummary({
    required this.country,
    required this.overallRisk,
    required this.recommendation,
    required this.recommendationGuidance,
  });

  factory AnalysisSummary.fromJson(Map<String, dynamic> json) {
    return AnalysisSummary(
      country: _toStr(json['country']),
      overallRisk: _toStr(json['overall_risk']),
      recommendation: _toStr(json['recommendation']),
      recommendationGuidance: _toStr(json['recommendation_guidance']),
    );
  }

  Map<String, dynamic> toJson() => {
        'country': country,
        'overall_risk': overallRisk,
        'recommendation': recommendation,
        'recommendation_guidance': recommendationGuidance,
      };
}

class RiskBreakdown {
  final int highRisk;
  final int mediumRisk;
  final int lowRisk;
  final int foundClause;
  final int missingClause;

  RiskBreakdown({
    required this.highRisk,
    required this.mediumRisk,
    required this.lowRisk,
    required this.foundClause,
    required this.missingClause,
  });

  int get total => highRisk + mediumRisk + lowRisk;

  factory RiskBreakdown.fromJson(Map<String, dynamic> json) {
    return RiskBreakdown(
      highRisk: _toInt(json['high_risk']),
      mediumRisk: _toInt(json['medium_risk']),
      lowRisk: _toInt(json['low_risk']),
      foundClause: _toInt(json['found_clause']),
      missingClause: _toInt(json['missing_clause']),
    );
  }

  Map<String, dynamic> toJson() => {
        'high_risk': highRisk,
        'medium_risk': mediumRisk,
        'low_risk': lowRisk,
        'found_clause': foundClause,
        'missing_clause': missingClause,
      };
}

class ImportantTerm {
  final String termTitle;
  final String status; // "red", "warning", "green"
  final String riskLevel; // "high", "medium", "low"
  final String extractedText;
  final String aiExplanation;
  final String aiRecommendation;
  final String lawReference;

  ImportantTerm({
    required this.termTitle,
    required this.status,
    required this.riskLevel,
    required this.extractedText,
    required this.aiExplanation,
    required this.aiRecommendation,
    required this.lawReference,
  });

  /// extracted_text খালি মানে contract-এ এই clause নেই (missing)
  bool get isMissing => extractedText.isEmpty;

  /// "high" | "medium" | "low" — risk_level না এলে status থেকে বের করা হয়
  String get level {
    final r = riskLevel.toLowerCase();
    if (r == 'high' || r == 'medium' || r == 'low') return r;
    switch (status.toLowerCase()) {
      case 'red':
        return 'high';
      case 'warning':
        return 'medium';
      default:
        return 'low';
    }
  }

  factory ImportantTerm.fromJson(Map<String, dynamic> json) {
    return ImportantTerm(
      termTitle: _toStr(json['term_title']),
      status: _toStr(json['status']),
      riskLevel: _toStr(json['risk_level']),
      extractedText: _toStr(json['extracted_text']),
      aiExplanation: _toStr(json['ai_explanation']),
      aiRecommendation: _toStr(json['ai_recommendation']),
      lawReference: _toStr(json['law_reference']),
    );
  }

  Map<String, dynamic> toJson() => {
        'term_title': termTitle,
        'status': status,
        'risk_level': riskLevel,
        'extracted_text': extractedText,
        'ai_explanation': aiExplanation,
        'ai_recommendation': aiRecommendation,
        'law_reference': lawReference,
      };
}