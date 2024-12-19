import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';
import 'package:tenderboard/office/document_search/model/document_search.dart';

final DocumentSearchRepositoryProvider =
    StateNotifierProvider<DocumentSearchRepository, List<DocumentSearch>>((ref) {
  return DocumentSearchRepository(ref);
});

class DocumentSearchRepository extends StateNotifier<List<DocumentSearch>> {
  DocumentSearchRepository(this.ref) : super([]);
  final Ref ref;

  /// Fetch List of Document Searches
  Future<List<DocumentSearch>> fetchListDocumentSearch({
    int pageSize = 15,
    int pageNumber = 1,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'paginationDetail': {
        'pageSize': pageSize,
        'pageNumber': pageNumber,
      }
    };
    try {
      final response = await dio.post(
        '/JobFlow/SearchandListDocumentSearch',
        data: requestBody,
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        state = data
            .map((item) => DocumentSearch.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load Document Searches');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching Document Searches: $e');
    }
    return state;
  }

  /// Additional methods (e.g., add, update, delete) can be implemented here
}
