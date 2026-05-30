class LanguageModel {
  final String languageName;
  final String languageCode;
  final String countryCode;
  final String flag; // Optional: emoji flag

  LanguageModel({
    required this.languageName,
    required this.countryCode,
    required this.languageCode,
    this.flag = '',
  });

  // JSON থেকে object তৈরি
  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      languageName: json['languageName'] ?? '',
      countryCode: json['countryCode'] ?? '',
      languageCode: json['languageCode'] ?? '',
      flag: json['flag'] ?? '',
    );
  }

  // Object থেকে JSON তৈরি
  Map<String, dynamic> toJson() {
    return {
      'languageName': languageName,
      'countryCode': countryCode,
      'languageCode': languageCode,
      'flag': flag,
    };
  }
}