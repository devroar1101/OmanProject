import 'package:dio/dio.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';

class UserMasterRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://eofficetbdevdal.cloutics.net/api/AdminstratorQueries',
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
    },
  ));

  /// Fetch Departments from the API
  Future<List<UserMaster>> fetchUsers({
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
        '/SearchAndListUser',
        data: requestBody,
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        List data = response.data as List;
        return data.map((item) => UserMaster.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load Users');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching Users: $e');
    }
  }

  // /// Search and filter method for Departments based on optional nameArabic and nameEnglish
  // Future<List<UserMaster>> searchAndFilter(List<UserMaster> users,
  //     {String? nameArabic, String? nameEnglish}) async {
  //   // Filter the list based on the provided nameArabic and nameEnglish filters
  //   var filteredList = users.where((UserMaster) {
  //     bool matchesArabic =
  //         nameArabic == null || department.departmentNameArabic.contains(nameArabic);
  //     bool matchesEnglish =
  //         nameEnglish == null || department.departmentNameEnglish.contains(nameEnglish);

  //     return matchesArabic && matchesEnglish;
  //   }).toList();

  //   return filteredList;
  // }
}
