import 'package:clause_verify/core/models/response_data.dart';
import 'package:clause_verify/core/services/auth_service.dart';
import 'package:clause_verify/core/services/endpoints.dart';
import 'package:clause_verify/core/services/network_caller.dart';
import 'package:clause_verify/core/localization/language_constants.dart';
import 'package:clause_verify/core/localization/language_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  LocalizationController({required this.sharedPreferences}) {
    _loadCurrentLanguage();
  }

  // Private variables
  Locale _locale = Locale(
    LanguageConstants.DEFAULT_LANGUAGE_CODE,
    LanguageConstants.DEFAULT_COUNTRY_CODE,
  );
  bool _isLtr = true;
  List<LanguageModel> _languages = [];
  int _selectedIndex = 0;
  bool _isLoading = false;
  bool _isUpdating = false;

  // Getters
  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  List<LanguageModel> get languages => _languages;
  int get selectedIndex => _selectedIndex;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  
  // Get current language model
  LanguageModel get currentLanguage {
    return _languages.isNotEmpty 
        ? _languages[_selectedIndex] 
        : LanguageConstants.supportedLanguages[0];
  }

  /// Change language (base method)
  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    _isLtr = true; // English এবং French দুটোই LTR
    _saveLanguage(_locale);
    update();
  }

  /// Change language LOCALLY only (for onboarding - no API call)
  Future<void> changeLanguageLocally(String code) async {
    try {
      _isUpdating = true;
      update();
      
      var language = LanguageConstants.getLanguageByCode(code);
      if (language != null) {
        var index = _languages.indexWhere((lang) => lang.languageCode == code);
        if (index != -1) {
          setSelectIndex(index);
          setLanguage(Locale(language.languageCode, language.countryCode));
          
          print('✅ Language changed locally to: $code');
        }
      }
    } catch (e) {
      print('❌ Error changing language locally: $e');
    } finally {
      _isUpdating = false;
      update();
    }
  }

  /// Change language by code (with SERVER update - for logged-in users)
  Future<void> changeLanguageByCode(String code, {bool skipServerUpdate = false}) async {
    try {
      _isUpdating = true;
      update();

      var language = LanguageConstants.getLanguageByCode(code);
      if (language != null) {
        var index = _languages.indexWhere((lang) => lang.languageCode == code);
        if (index != -1) {
          bool success = true;

          if (!skipServerUpdate && _isUserLoggedIn()) {
            success = await _updateLanguageOnServer(code);

            if (!success) {
              Get.snackbar(
                'error'.tr,
                'languageUpdateFailed'.tr,
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.red,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 8,
              );
              _isUpdating = false;
              update();
              return;
            }
          }

          setSelectIndex(index);
          setLanguage(Locale(language.languageCode, language.countryCode));

          if (!skipServerUpdate && _isUserLoggedIn()) {
            Get.snackbar(
              'languageChanged'.tr,
              'languageUpdatedSuccessfully'.tr,
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 2),
              backgroundColor: const Color(0xFFD4AF37),
              colorText: Colors.black,
              margin: const EdgeInsets.all(16),
              borderRadius: 8,
            );
          }
        }
      }
    } catch (e) {
      print('❌ Error changing language: $e');
      Get.snackbar(
        'error'.tr,
        'networkError'.tr,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      _isUpdating = false;
      update();
    }
  }

  /// Change language by index
  Future<void> changeLanguageByIndex(int index, {bool skipServerUpdate = false}) async {
    if (index >= 0 && index < _languages.length) {
      setSelectIndex(index);
      var language = _languages[index];
      await changeLanguageByCode(language.languageCode, skipServerUpdate: skipServerUpdate);
    }
  }

  /// Check if user is logged in
  bool _isUserLoggedIn() {
    try {
      final token = AuthService.token;
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('Token check failed: $e');
      return false;
    }
  }

  /// Sync language to server (call this after login)
  Future<bool> syncLanguageToServer() async {
    if (!_isUserLoggedIn()) {
      print('❌ Cannot sync language: User not logged in');
      return false;
    }

    try {
      print('🔄 Syncing current language (${_locale.languageCode}) to server...');
      final success = await _updateLanguageOnServer(_locale.languageCode);
      
      if (success) {
        print('✅ Language synced to server successfully');
      } else {
        print('❌ Failed to sync language to server');
      }
      
      return success;
    } catch (e) {
      print('❌ Error syncing language to server: $e');
      return false;
    }
  }

  /// Update language preference on server
 /// Update language preference on server
  /// Update language preference on server
  Future<bool> _updateLanguageOnServer(String languageCode) async {
    try {
      // ✅ Updated: 5 languages supported
      final languageMap = {
        'en': 'english',
        'fr': 'french',
        'es': 'spanish',
        'de': 'german',
        'it': 'italian',
      };

      final languagePreference = languageMap[languageCode] ?? 'english';

      final Map<String, dynamic> requestData = {
        "language_preference": languagePreference,
      };

      // Get token for authenticated request
      String? token;
      try {
        token = AuthService.token;
        if (token == null || token.isEmpty) {
          print('⚠️ No token available, skipping server update');
          return false;
        }
      } catch (e) {
        print('Token not available: $e');
        return false;
      }

      // Call API
      final NetworkCaller networkCaller = NetworkCaller();
      final ResponseData response = await networkCaller.patchRequest(
        Endpoints.language,
        body: requestData,
        token: 'Bearer $token'
      );

      if (response.isSuccess) {
        try {
          final userData = response.responseData?['data'];
          if (userData != null) {
            await sharedPreferences.setString(
              'user_language_preference',
              languagePreference,
            );
          }
        } catch (e) {
          print('Error updating local user data: $e');
        }
        return true;
      } else {
        String errorMessage = response.responseData?['message'] ?? 
                             response.errorMessage ??
                             'language_update_failed'.tr;
        print('❌ Language update failed: $errorMessage');
        return false;
      }
    } catch (e) {
      print('❌ Network error updating language: $e');
      return false;
    }
  }

  /// Load current language from storage
  void _loadCurrentLanguage() async {
    _isLoading = true;
    update();

    try {
      String languageCode = sharedPreferences.getString(
            LanguageConstants.LANGUAGE_CODE,
          ) ??
          LanguageConstants.DEFAULT_LANGUAGE_CODE;

      String countryCode = sharedPreferences.getString(
            LanguageConstants.COUNTRY_CODE,
          ) ??
          LanguageConstants.DEFAULT_COUNTRY_CODE;

      _locale = Locale(languageCode, countryCode);
      _isLtr = true;

      // Find selected index
      _languages = List.from(LanguageConstants.supportedLanguages);
      for (int index = 0; index < _languages.length; index++) {
        if (_languages[index].languageCode == _locale.languageCode) {
          _selectedIndex = index;
          break;
        }
      }

      print('✅ Current language loaded: ${_locale.languageCode}');
    } catch (e) {
      print('❌ Error loading language: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }

  /// Save language to storage
  void _saveLanguage(Locale locale) async {
    try {
      await sharedPreferences.setString(
        LanguageConstants.LANGUAGE_CODE,
        locale.languageCode,
      );
      await sharedPreferences.setString(
        LanguageConstants.COUNTRY_CODE,
        locale.countryCode ?? '',
      );
      print('✅ Language saved: ${locale.languageCode}');
    } catch (e) {
      print('❌ Error saving language: $e');
    }
  }

  /// Set selected index
  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  /// Search language
  void searchLanguage(String query) {
    if (query.isEmpty) {
      _languages = List.from(LanguageConstants.supportedLanguages);
    } else {
      _languages = LanguageConstants.supportedLanguages
          .where((language) =>
              language.languageName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _selectedIndex = _languages.isNotEmpty ? 0 : -1;
    }
    update();
  }

  /// Reset to default language
  void resetToDefault() {
    setLanguage(Locale(
      LanguageConstants.DEFAULT_LANGUAGE_CODE,
      LanguageConstants.DEFAULT_COUNTRY_CODE,
    ));
    _selectedIndex = 0;
    update();
  }

  /// Refresh languages list
  void refreshLanguages() {
    _languages = List.from(LanguageConstants.supportedLanguages);
    update();
  }
}