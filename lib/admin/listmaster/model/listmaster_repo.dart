import 'package:dio/dio.dart';
import 'package:tenderboard/admin/listmaster/model/listmaster.dart'; // Assuming the new class is `ListMaster`

class ListMasterRepository {
  final Dio _dio = Dio();
  final String _baseUrl =
      'http://eofficetbdevdal.cloutics.net/api/ListMaster';

  Future<List<ListMaster>> fetchListMasters() async {
    try {
      final response = await _dio.get('$_baseUrl/LookUpListMaster');

      // Check if the response is successful
      if (response.statusCode == 200) {
        List data = response.data as List;
        return data.map((item) => ListMaster.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load ListMasters');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching ListMasters: $e');
    }
  }
}
