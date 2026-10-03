// lib/features/history/model/history_model.dart

class HistoryModel {
  final String id;
  final String title;
  final String country;
  final String overallRisk;
  final String recommendation;
  final DateTime? createdAt;

  // Optional: backend future e pathale line ta dekhabe
  final int? highRiskCount;
  final int? mediumRiskCount;
  final int? missingProtectionCount;

  HistoryModel({
    required this.id,
    required this.title,
    required this.country,
    required this.overallRisk,
    required this.recommendation,
    this.createdAt,
    this.highRiskCount,
    this.mediumRiskCount,
    this.missingProtectionCount,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    String s(dynamic v) => v?.toString().trim() ?? '';
    int? n(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return HistoryModel(
      id: s(json['id']),
      title: s(json['title']),
      country: s(json['country']),
      overallRisk: s(json['overall_risk']),
      recommendation: s(json['recommendation']),
      createdAt: DateTime.tryParse(s(json['created_at']))?.toLocal(),
      highRiskCount: n(json['high_risk_count']),
      mediumRiskCount: n(json['medium_risk_count']),
      missingProtectionCount: n(json['missing_protection_count']),
    );
  }

  bool get hasCounts =>
      highRiskCount != null ||
      mediumRiskCount != null ||
      missingProtectionCount != null;

  /// "high" | "medium" | "low" | "" (চেনা না গেলে খালি)
  /// Counts thakle counts theke, na hole overall_risk theke
  String get level {
    if (hasCounts) {
      if ((highRiskCount ?? 0) > 0) return 'high';
      if ((mediumRiskCount ?? 0) > 0) return 'medium';
      return 'low';
    }
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

  /// Card title: Document name / contract type
  String get displayTitle => title.isNotEmpty ? title : 'Untitled Document';

  /// Card subtitle: "Sep 29, 2026 · Canada"
  String get subtitle {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final parts = <String>[];
    if (createdAt != null) {
      final d = createdAt!;
      parts.add('${months[d.month - 1]} ${d.day}, ${d.year}');
    }
    if (country.isNotEmpty) parts.add(country);
    return parts.join(' · ');
  }

  /// "2 high risk · 1 medium risk · 1 missing protection" (0 gulo skip hobe)
  String get countsLine {
    final parts = <String>[];
    if ((highRiskCount ?? 0) > 0) parts.add('$highRiskCount high risk');
    if ((mediumRiskCount ?? 0) > 0) parts.add('$mediumRiskCount medium risk');
    if ((missingProtectionCount ?? 0) > 0) {
      parts.add('$missingProtectionCount missing protection');
    }
    return parts.join(' · ');
  }
}