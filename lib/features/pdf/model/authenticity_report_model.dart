// File: lib/features/pdf/model/authenticity_report_model.dart

class AuthenticityReportModel {
  final String reportId;
  final String dateOfIssue;
  final WatchInformation watchInfo;
  final List<ComponentAnalysis> components;
  final int overallScore;
  final String verdict;
  final String expertNote;
  final List<String> userPhotos;
  final String? qrCodeUrl;
  final String generatedBy;
  final String generatedDate;

  AuthenticityReportModel({
    required this.reportId,
    required this.dateOfIssue,
    required this.watchInfo,
    required this.components,
    required this.overallScore,
    required this.verdict,
    required this.expertNote,
    required this.userPhotos,
    this.qrCodeUrl,
    required this.generatedBy,
    required this.generatedDate,
  });

  factory AuthenticityReportModel.fromJson(Map<String, dynamic> json) {
    return AuthenticityReportModel(
      reportId: json['reportId'] ?? '',
      dateOfIssue: json['dateOfIssue'] ?? '',
      watchInfo: WatchInformation.fromJson(json['watchInfo'] ?? {}),
      components: (json['components'] as List?)
              ?.map((e) => ComponentAnalysis.fromJson(e))
              .toList() ??
          [],
      overallScore: json['overallScore'] ?? 0,
      verdict: json['verdict'] ?? '',
      expertNote: json['expertNote'] ?? '',
      userPhotos: List<String>.from(json['userPhotos'] ?? []),
      qrCodeUrl: json['qrCodeUrl'],
      generatedBy: json['generatedBy'] ?? '',
      generatedDate: json['generatedDate'] ?? '',
    );
  }

  // Single sample data - exactly matching the PDF design
  static Map<String, dynamic> getSampleData() {
    return {
      "reportId": "AWC-TEST-001",
      "dateOfIssue": "17/12/2025",
      "watchInfo": {
        "brand": "Rolex",
        "model": "Submariner",
        "serialRefNo": "125683",
        "dateOfAnalysis": "17/12/2025"
      },
      "components": [
        {
          "name": "Dial",
          "matchScore": 94,
          "observations": "The dial index spacing is consistent with authentic references. Hour markers show correct luminous application."
        },
        {
          "name": "Caseback",
          "matchScore": 87,
          "observations": "Caseback engraving seems slightly shallow compared to genuine models. Font weight appears lighter than expected."
        },
        {
          "name": "Bracelet / Clasp",
          "matchScore": 91,
          "observations": "Bracelet proportions match official measurements. Link spacing and finishing quality align with specifications."
        },
        {
          "name": "Crown",
          "matchScore": 82,
          "observations": "Text rendering on dial shows correct font characteristics. Spacing and kerning match manufacturer standards."
        },
        {
          "name": "Bezel",
          "matchScore": 89,
          "observations": "Surface finish exhibits proper texture pattern. Minor color variance detected but within acceptable tolerance."
        },
        {
          "name": "Hands",
          "matchScore": 96,
          "observations": "Serial number engraving depth and clarity match authentic examples. Character formation is precise."
        },
        {
          "name": "Crystal",
          "matchScore": 93,
          "observations": "Clasp mechanism shows correct spring tension and alignment. Finishing details consistent with components."
        },
        {
          "name": "Overall Proportions",
          "matchScore": 90,
          "observations": "Metal composition appears consistent with manufacturer specifications. Surface properties match characteristics."
        }
      ],
      "overallScore": 90,
      "verdict": "Authentic",
      "expertNote": "Based on the comprehensive analysis above, the examined watch shows strong consistency with authentic references. Key components such as the dial, hands, crystal, and overall proportions closely match genuine specifications. Minor variations observed in certain elements fall within acceptable manufacturing and wear tolerances. Overall, the watch demonstrates characteristics expected of an authentic model.",
      "userPhotos": [
        "https://images.unsplash.com/photo-1523170335258-f5ed11844a49?w=400&h=400&fit=crop",
        "https://images.unsplash.com/photo-1523170335258-f5ed11844a49?w=400&h=400&fit=crop",
        "https://images.unsplash.com/photo-1614164185128-e4ec99c436d7?w=400&h=400&fit=crop"
      ],
      "qrCodeUrl": "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=https://clauseverify.com/report/AWC-TEST-001",
      "generatedBy": "clauseverify",
      "generatedDate": "17/12/2025"
    };
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
      serialRefNo: json['serialRefNo'] ?? '',
      dateOfAnalysis: json['dateOfAnalysis'] ?? '',
    );
  }
}

class ComponentAnalysis {
  final String name;
  final int matchScore;
  final String observations;

  ComponentAnalysis({
    required this.name,
    required this.matchScore,
    required this.observations,
  });

  factory ComponentAnalysis.fromJson(Map<String, dynamic> json) {
    return ComponentAnalysis(
      name: json['name'] ?? '',
      matchScore: json['matchScore'] ?? 0,
      observations: json['observations'] ?? '',
    );
  }
}