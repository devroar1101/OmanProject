
import 'package:dio/dio.dart';
import 'package:tenderboard/office/document_search/model/document_search.dart';

class DocumentSearchRepository{
   final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://eofficetbdevdal.cloutics.net/api/JobWorkflowQueries',
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
    },
  ));

  Future<List<DocumentSearch>> fetchListDocumentSearch({
    String? userObjectId,
    int pageSize = 15,
    int pageNumber = 1,
  }) async{
    Map<String, dynamic> requestBody = {
    'userObjectId': userObjectId,
    'paginationDetail': {
      'pageSize': pageSize,
      'pageNumber': pageNumber,
    }};
    try {
      final response = await _dio.post(
        '/SearchAndListDocumentLetter',
        data: requestBody,
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        List data = response.data as List;
        List<DocumentSearch> listDocumentSearch = data.map((item) => DocumentSearch.fromMap(item)).toList();

        return listDocumentSearch;
      } else {
        throw Exception('Failed to load Document Search');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching Document Search: $e');
    }
  }
}