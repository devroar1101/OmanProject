import 'package:dio/dio.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';

class DgMasterRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://eofficetbdevdal.cloutics.net/api/AdminstratorQueries',
     headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
    },
  ));
  

  /// Fetch DgMasters from the API
  Future<List<DgMaster>> fetchDgMasters({
    int pageSize = 15,
    int pageNumber = 1,
  }) async {
    Map<String, dynamic> requestBody = {
      'paginationDetail': {
        'pageSize': pageSize,
        'pageNumber': pageNumber,
      }
    };
    try {
      final response = await _dio.post(
        '/SearchAndListDG',
        data: requestBody,
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        List data = response.data as List;
        return data.map((item) => DgMaster.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load DgMasters');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching DgMasters: $e');
    }
  }

  /// Search and filter method for DgMaster based on optional nameArabic and nameEnglish
  Future<List<DgMaster>> searchAndFilter(List<DgMaster> dgMasters,
      {String? nameArabic, String? nameEnglish}) async {
    // Filter the list based on the provided nameArabic and nameEnglish filters
    var filteredList = dgMasters.where((dgMaster) {
      bool matchesArabic =
          nameArabic == null || dgMaster.nameArabic.contains(nameArabic);
      bool matchesEnglish =
          nameEnglish == null || dgMaster.nameEnglish.contains(nameEnglish);

      return matchesArabic && matchesEnglish;
    }).toList();

    return filteredList;
  }
}
