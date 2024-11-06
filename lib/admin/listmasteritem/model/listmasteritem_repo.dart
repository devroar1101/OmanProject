import 'package:dio/dio.dart';
import 'package:tenderboard/admin/listmasteritem/model/listmasteritem.dart';

class ListMasterItemRepository {
  final Dio _dio = Dio();
  final String _baseUrl =
      'http://eofficetbdevdal.cloutics.net/api/ListMasterItem';

  Future<List<ListMasterItem>> fetchListMasterItems() async {
    try {
      final response = await _dio.get('$_baseUrl/LookUpListMasterItem');

      // Check if the response is successful
      if (response.statusCode == 200) {
        List data = response.data as List;
        return data.map((item) => ListMasterItem.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load ListMasterItems');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching ListMasterItems: $e');
    }
  }
}
