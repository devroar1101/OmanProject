import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationManager {
  static final LocalizationManager _instance = LocalizationManager._internal();
  factory LocalizationManager() => _instance;

  LocalizationManager._internal();

  Map<String, String>? _localizedStrings;
  String _currentLanguage = 'en';

  // Initialize and load the selected language
  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('selectedLanguage') ?? 'en';
    await _loadLanguage(_currentLanguage);
  }

  // Load a language file
  Future<void> _loadLanguage(String languageCode) async {
    final String jsonString =
        await rootBundle.loadString('assets/lang/$languageCode.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  // Change the current language
  Future<void> changeLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    await _loadLanguage(languageCode);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode);
  }

  // Fetch a translation
  String getTranslation(String key) {
    return _localizedStrings?[key] ?? key;
  }

  // Get the current language
  String get currentLanguage => _currentLanguage;
}
