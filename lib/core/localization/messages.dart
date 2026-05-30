import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:convert';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': _enUS,
        'fr_FR': _frFR,
        'es_ES': _esES,
        'de_DE': _deDE,
        'it_IT': _itIT,
      };

  // Private variables
  static Map<String, String> _enUS = {};
  static Map<String, String> _frFR = {};
  static Map<String, String> _esES = {};
  static Map<String, String> _deDE = {};
  static Map<String, String> _itIT = {};

  // Getters
  static Map<String, String> get enUS => _enUS;
  static Map<String, String> get frFR => _frFR;
  static Map<String, String> get esES => _esES;
  static Map<String, String> get deDE => _deDE;
  static Map<String, String> get itIT => _itIT;

  /// Load all translation files
  static Future<void> loadTranslations() async {
    try {
      await Future.wait([
        _loadLanguage('en', 'assets/language/en.json', (map) => _enUS = map),
        _loadLanguage('fr', 'assets/language/fr.json', (map) => _frFR = map),
        _loadLanguage('es', 'assets/language/es.json', (map) => _esES = map),
        _loadLanguage('de', 'assets/language/de.json', (map) => _deDE = map),
        _loadLanguage('it', 'assets/language/it.json', (map) => _itIT = map),
      ]);
      print('✅ All translations loaded successfully');

      // Fill missing keys in non-English locales with English fallback
      _applyEnglishFallback();
    } catch (e) {
      print('❌ Error loading translations: $e');
      rethrow;
    }
  }

  /// Generic language loader
  static Future<void> _loadLanguage(
    String code,
    String path,
    void Function(Map<String, String>) setter,
  ) async {
    try {
      String jsonString = await rootBundle.loadString(path);
      setter(Map<String, String>.from(json.decode(jsonString)));
      print('✅ [$code] translations loaded');
    } catch (e) {
      print('⚠️ [$code] Could not load $path — using English fallback');
      // Don't rethrow: missing language file should not crash the app
    }
  }

  /// For any key missing in a non-English locale, copy from English
  static void _applyEnglishFallback() {
    for (final key in _enUS.keys) {
      _frFR.putIfAbsent(key, () => _enUS[key]!);
      _esES.putIfAbsent(key, () => _enUS[key]!);
      _deDE.putIfAbsent(key, () => _enUS[key]!);
      _itIT.putIfAbsent(key, () => _enUS[key]!);
    }
    print('✅ English fallback applied to all locales');
  }

  /// Check if a key exists in current language
  static bool hasKey(String key) {
    String currentLangCode = Get.locale?.languageCode ?? 'en';
    final map = _mapForCode(currentLangCode);
    return map.containsKey(key);
  }

  /// Get translation with fallback
  static String translate(String key, {String fallback = ''}) {
    if (hasKey(key)) return key.tr;
    if (_enUS.containsKey(key)) return _enUS[key]!;
    return fallback.isNotEmpty ? fallback : key;
  }

  static Map<String, String> _mapForCode(String code) {
    switch (code) {
      case 'fr':
        return _frFR;
      case 'es':
        return _esES;
      case 'de':
        return _deDE;
      case 'it':
        return _itIT;
      default:
        return _enUS;
    }
  }
}