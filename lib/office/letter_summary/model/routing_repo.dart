import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/auth_provider.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

import 'package:tenderboard/office/letter_summary/model/routing_history_result.dart';

// Repository Class
class RoutingHistoryRepository {
  final Dio dio;
  final String lang;

  RoutingHistoryRepository(this.dio, this.lang);

  Future<List<RoutingHistoryResult>> fetchRoutingHistory(
      String objectId) async {
    try {
      final response = await dio.post(
        '/JobFlow/RoutingHistory',
        data: {
          'objectId': objectId,
        },
        options: Options(headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200 && response.data != null) {
        // Assuming the response is a list of routing history entries
        List<RoutingHistoryResult> historyList = [];
        if (response.data is List) {
          historyList = (response.data as List<dynamic>)
              .map((item) =>
                  RoutingHistoryResult.fromMap(item as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected data format: ${response.data}');
        }

        // Convert the list to a list of RoutingHistoryResult objects
        return historyList;
      } else {
        throw Exception('Failed to load routing history');
      }
    } catch (e) {
      rethrow;
    }
  }
}

// Provider for RoutingHistoryRepository
final routingHistoryRepositoryProvider =
    Provider<RoutingHistoryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final lang = ref
      .watch(authProvider)
      .selectedLanguage; // Assuming you have dioProvider defined elsewhere
  return RoutingHistoryRepository(dio, lang);
});
