// lib/features/history/model/history_model.dart

class HistoryModel {
  final String id;
  final String? createdAt;
  final String? country;
  final int? confidenceScore;
  final String? overallRisk;
  final String? isPaidScan;
  final String? isPaidReport;
  final String? recommendation;

  HistoryModel({
    required this.id,
    this.createdAt,
    this.country,
    this.confidenceScore,
    this.overallRisk,
    this.isPaidScan,
    this.isPaidReport,
    this.recommendation,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] ?? '',
      createdAt: json['created_at'] as String?,
      country: json['country'] as String?,
      confidenceScore: json['confidence_score'] as int?,
      overallRisk: json['overall_risk'] as String?,
      isPaidScan: json['is_paid_scan']?.toString(),
      isPaidReport: json['is_paid_report']?.toString(),
      recommendation: json['recommendation'] as String?,
    );
  }

  bool get hasData => confidenceScore != null && overallRisk != null;
  
  bool get isReportPaid => isPaidReport?.toLowerCase() == 'true';

  // Format date to "Jun 04, 2026"
  String get formattedDate {
    if (createdAt == null || createdAt!.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(createdAt!);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[dateTime.month - 1]} ${dateTime.day.toString().padLeft(2, '0')}, ${dateTime.year}';
    } catch (e) {
      return '';
    }
  }
}