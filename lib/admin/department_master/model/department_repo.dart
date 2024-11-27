import 'package:dio/dio.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';

class DepartmentMasterRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://eofficetbdevdal.cloutics.net/api/AdminstratorQueries',
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
    },
  ));

  /// Fetch Departments from the API
  Future<List<Department>> fetchDepartments({
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
        '/SearchAndListDepartments',
        data: requestBody,
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        List data = response.data as List;
        return data.map((item) => Department.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load Departments');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching Departments: $e');
    }
  }

  /// Search and filter method for Departments based on optional nameArabic and nameEnglish
  Future<List<Department>> searchAndFilter(List<Department> departments,
      {String? nameArabic, String? nameEnglish}) async {
    // Filter the list based on the provided nameArabic and nameEnglish filters
    var filteredList = departments.where((department) {
      bool matchesArabic =
          nameArabic == null || department.departmentNameArabic.contains(nameArabic);
      bool matchesEnglish =
          nameEnglish == null || department.departmentNameEnglish.contains(nameEnglish);

      return matchesArabic && matchesEnglish;
    }).toList();

    return filteredList;
  }
}
