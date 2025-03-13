import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';
import 'package:tenderboard/office/document_search/model/document_search.dart';
import 'package:tenderboard/office/document_search/model/document_search_filter.dart';
import 'package:tenderboard/office/document_search/model/document_search_filter_repo.dart';

final documentSearchProvider =
    StateNotifierProvider<DocumentSearchRepository, SearchListResponse>((ref) {
  return DocumentSearchRepository(ref);
});

class DocumentSearchRepository extends StateNotifier<SearchListResponse> {
  DocumentSearchRepository(this.ref)
      : super(SearchListResponse(data: [], totalCount: 0));

  final Ref ref;

  Future<void> fetchListDocumentSearch() async {
    final dio = ref.read(dioProvider);

    final filterProvider = ref.read(documentSearchFilterProvider);
    final filter = DocumentSearchFilter.fromMap(filterProvider['filter']);
    final Map<String, dynamic> requestBody = {
      'paginationDetail': filterProvider['pagination'],
      ...filter.toMap(),
    };

    try {
      final response = await dio.post(
        '/JobFlow/SearchandListDocumentSearch',
        data: requestBody,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        state = SearchListResponse.fromMap(data);
      }
    } catch (e) {
      throw Exception('Error fetching document searches: $e');
    }
  }
}

// Create a StateNotifier for controlling the slider visibility
class SliderVisibilityNotifier extends StateNotifier<bool> {
  SliderVisibilityNotifier() : super(false); // Initialize to false (hidden)

  void toggleVisibility() {
    state = !state; // Toggle the visibility state
  }

  void show() {
    state = true; // Force show the slider
  }

  void hide() {
    state = false; // Force hide the slider
  }
}

// Create a provider for the SliderVisibilityNotifier
final sliderVisibilityProvider =
    StateNotifierProvider<SliderVisibilityNotifier, bool>((ref) {
  return SliderVisibilityNotifier();
});
