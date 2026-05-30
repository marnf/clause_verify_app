

class AnalysisModel {
  final String id;
  final String status;
  final String analyzedAt;
  final double processingTime;
  final String planName;
  final String planCategory;
  final Authenticity authenticity;
  final WatchInformation watchInformation;
  final Map<String, ComponentDetail> components;
  final Map<String, String> componentScores;
  final Statistics statistics;
  final Map<String, String> componentStatus;
  final String expertNote;
  final Conclusion conclusion;
  final String reportId;
  final String dateOfIssue;
  final PriceEstimation priceEstimation;
  final bool pdfAvailable;
  final PdfFeatures pdfFeatures;
  final WatchImages images;
  final CertificateAndDocumentation certificateAndDocumentation;

  AnalysisModel({
    required this.id,
    required this.status,
    required this.analyzedAt,
    required this.processingTime,
    required this.planName,
    required this.planCategory,
    required this.authenticity,
    required this.watchInformation,
    required this.components,
    required this.componentScores,
    required this.statistics,
    required this.componentStatus,
    required this.expertNote,
    required this.conclusion,
    required this.reportId,
    required this.dateOfIssue,
    required this.priceEstimation,
    required this.pdfAvailable,
    required this.pdfFeatures,
    required this.images,
    required this.certificateAndDocumentation,
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    // Parse components
    Map<String, ComponentDetail> componentsMap = {};
    if (json['components'] != null) {
      (json['components'] as Map<String, dynamic>).forEach((key, value) {
        componentsMap[key] = ComponentDetail.fromJson(value);
      });
    }

    // Parse component scores
    Map<String, String> scoresMap = {};
    if (json['component_scores'] != null) {
      (json['component_scores'] as Map<String, dynamic>).forEach((key, value) {
        scoresMap[key] = value.toString();
      });
    }

    // Parse component status
    Map<String, String> statusMap = {};
    if (json['component_status'] != null) {
      (json['component_status'] as Map<String, dynamic>).forEach((key, value) {
        statusMap[key] = value.toString();
      });
    }

    return AnalysisModel(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      analyzedAt: json['analyzed_at'] ?? '',
      processingTime: json['processing_time']?.toDouble() ?? 0.0,
      planName: json['plan_name'] ?? '',
      planCategory: json['plan_category'] ?? '',
      authenticity: Authenticity.fromJson(json['authenticity'] ?? {}),
      watchInformation: WatchInformation.fromJson(json['watch_information'] ?? {}),
      components: componentsMap,
      componentScores: scoresMap,
      statistics: Statistics.fromJson(json['statistics'] ?? {}),
      componentStatus: statusMap,
      expertNote: json['expert_note'] ?? '',
      conclusion: Conclusion.fromJson(json['conclusion'] ?? {}),
      reportId: json['report_id'] ?? '',
      dateOfIssue: json['date_of_issue'] ?? '',
      priceEstimation: PriceEstimation.fromJson(json['price_estimation'] ?? {}),
      pdfAvailable: json['pdf_available'] ?? false,
      pdfFeatures: PdfFeatures.fromJson(json['pdf_features'] ?? {}),
      images: WatchImages.fromJson(json['images'] ?? {}),
      certificateAndDocumentation: CertificateAndDocumentation.fromJson(json['pdf_features'] ?? {}),
    );
  }

  // Getters for UI
  int get authenticityScore => authenticity.confidenceScore.round();
  
  String get authenticityStatus {
    if (authenticity.level.toLowerCase() == 'original') {
      return 'LIKELY AUTHENTIC';
    } else if (authenticity.level.toLowerCase() == 'replica') {
      return 'LIKELY REPLICA';
    } else {
      return 'UNCERTAIN';
    }
  }

  CategoryAnalysis get categoryAnalysis {
    List<CategoryItem> items = [];

    components.forEach((key, value) {
      // Extract numeric value from match_score (e.g., "95%" -> 95)
      int percentage = 0;
      try {
        percentage = int.parse(value.matchScore.replaceAll('%', '').trim());
      } catch (e) {
        percentage = 0;
      }

      items.add(CategoryItem(
        name: key,
        percentage: percentage,
        color: '#D4A574',
      ));
    });

    return CategoryAnalysis(
      title: 'Category Analysis',
      subtitle: 'Detailed component evaluation',
      items: items,
    );
  }

  ExpertCommentary get expertCommentary {
    List<CommentItem> comments = [];

    components.forEach((key, value) {
      int percentage = 0;
      try {
        percentage = int.parse(value.matchScore.replaceAll('%', '').trim());
      } catch (e) {
        percentage = 0;
      }

      comments.add(CommentItem(
        title: key,
        description: value.observations,
        icon: percentage >= 85 ? 'check' : 'warning',
      ));
    });

    return ExpertCommentary(
      title: 'Expert AI Commentary',
      subtitle: 'Detailed findings & observations',
      comments: comments,
    );
  }

  int get aiConfidenceLevel => conclusion.overallScore.round();
  
  // For backward compatibility with controller
  AnalysisDetailsCompat get analysisDetails {
    return AnalysisDetailsCompat(
      priceEstimation: priceEstimation,
      conclusion: conclusion,
    );
  }
}

// Compatibility class for controller access
class AnalysisDetailsCompat {
  final PriceEstimation priceEstimation;
  final Conclusion conclusion;

