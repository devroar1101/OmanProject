import 'package:dio/dio.dart';
import 'package:tenderboard/office/inbox/model/inbox.dart';

class ListInboxRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://eofficetbdevdal.cloutics.net/api/JobWorkflowQueries',
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
    },
  ));

  Future<List<ListInbox>> fetchListInboxItems({
    String? toUserObjectId,
    String? screenName,
    int pageSize = 15,
    int pageNumber = 1,
  }) async {
    Map<String, dynamic> requestBody = {
      'screenName': screenName,
      "toUserObjectId": toUserObjectId,
      'paginationDetail': {
        'pageSize': pageSize,
        'pageNumber': pageNumber,
      }
    };
    try {
      final response = await _dio.post(
        '/SearchAndListLatestJobAction',
        data: requestBody,
      );
      print('Response status code: ${response.statusCode}');

      // Check if the response is successful
      if (response.statusCode == 200) {
        List data = response.data as List;
        List<ListInbox> listInboxItems =
            data.map((item) => ListInbox.fromMap(item)).toList();

        return listInboxItems;
      } else {
        throw Exception('Failed to load ListInboxItems');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching ListInboxItems: $e');
    }
  }
}
