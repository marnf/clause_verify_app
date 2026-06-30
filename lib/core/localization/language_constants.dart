import 'package:clause_verify/core/localization/language_model.dart';

class LanguageConstants {
  // SharedPreferences Keys
  static const String LANGUAGE_CODE = 'language_code';
  static const String COUNTRY_CODE = 'country_code';

  // Default Language
  static const String DEFAULT_LANGUAGE_CODE = 'en';
  static const String DEFAULT_COUNTRY_CODE = 'US';

  // Supported Languages List
  static List<LanguageModel> get supportedLanguages => [
        LanguageModel(
          languageName: 'English',
          countryCode: 'US',
          languageCode: 'en',
          flag: '🇺🇸',
        ),
        LanguageModel(
          languageName: 'Français',
          countryCode: 'FR',
          languageCode: 'fr',
          flag: '🇫🇷',
        ),
        LanguageModel(
          languageName: 'Español',
          countryCode: 'ES',
          languageCode: 'es',
          flag: '🇪🇸',
        ),
        LanguageModel(
          languageName: 'Deutsch',
          countryCode: 'DE',
          languageCode: 'de',
          flag: '🇩🇪',
        ),
        LanguageModel(
          languageName: 'Italiano',
          countryCode: 'IT',
          languageCode: 'it',
          flag: '🇮🇹',
        ),
      ];

  // Get language by code
  static LanguageModel? getLanguageByCode(String code) {
    try {
      return supportedLanguages.firstWhere(
        (lang) => lang.languageCode == code,
      );
    } catch (e) {
      return null;
    }
  }

  // Check if language is supported
  static bool isLanguageSupported(String code) {
    return supportedLanguages.any((lang) => lang.languageCode == code);
  }
}