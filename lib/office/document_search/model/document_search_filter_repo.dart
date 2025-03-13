import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/office/document_search/model/document_search_filter.dart';
import 'package:tenderboard/office/document_search/model/document_search_repo.dart';

// A provider that holds both the filter and pagination
final documentSearchFilterProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'filter': DocumentSearchFilter().toMap(), // Initial filter
    'pagination': {'pageSize': 15, 'pageNumber': 1}, // Initial pagination
  };
});

// Method to update the filter
void updateFilter(WidgetRef ref, Map<String, dynamic> newFilter) {
  final currentState = ref.read(documentSearchFilterProvider);
  ref.read(documentSearchFilterProvider.notifier).state = {
    'filter': newFilter,
    'pagination': currentState['pagination'], // Keep pagination as is
  };
  ref.read(documentSearchProvider.notifier).fetchListDocumentSearch();
}

// Method to update pagination
void updatePagination(WidgetRef ref, {int? pageSize, int? pageNumber}) {
  final currentState = ref.read(documentSearchFilterProvider);
  ref.read(documentSearchFilterProvider.notifier).state = {
    'filter': currentState['filter'], // Keep filter as is
    'pagination': {
      'pageSize': pageSize ?? currentState['pagination']['pageSize'],
      'pageNumber': pageNumber ?? currentState['pagination']['pageNumber'],
    },
  };
  ref.read(documentSearchProvider.notifier).fetchListDocumentSearch();
}

// Method to clear both filter and pagination
void clearFilterAndPagination(WidgetRef ref) {
  ref.read(documentSearchFilterProvider.notifier).state = {
    'filter': DocumentSearchFilter().toMap(), // Reset filter
    'pagination': {'pageSize': 15, 'pageNumber': 1}, // Reset pagination
  };
  ref.read(documentSearchProvider.notifier).fetchListDocumentSearch();
}
