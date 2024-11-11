import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenderboard/common/model/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(selectedLanguage: 'English')) {
    _loadLanguage();
  }

  // Load the language preference from SharedPreferences
  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    state = state.copyWith(selectedLanguage: savedLanguage);
  }

  // Change the selected language and save it in SharedPreferences
  Future<void> changeLanguage(String language) async {
    state = state.copyWith(selectedLanguage: language);
    // Save the selected language in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
  }

  // Handle login and update authentication state
  void login(String username, String password, String selectedLanguage) {
    final generatedToken = _generateRandomToken();
    state = state.copyWith(
      accessToken: generatedToken,
      isAuthenticated: true,
    );
    changeLanguage(selectedLanguage); // Update language after login
  }

  // Generate a random token (for demo purposes)
  String _generateRandomToken() {
    final random = Random();
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(
        32, (index) => characters[random.nextInt(characters.length)]).join();
  }
}

// Auth provider to use the AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
