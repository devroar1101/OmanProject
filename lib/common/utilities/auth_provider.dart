import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet_repo.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/common/model/auth_state.dart';
import 'dart:html' as html; // Import for window.location.reload() on web
import 'package:flutter/foundation.dart'; // Import to check platform

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref; // Add reference to Ref for accessing other providers

  AuthNotifier(this.ref) : super(AuthState(selectedLanguage: 'en')) {
    _initialize(); // Initialize the authentication state
  }

  // Initialize authentication state
  Future<void> _initialize() async {
    await _loadAuthState();
    // Trigger background fetching
  }

  // Load authentication state from SharedPreferences
  Future<void> _loadAuthState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selectedLanguage') ?? 'en';
    final savedToken = prefs.getString('accessToken');
    final isAuthenticated = savedToken != null;

    state = state.copyWith(
      selectedLanguage: savedLanguage,
      accessToken: savedToken,
      isAuthenticated: isAuthenticated,
    );
    preLoad();
  }

  // Save the authentication state in SharedPreferences
  Future<void> _saveAuthState({String? userName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (state.isAuthenticated) {
      await prefs.setString('accessToken', state.accessToken!);
      if (userName != null) {
        await prefs.setString('username', userName);
      }
    } else {
      await prefs.setString('selectedLanguage', 'en');
      await prefs.remove('accessToken');
    }
    preLoad();
  }

  // Handle login and update authentication state
  Future<void> login(
      String username, String password, String selectedLanguage) async {
    final generatedToken = _generateRandomToken();
    state = state.copyWith(
      accessToken: generatedToken,
      isAuthenticated: true,
    );
    await changeLanguage(selectedLanguage); // Update language
    await _saveAuthState(userName: username); // Persist authentication state
  }

  // Trigger background data preloading
  void preLoad() {
    if (state.isAuthenticated) {
      Future.microtask(() => ref.read(dgOptionsProvider(true)));
      Future.microtask(() => ref.read(cabinetOptionsProvider(true)));
    }
  }

  // Handle logout and clear authentication state
  Future<void> logout() async {
    state = state.copyWith(
        accessToken: null, isAuthenticated: false, selectedLanguage: 'en');

    await _saveAuthState(); // Clear authentication state

    // Check if the platform is web and refresh the page
    if (kIsWeb) {
      html.window.location.reload(); // This will refresh the browser window
    }
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
  return AuthNotifier(ref);
});
