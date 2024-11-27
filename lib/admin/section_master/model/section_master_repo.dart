import 'package:dio/dio.dart';
import 'package:tenderboard/admin/section_master/model/section_master.dart';

class SectionMasterRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://eofficetbdevdal.cloutics.net/api/AdminstratorQueries',
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
    },
  ));

  /// Fetch Sections from the API
  Future<List<SectionMaster>> fetchSections({
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
        '/SearchandListSections',
        data: requestBody,
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        List data = response.data as List;
        return data.map((item) => SectionMaster.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load Sections');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching Sections: $e');
    }
  }

  /// Search and filter method for Sections based on optional nameArabic and nameEnglish
  Future<List<SectionMaster>> searchAndFilter(List<SectionMaster> sections,
      {String? nameArabic, String? nameEnglish}) async {
    // Filter the list based on the provided nameArabic and nameEnglish filters
    var filteredList = sections.where((section) {
      bool matchesArabic =
          nameArabic == null || section.sectionNameArabic.contains(nameArabic);
      bool matchesEnglish =
          nameEnglish == null || section.sectionNameEnglish.contains(nameEnglish);

      return matchesArabic && matchesEnglish;
    }).toList();

    return filteredList;
  }
}
