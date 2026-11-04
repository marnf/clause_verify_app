// lib/features/history/model/history_model.dart

class HistoryModel {
  final String id;
  final String title;
  final String country;
  final String overallRisk;
  final String recommendation;
  final DateTime? createdAt;

  /// false hole card er upore "New" tag dekhabe
  final bool isRead;

  // risk_breakdown থেকে
  final int? lowRisk;
  final int? highRisk;
  final int? mediumRisk;
  final int? foundClause;
  final int? missingClause;

  HistoryModel({
    required this.id,
    required this.title,
    required this.country,
    required this.overallRisk,
    required this.recommendation,
    this.isRead = true,
    this.createdAt,
    this.lowRisk,
    this.highRisk,
    this.mediumRisk,
    this.foundClause,
    this.missingClause,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    String s(dynamic v) => v?.toString().trim() ?? '';
    int? n(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    // is_read: bool / "True" / "False" / 1 / 0 shob handle kore.
    // Field na thakle ba null hole read dhore nibe (faltu "New" dekhabe na)
    bool b(dynamic v, {bool fallback = true}) {
      if (v == null) return fallback;
      if (v is bool) return v;
      if (v is num) return v != 0;
      final str = v.toString().trim().toLowerCase();
      if (str == 'true' || str == '1') return true;
      if (str == 'false' || str == '0') return false;
      return fallback;
    }

    // risk_breakdown null হলেও crash করবে না
    final rawBreakdown = json['risk_breakdown'];
    final Map<String, dynamic> breakdown = rawBreakdown is Map
        ? Map<String, dynamic>.from(rawBreakdown)
        : <String, dynamic>{};

    return HistoryModel(
      id: s(json['id']),
      title: s(json['title']),
      country: s(json['country']),
      overallRisk: s(json['overall_risk']),
      recommendation: s(json['recommendation']),
      isRead: b(json['is_read']),
      createdAt: DateTime.tryParse(s(json['created_at']))?.toLocal(),
      lowRisk: n(breakdown['low_risk']),
      highRisk: n(breakdown['high_risk']),
      mediumRisk: n(breakdown['medium_risk']),
      foundClause: n(breakdown['found_clause']),
      missingClause: n(breakdown['missing_clause']),
    );
  }

  /// Local e isRead change korar jonno
  HistoryModel copyWith({bool? isRead}) {
    return HistoryModel(
      id: id,
      title: title,
      country: country,
      overallRisk: overallRisk,
      recommendation: recommendation,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      lowRisk: lowRisk,
      highRisk: highRisk,
      mediumRisk: mediumRisk,
      foundClause: foundClause,
      missingClause: missingClause,
    );
  }

  bool get hasBreakdown =>
      lowRisk != null || highRisk != null || mediumRisk != null;

  /// "high" | "medium" | "low" | "" (breakdown না থাকলে খালি)
  ///
  /// শুধু risk_breakdown এর সংখ্যা থেকে ঠিক হয়, ভাষা/টেক্সট দেখে না।
  /// Logic:
  ///   high >= medium && high >= low  -> high
  ///   medium >= low                  -> medium
  ///   otherwise                      -> low
  String get level {
    if (!hasBreakdown) return '';

    final low = lowRisk ?? 0;
    final high = highRisk ?? 0;
    final medium = mediumRisk ?? 0;

    // সব 0 হলে কিছু বলার নেই -> grey
    if (low == 0 && high == 0 && medium == 0) return '';

    if (high >= medium && high >= low) return 'high';
    if (medium >= low) return 'medium';
    return 'low';
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

  /// Card subtitle: "Oct 30, 2026 · France"
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

  /// "10 high risk · 4 medium risk · 1 missing protection" (0 গুলো skip হবে)
  String get countsLine {
    final parts = <String>[];
    if ((highRisk ?? 0) > 0) parts.add('$highRisk high risk');
    if ((mediumRisk ?? 0) > 0) parts.add('$mediumRisk medium risk');
    if ((missingClause ?? 0) > 0) {
      parts.add('$missingClause missing protection');
    }
    return parts.join(' · ');
  }
}