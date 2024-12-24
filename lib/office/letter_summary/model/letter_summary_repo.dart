import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/auth_provider.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';
import 'package:tenderboard/office/letter_summary/model/letter_summary.dart';

// Repository Class
class LetterSummaryRepository {
  final Dio dio;
  final String lang;

  LetterSummaryRepository(this.dio, this.lang);

  Future<LetterSummaryResult> fetchLetterSummary(String objectId) async {
    try {
      final response = await dio.post(
        '/JobFlow/LetterSummaryDetails',
        data: {
          'objectId': objectId,
        },
        options: Options(headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200 && response.data != null) {
        // Assuming the response is a list of letter summaries
        var letterData = List<Map<String, dynamic>>.from(response.data);

        // Convert the first element to a LetterSummaryResult object
        return LetterSummaryResult.fromMap(letterData[0], lang);
      } else {
        throw Exception('Failed to load letter summary');
      }
    } catch (e) {
      rethrow;
    }
  }
}

// Provider for LetterSummaryRepository
final letterSummaryRepositoryProvider =
    Provider<LetterSummaryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final lang = ref
      .watch(authProvider)
      .selectedLanguage; // Assuming you have dioProvider defined elsewhere
  return LetterSummaryRepository(dio, lang);
});
