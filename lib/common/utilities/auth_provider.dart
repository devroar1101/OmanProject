// auth_notifier.dart
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet_repo.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master_repo.dart';
import 'package:tenderboard/admin/user_master/model/user_master_repo.dart';
import 'package:tenderboard/common/model/auth_state.dart';
import 'package:tenderboard/common/utilities/current_user.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';
import 'package:tenderboard/common/utilities/language_mannager.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(AuthState()) {
    _initialize();
  }

  // Initialize authentication state
  Future<void> _initialize() async {
    await _loadAuthState();
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
    await LocalizationManager()
        .changeLanguage(savedLanguage); // Ensure translations are loaded
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
      preLoad();
    } else {
      await prefs.setString('selectedLanguage', 'en');
      await prefs.remove('accessToken');
    }
  }

// Handle login and update authentication state
  Future<String> login(
      String username, String password, String selectedLanguage) async {
    final dio = ref.read(dioProvider); // Get Dio instance
    try {
      final response = await dio.post('/Authentication/SignIn', data: {
        'loginId': username,
        'password': password,
      });

      if (response.statusCode == 200 && response.data['data'] != null) {
        final userData = response.data['data'];
        // Set user details in CurrentUser singleton
        CurrentUser().setUserDetails(userData);

        // Update AuthState with token and authentication status
        state = state.copyWith(
          accessToken: userData['token'],
          isAuthenticated: true,
        );
        await changeLanguage(selectedLanguage);
        await _saveAuthState(userName: userData['name']);
        return "Login successful"; // Return success message
      } else {
        //temp
        state = state.copyWith(
          accessToken: '1111',
          isAuthenticated: true,
        );
        return 'Incorrect loginid or password. Please ensure your details are correct.'; // Return error message from API
      }
    } catch (e) {
      //temp
      //temp
      state = state.copyWith(
        accessToken: '1111',
        isAuthenticated: true,
      );
      /* state = state.copyWith(
        isAuthenticated: false,
        accessToken: null,
      );*/
      return 'Incorrect loginid or password. Please ensure your details are correct.'; // Return error message from API
    }
  }

  // Handle logout and clear authentication state
  Future<void> logout() async {
    CurrentUser().clearUserDetails();
    state = state.copyWith(
      accessToken: null,
      isAuthenticated: false,
      selectedLanguage: 'en',
    );
    await _saveAuthState();
  }

  // Change the selected language and save it in SharedPreferences
  Future<void> changeLanguage(String language) async {
    state = state.copyWith(selectedLanguage: language);
    await LocalizationManager()
        .changeLanguage(language); // Reload language translations
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
  }

  void preLoad() {
    if (state.isAuthenticated) {
      Future.microtask(() => ref.read(dgOptionsProvider(true)));
      Future.microtask(() => ref.read(cabinetOptionsProvider(true)));
      Future.microtask(() => ref.read(locationOptionsProvider));
      Future.microtask(() => ref.read(userOptionsProvider));
    }
  }
}

// Auth provider to use the AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
