import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';
import 'package:tenderboard/office/inbox/model/inbox.dart';

final inboxRepositoryProvider =
    StateNotifierProvider<InboxRepository, List<LetterInbox>>((ref) {
  return InboxRepository(ref);
});

class InboxRepository extends StateNotifier<List<LetterInbox>> {
  InboxRepository(this.ref) : super([]);
  final Ref ref;

  // Fetch Inbox Items
  Future<List<LetterInbox>> fetchInbox(
      {required int userId, int pageSize = 15, int pageNumber = 1}) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      // 'userId': userId,
      'paginationDetail': {
        'pageSize': pageSize,
        'pageNumber': pageNumber,
      }
    };

    try {
      final response =
          await dio.post('/JobFlow/LetterInbox', data: requestBody);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        state = data
            .map((item) => LetterInbox.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load inbox items');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching inbox items: $e');
    }
    return state;
  }
}
