import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for accessing app configuration
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig(
    baseUrl: dotenv.env['BASE_URL'] ?? '',
    appToken: dotenv.env['APP_TOKEN'] ?? '',
  );
});

class AppConfig {
  final String baseUrl;
  final String appToken;

  AppConfig({
    required this.baseUrl,
    required this.appToken,
  });

  /// Returns headers for API calls
  Map<String, String> get headers => {
        // "Authorization": "Bearer $appToken",
        "Content-Type": "application/json",
        "accept":"text/plain"
      };
}
