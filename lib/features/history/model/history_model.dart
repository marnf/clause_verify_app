// History API Response Model
class HistoryApiModel {
  final String id;
  final String brandDetected;
  final String modelDetected;
  final String confidenceScore;
  final DateTime createdAt;

  HistoryApiModel({
    required this.id,
    required this.brandDetected,
    required this.modelDetected,
    required this.confidenceScore,
    required this.createdAt,
  });

  factory HistoryApiModel.fromJson(Map<String, dynamic> json) {
    return HistoryApiModel(
      id: json['id'] ?? '',
      brandDetected: json['brand_detected'] ?? 'Unknown Brand',
      modelDetected: json['model_detected'] ?? 'Unknown Model',
      confidenceScore: json['confidence_score'] ?? '0',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand_detected': brandDetected,
      'model_detected': modelDetected,
      'confidence_score': confidenceScore,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String _formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return '$day/$month/$year';
  }
}

// HistoryModel for UI
class HistoryModel {
  final String productName;
  final String modelNumber;
  final int score;
  final String date;
  final String? id;

  HistoryModel({
    required this.productName,
    required this.modelNumber,
    required this.score,
    required this.date,
    this.id,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      productName: json['productName'] ?? '',
      modelNumber: json['modelNumber'] ?? '',
      score: json['score'] ?? 0,
      date: json['date'] ?? '',
      id: json['id'],
    );
  }

  // Create from API model
  factory HistoryModel.fromApiModel(HistoryApiModel apiModel) {
    return HistoryModel(
      id: apiModel.id,
      productName: apiModel.brandDetected,
      modelNumber: apiModel.modelDetected,
      score: double.parse(apiModel.confidenceScore).round(),
      date: _formatDate(apiModel.createdAt),
    );
  }

  static String _formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return '$day/$month/$year';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'modelNumber': modelNumber,
      'score': score,
      'date': date,
    };
  }
}