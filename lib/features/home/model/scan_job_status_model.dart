class ScanJobStatus {
  final String jobId;
  final String? analysisId;
  final String status; // QUEUED / RUNNING / COMPLETED / FAILED / REJECTED
  final String stage; // QUEUED / ANALYZING / COMPLETED / NOT_A_CONTRACT ...
  final String message;
  final bool isRead; // user ei result age dekhe thakle true
  final String createdAt;
  final String? finishedAt;

  const ScanJobStatus({
    required this.jobId,
    required this.analysisId,
    required this.status,
    required this.stage,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.finishedAt,
  });

  /// Response: { "success": true, "message": "...", "data": {...} | null }
  /// data null hole null ferot dey (mane card dekhanor kichu nai)
  static ScanJobStatus? fromResponse(dynamic body) {
    if (body is! Map) return null;
    final data = body['data'];
    if (data is! Map) return null;
    return ScanJobStatus.fromJson(Map<String, dynamic>.from(data));
  }

  factory ScanJobStatus.fromJson(Map<String, dynamic> json) {
    String? nullable(dynamic v) {
      final s = v?.toString().trim() ?? '';
      return s.isEmpty ? null : s;
    }

    // is_read: true / "true" / 1 shob handle kore; na ashle false (card dekhabe)
    bool parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      return v?.toString().trim().toLowerCase() == 'true';
    }

    return ScanJobStatus(
      jobId: json['job_id']?.toString() ?? '',
      analysisId: nullable(json['analysis_id']),
      status: json['status']?.toString() ?? '',
      stage: json['stage']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      isRead: parseBool(json['is_read']),
      createdAt: json['created_at']?.toString() ?? '',
      finishedAt: nullable(json['finished_at']),
    );
  }

  /// 'rejected' | 'queued' | 'analyzing' | 'completed' | 'failed' | 'unknown'
  /// language-independent, shudhu status/stage theke ber hoy
  String get phase {
    final s = status.trim().toUpperCase();
    final st = stage.trim().toUpperCase();

    if (s == 'REJECTED' || st == 'NOT_A_CONTRACT') return 'rejected';
    if (s == 'FAILED' || s == 'ERROR' || st == 'FAILED') return 'failed';
    if (s == 'COMPLETED' || st == 'COMPLETED') return 'completed';
    if (s == 'QUEUED' || st == 'QUEUED') return 'queued';
    if (s == 'RUNNING' || st == 'ANALYZING') return 'analyzing';
    return 'unknown';
  }

  bool get isCompleted => phase == 'completed';
  bool get isFailed => phase == 'failed';

  /// Contract na hole (REJECTED / NOT_A_CONTRACT) => card dekhabo na
  bool get isRejected => phase == 'rejected';

  /// COMPLETED + is_read true => card dekhabo na, API-o r hit korbo na
  bool get isCompletedAndRead => isCompleted && isRead;

  /// ekhono kaj cholche (icon ghurbe, ghon ghon poll hobe)
  bool get isActive =>
      phase == 'queued' ||
      phase == 'analyzing' ||
      (phase == 'unknown' && finishedAt == null);

  // Same data barbar ele Obx rebuild na howar jonno
  @override
  bool operator ==(Object other) =>
      other is ScanJobStatus &&
      other.jobId == jobId &&
      other.analysisId == analysisId &&
      other.status == status &&
      other.stage == stage &&
      other.message == message &&
      other.isRead == isRead &&
      other.finishedAt == finishedAt;

  @override
  int get hashCode => Object.hash(
      jobId, analysisId, status, stage, message, isRead, finishedAt);
}