  AnalysisDetailsCompat({
    required this.priceEstimation,
    required this.conclusion,
  });
}

class Authenticity {
  final String level;
  final double confidenceScore;
  final String verdict;

  Authenticity({
    required this.level,
    required this.confidenceScore,
    required this.verdict,
  });

  factory Authenticity.fromJson(Map<String, dynamic> json) {
    return Authenticity(
      level: json['level'] ?? '',
      confidenceScore: json['confidence_score']?.toDouble() ?? 0.0,
      verdict: json['verdict'] ?? '',
    );
  }
}

class WatchInformation {
  final String brand;
  final String model;
  final String serialRefNo;
  final String dateOfAnalysis;

  WatchInformation({
    required this.brand,
    required this.model,
    required this.serialRefNo,
    required this.dateOfAnalysis,
  });

  factory WatchInformation.fromJson(Map<String, dynamic> json) {
    return WatchInformation(
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      serialRefNo: json['serial_ref_no'] ?? 'Unknown',
      dateOfAnalysis: json['date_of_analysis'] ?? '',
    );
  }
}

class ComponentDetail {
  final String matchScore;
  final String observations;

  ComponentDetail({
    required this.matchScore,
    required this.observations,
  });

  factory ComponentDetail.fromJson(Map<String, dynamic> json) {
    return ComponentDetail(
      matchScore: json['match_score'] ?? '0%',
      observations: json['observations'] ?? '',
    );
  }
}

class Statistics {
  final double averageComponentScore;
  final List<String> passedComponents;
  final List<String> failedComponents;
  final int totalComponentsAnalyzed;

  Statistics({
    required this.averageComponentScore,
    required this.passedComponents,
    required this.failedComponents,
    required this.totalComponentsAnalyzed,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      averageComponentScore: json['average_component_score']?.toDouble() ?? 0.0,
      passedComponents: List<String>.from(json['passed_components'] ?? []),
      failedComponents: List<String>.from(json['failed_components'] ?? []),
      totalComponentsAnalyzed: json['total_components_analyzed'] ?? 0,
    );
  }
}

class Conclusion {
  final String verdict;
  final double overallScore;
  final String authenticityLevel;
  final String expertNote;

  Conclusion({
    required this.verdict,
    required this.overallScore,
    required this.authenticityLevel,
    required this.expertNote,
  });

  factory Conclusion.fromJson(Map<String, dynamic> json) {
    return Conclusion(
      verdict: json['verdict'] ?? '',
      overallScore: json['overall_score']?.toDouble() ?? 0.0,
      authenticityLevel: json['authenticity_level'] ?? '',
      expertNote: json['expert_note'] ?? '',
    );
  }
}

class PriceEstimation {
  final String estimatedPrice;
  final String currency;
  final String conditionAssumed;
  final String confidenceLevel;
  final String notes;

  PriceEstimation({
    required this.estimatedPrice,
    required this.currency,
    required this.conditionAssumed,
    required this.confidenceLevel,
    required this.notes,
  });

  factory PriceEstimation.fromJson(Map<String, dynamic> json) {
    return PriceEstimation(
      estimatedPrice: json['estimated_price_usd']?.toString() ?? '0',
      currency: json['currency'] ?? 'USD',
      conditionAssumed: json['condition_assumed'] ?? '',
      confidenceLevel: json['confidence_level'] ?? '',
      notes: json['notes'] ?? '',
    );
  }
}

class PdfFeatures {
  final bool includesStamps;
  final bool isBilingual;

  PdfFeatures({
    required this.includesStamps,
    required this.isBilingual,
  });

  factory PdfFeatures.fromJson(Map<String, dynamic> json) {
    return PdfFeatures(
      includesStamps: json['includes_stamps'] ?? false,
      isBilingual: json['is_bilingual'] ?? false,
    );
  }
}


class CertificateAndDocumentation {
  final bool originalBox;
  final bool originalBrandCertificate;
  final bool invoice;

  CertificateAndDocumentation({
    required this.originalBox,
    required this.originalBrandCertificate,
    required this.invoice,
  });

  factory CertificateAndDocumentation.fromJson(Map<String, dynamic> json) {
    return CertificateAndDocumentation(
      originalBox: json['original_box'] ?? false,
      originalBrandCertificate: json['original_brand_certificate'] ?? false,
      invoice: json['invoice'] ?? false,
    );
  }
}

class WatchImages {
  final String? front;
  final String? back;
  final String? bracelet;

  WatchImages({
    this.front,
    this.back,
    this.bracelet,
  });

  factory WatchImages.fromJson(Map<String, dynamic> json) {
    return WatchImages(
      front: json['front'],
      back: json['back'],
      bracelet: json['bracelet'],
    );
  }
}

// Supporting models for UI
class CategoryAnalysis {
  final String title;
  final String subtitle;
  final List<CategoryItem> items;

  CategoryAnalysis({
    required this.title,
    required this.subtitle,
    required this.items,
  });
}

class CategoryItem {
  final String name;
  final int percentage;
  final String color;

  CategoryItem({
    required this.name,
    required this.percentage,
    required this.color,
  });
}

class ExpertCommentary {
  final String title;
  final String subtitle;
  final List<CommentItem> comments;

  ExpertCommentary({
    required this.title,
    required this.subtitle,
    required this.comments,
  });
}

class CommentItem {
  final String title;
  final String description;
  final String icon;

  CommentItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}