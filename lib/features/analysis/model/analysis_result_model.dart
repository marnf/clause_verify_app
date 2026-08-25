// lib/models/analysis_result_model.dart

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
      id: json['id'] ?? '',
      totalPages: json['total_pages'] ?? 0,
      createdAt: json['created_at'] ?? '',
      aiResponse: AiResponse.fromJson(json['ai_response'] ?? {}),
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
      summary: AnalysisSummary.fromJson(json['summary'] ?? {}),
      riskBreakdown: RiskBreakdown.fromJson(json['risk_breakdown'] ?? {}),
      positivePoints: List<String>.from(json['positive_points'] ?? []),
      importantTerms: (json['important_terms'] as List<dynamic>? ?? [])
          .map((e) => ImportantTerm.fromJson(e as Map<String, dynamic>))
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
  final int confidenceScore;
  final String overallRisk;
  final String recommendation;
  final String recommendationGuidance;

  AnalysisSummary({
    required this.country,
    required this.confidenceScore,
    required this.overallRisk,
    required this.recommendation,
    required this.recommendationGuidance,
  });

  factory AnalysisSummary.fromJson(Map<String, dynamic> json) {
    return AnalysisSummary(
      country: json['country'] ?? '',
      confidenceScore: json['confidence_score'] ?? 0,
      overallRisk: json['overall_risk'] ?? '',
      recommendation: json['recommendation'] ?? '',
      recommendationGuidance: json['recommendation_guidance'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'country': country,
        'confidence_score': confidenceScore,
        'overall_risk': overallRisk,
        'recommendation': recommendation,
        'recommendation_guidance': recommendationGuidance,
      };
}

class RiskBreakdown {
  final int highRisk;
  final int mediumRisk;
  final int lowRisk;

  RiskBreakdown({
    required this.highRisk,
    required this.mediumRisk,
    required this.lowRisk,
  });

  int get total => highRisk + mediumRisk + lowRisk;

  factory RiskBreakdown.fromJson(Map<String, dynamic> json) {
    return RiskBreakdown(
      highRisk: json['high_risk'] ?? 0,
      mediumRisk: json['medium_risk'] ?? 0,
      lowRisk: json['low_risk'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'high_risk': highRisk,
        'medium_risk': mediumRisk,
        'low_risk': lowRisk,
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
  final int confidenceScore;

  ImportantTerm({
    required this.termTitle,
    required this.status,
    required this.riskLevel,
    required this.extractedText,
    required this.aiExplanation,
    required this.aiRecommendation,
    required this.lawReference,
    required this.confidenceScore,
  });

  factory ImportantTerm.fromJson(Map<String, dynamic> json) {
    return ImportantTerm(
      termTitle: json['term_title'] ?? '',
      status: json['status'] ?? 'green',
      riskLevel: json['risk_level'] ?? 'low',
      extractedText: json['extracted_text'] ?? '',
      aiExplanation: json['ai_explanation'] ?? '',
      aiRecommendation: json['ai_recommendation'] ?? '',
      lawReference: json['law_reference'] ?? '',
      confidenceScore: json['confidence_score'] ?? 0,
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
        'confidence_score': confidenceScore,
      };
}