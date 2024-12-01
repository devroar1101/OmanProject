import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_config_provider.dart';

/// Provider for Dio instance
final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);

  final dio = Dio(BaseOptions(
    baseUrl: config.baseUrl,
    headers: config.headers,
  ));

  // Optional: Add interceptors for logging or error handling
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  return dio;
});
