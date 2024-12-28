// language_mannager.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationManager {
  static final LocalizationManager _instance = LocalizationManager._internal();
  factory LocalizationManager() => _instance;

  LocalizationManager._internal();

  Map<String, String>? _localizedStrings;

  // Initialize and load the selected language
  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentLanguage = prefs.getString('selectedLanguage') ?? 'ar';
    await _loadLanguage(currentLanguage);
  }

  // Clear the cached translations before loading a new language
  Future<void> _clearTranslations() async {
    if (_localizedStrings != null && _localizedStrings!.isNotEmpty) {
      _localizedStrings = null;
    }
    // Clear previous translations from memory
  }

  // Load the language file based on the selected language
  Future<void> _loadLanguage(String languageCode) async {
    await _clearTranslations(); // Clear old translations before loading new ones

    final String jsonString =
        await rootBundle.loadString('assets/lang/$languageCode.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  // Change the current language and reload it
  Future<void> changeLanguage(String languageCode) async {
    await _loadLanguage(languageCode);
  }

  // Fetch a translation for the given key
  String getTranslation(String key) {
    return _localizedStrings?[key] ?? key;
  }
}
