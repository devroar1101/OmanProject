class AuthState {
  final String? accessToken;
  final bool isAuthenticated;
  final String selectedLanguage;

  AuthState({
    this.accessToken,
    this.isAuthenticated = false,
    this.selectedLanguage = 'ar', // Default to English
  });

  AuthState copyWith({
    String? accessToken,
    bool? isAuthenticated,
    String? selectedLanguage,
  }) {
    return AuthState(
      accessToken: accessToken ?? this.accessToken,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}
