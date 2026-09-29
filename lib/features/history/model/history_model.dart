// lib/features/history/model/history_model.dart

class HistoryModel {
  final String id;
  final String country;
  final String overallRisk;
  final String recommendation;

  HistoryModel({
    required this.id,
    required this.country,
    required this.overallRisk,
    required this.recommendation,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    String s(dynamic v) => v?.toString().trim() ?? '';

    return HistoryModel(
      id: s(json['id']),
      country: s(json['country']),
      overallRisk: s(json['overall_risk']),
      recommendation: s(json['recommendation']),
    );
  }

  /// "high" | "medium" | "low" | "" (চেনা না গেলে খালি)
  String get level {
    final r = overallRisk.toLowerCase();
    if (r.contains('high')) return 'high';
    if (r.contains('medium') || r.contains('moderate')) return 'medium';
    if (r == 'low' || r.startsWith('low ')) return 'low';
    return '';
  }

  /// "accept" | "review" | "reject" | "" (চেনা না গেলে খালি)
  String get recKind {
    final r = recommendation.toLowerCase();
    if (r.contains('reject') || r.contains('refuse')) return 'reject';
    if (r.contains('review') || r.contains('legal')) return 'review';
    if (r.contains('accept')) return 'accept';
    return '';
  }
}