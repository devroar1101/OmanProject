import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/common/model/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(selectedLanguage: 'en')) {
    _loadAuthState(); // Load authentication state on startup
  }

  // Load authentication state from SharedPreferences
  Future<void> _loadAuthState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selectedLanguage') ?? 'en';
    final savedToken = prefs.getString('accessToken');
    final isAuthenticated =
        savedToken != null; // If a token exists, user is authenticated

    state = state.copyWith(
      selectedLanguage: savedLanguage,
      accessToken: savedToken,
      isAuthenticated: isAuthenticated,
    );
  }

  // Save the authentication state in SharedPreferences
  Future<void> _saveAuthState({String? userName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (state.isAuthenticated) {
      await prefs.setString('accessToken', state.accessToken!);
      await prefs.setString('username', userName!);
    } else {
      await prefs.remove('accessToken'); // Clear token on logout
    }
  }

  // Handle login and update authentication state
  void login(String username, String password, String selectedLanguage) async {
    final generatedToken = _generateRandomToken();
    state = state.copyWith(
      accessToken: generatedToken,
      isAuthenticated: true,
    );
    await changeLanguage(selectedLanguage); // Update language
    await _saveAuthState(userName: username); // Persist authentication state
  }

  // Handle logout and clear authentication state
  Future<void> logout() async {
    state = state.copyWith(
      accessToken: null,
      isAuthenticated: false,
    );
    await _saveAuthState(); // Clear authentication state
  }

  // Change the selected language and save it in SharedPreferences
  Future<void> changeLanguage(String language) async {
    state = state.copyWith(selectedLanguage: language);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
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
