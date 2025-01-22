import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/current_user.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';
import 'package:tenderboard/office/search_screens/model/list_response.dart';

final inboxRepositoryProvider =
    StateNotifierProvider<InboxRepository, ListResponse>((ref) {
  return InboxRepository(ref);
});

class InboxRepository extends StateNotifier<ListResponse> {
  InboxRepository(this.ref) : super(ListResponse(data: [], totalCount: 0));
  final Ref ref;

  // Fetch Inbox Items
  Future<ListResponse> fetchInbox({
    int pageSize = 30,
    int pageNumber = 1,
    String? searchFor,
    int? userId,
    int? status,
    required String screenName,
  }) async {
    final dio = ref.watch(dioProvider);

    // Build request body
    Map<String, dynamic> requestBody = {
      "searchFor": searchFor,
      "status": status,
      "screenName": screenName,
      "userId": userId ?? CurrentUser().userId,
      "paginationDetail": {
        "pageSize": pageSize,
        "pageNumber": pageNumber,
      },
    };

    try {
      final response = await dio.post(
        '/JobFlow/LetterInbox',
        data: requestBody,
      );

      if (response.statusCode == 200) {
        // Map response to ListResponse
        final listResponse = ListResponse.fromMap(response.data);

        // Update state with the new response
        state = listResponse;
      } else {
        throw Exception('Failed to load inbox items');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching inbox items: $e');
    }

    return state;
  }
}
