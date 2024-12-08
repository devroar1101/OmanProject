import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/section_master/model/section_master.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

final SectionMasterRepositoryProvider =
    StateNotifierProvider<SectionMasterRepository, List<SectionMaster>>((ref) {
  return SectionMasterRepository(ref);
});

class SectionMasterRepository extends StateNotifier<List<SectionMaster>> {
  SectionMasterRepository(this.ref) : super([]);

  final Ref ref;

  //Add
  Future<void> AddSectionMaster(
      {required String nameEnglish,
      required String nameArabic,
      required int departmentId,
      required int dgId}) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'dgId': dgId,
      'departmentId': departmentId,
      'sectionNameEnglish': nameEnglish,
      'sectionNameArabic': nameArabic,
    };

    try {
      final response = await dio.post('/Section/Create', data: requestBody);
      state = [
        SectionMaster(
            sectionId: response.data['data']['sectionId'],
            departmentId: departmentId,
            dgId: dgId,
            code: response.data['data']['code'],
            sectionNameArabic: nameArabic,
            sectionNameEnglish: nameEnglish,
            objectId: response.data['data']['objectId'],
            timeStamp: response.data['data']['timeStamp']),
        ...state
      ];
    } catch (e) {
      throw Exception('Error occurred while adding SectionMaster: $e');
    }
  }

//Edit
  Future<void> editSeactionMaster({
    required int currentDepartmentId,
    required String nameArabic,
    required String nameEnglish,
    required int currentDgId,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'departmentId': currentDepartmentId,
      'dgId': currentDgId,
      'sectionNameEnglish': nameEnglish,
      'sectionNameArabic': nameArabic,
    };

    try {
      final response = await dio.put('/Section/Update', data: requestBody);

      if (response.statusCode == 200) {
        final updatedDepartment = SectionMaster(
            code: '0',
            sectionNameArabic: nameArabic,
            sectionNameEnglish: nameEnglish,
            objectId: 'ds-ds-d',
            departmentId: currentDepartmentId,
            dgId: currentDgId,
            sectionId: response.data['data']['sectionId'],
            timeStamp: response.data['data']['timeStamp']);

        // Update the state with the edited DgMaster
        state = [
          for (var sectionMaster in state)
            if (sectionMaster.sectionId == response.data['data']['sectionId'])
              updatedDepartment
            else
              sectionMaster
        ];
      } else {
        throw Exception(
            'Failed to update SectionMaster.Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while editing SectionMaster: $e');
    }
  }

  /// Fetch Sections from the API
  Future<List<SectionMaster>> fetchSections({
    int pageSize = 15,
    int pageNumber = 1,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'paginationDetail': {
        'pageSize': pageSize,
        'pageNumber': pageNumber,
      }
    };
    try {
      final response = await dio.post(
        '/Master/SearchAndListSection',
        data: requestBody,
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        List data = response.data as List;
        state = data
            .map((item) => SectionMaster.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load Sections');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching Sections: $e');
    }
    return state;
  }

  /// Search and filter method for Sections based on optional nameArabic and nameEnglish
  Future<List<SectionMaster>> searchAndFilter(List<SectionMaster> sections,
      {String? nameArabic, String? nameEnglish}) async {
    // Filter the list based on the provided nameArabic and nameEnglish filters
    var filteredList = sections.where((section) {
      bool matchesArabic =
          nameArabic == null || section.sectionNameArabic.contains(nameArabic);
      bool matchesEnglish = nameEnglish == null ||
          section.sectionNameEnglish.contains(nameEnglish);

      return matchesArabic && matchesEnglish;
    }).toList();

    return filteredList;
  }
}
