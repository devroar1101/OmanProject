import 'package:dio/dio.dart';
import 'package:tenderboard/office/outbox/model/outbox.dart';

class OutboxRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://eofficetbdevdal.cloutics.net/api/JobWorkflowQueries',
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
    },
  ));

  Future<List<Outbox>> fetchOutboxItem({
    String? fromUserObjectId,
    String? screenName,
    int pageSize = 15,
    int pageNumber = 1,
  }) async{
    Map<String, dynamic> requestBody = {
    'screenName': screenName,
    "toUserObjectId": fromUserObjectId,
    'paginationDetail': {
      'pageSize': pageSize,
      'pageNumber': pageNumber,
    }};
    try {
      final response = await _dio.post(
        '/SearchAndListLatestJobAction',
        data: requestBody,
      );
      print('Response status code: ${response.statusCode}');

      // Check if the response is successful
      if (response.statusCode == 200) {
        List data = response.data as List;
        List<Outbox> listOutboxItems = data.map((item) => Outbox.fromMap(item)).toList();

        return listOutboxItems;
      } else {
        throw Exception('Failed to load ListOutboxItems');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching ListOutboxItems: $e');
    }
  }
}