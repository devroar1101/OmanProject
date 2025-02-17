import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/section_master/model/section_master.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

final sectionRepositoryProvider =
    StateNotifierProvider<SectionRepository, List<Section>>((ref) {
  return SectionRepository(ref);
});

class SectionRepository extends StateNotifier<List<Section>> {
  SectionRepository(this.ref) : super([]);

  final Ref ref;

  //Add
  Future<void> addSection(
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
        Section(
            id: response.data['data']['id'],
            departmentId: departmentId,
            dgId: dgId,
            code: response.data['data']['code'],
            nameArabic: nameArabic,
            nameEnglish: nameEnglish,
            objectId: response.data['data']['objectId']),
        //timeStamp: response.data['data']['timeStamp'],
        ...state
      ];
    } catch (e) {
      throw Exception('Error occurred while adding Section: $e');
    }
  }

//Edit
  Future<void> editSeactionMaster({
    required int currentDepartmentId,
    required int currentid,
    required String nameArabic,
    required String nameEnglish,
    required int currentDgId,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'departmentId': currentDepartmentId,
      'id': currentid,
      'dgId': currentDgId,
      'sectionNameEnglish': nameEnglish,
      'sectionNameArabic': nameArabic,
    };

    try {
      final response = await dio.put('/Section/Update', data: requestBody);

      if (response.statusCode == 200) {
        final updatedDepartment = Section(
          code: response.data['data']['id'],
          nameArabic: nameArabic,
          nameEnglish: nameEnglish,
          objectId: response.data['data']['objectId'],
          departmentId: currentDepartmentId,
          dgId: currentDgId,
          id: currentid,
        );

        // Update the state with the edited DgMaster
        state = [
          for (var Section in state)
            if (Section.id == currentid) updatedDepartment else Section
        ];
      } else {
        throw Exception(
            'Failed to update Section.Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while editing Section: $e');
    }
  }

  Future<void> deleteSection({required int id}) async {
    final dio = ref.watch(dioProvider);

    try {
      final response = await dio.delete(
        '/Section/Delete',
        queryParameters: {'Id': id},
      );

      if (response.statusCode == 200) {
        state = state.where((section) => section.id != id).toList();
      } else {
        throw Exception(
            'Failed to delete section. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while deleting Section: $e');
    }
  }

  /// Fetch Sections from the API
  Future<List<Section>> fetchSections({
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
        final List<dynamic> data = response.data as List;
        state = data
            .map((item) => Section.fromMap(item as Map<String, dynamic>))
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
  Future<List<Section>> searchAndFilter(List<Section> sections,
      {String? nameArabic, String? nameEnglish}) async {
    // Filter the list based on the provided nameArabic and nameEnglish filters
    var filteredList = sections.where((section) {
      bool matchesArabic =
          nameArabic == null || section.nameArabic.contains(nameArabic);
      bool matchesEnglish =
          nameEnglish == null || section.nameEnglish.contains(nameEnglish);

      return matchesArabic && matchesEnglish;
    }).toList();

    return filteredList;
  }

  Future<List<SelectOption<Section>>> getSectionOptions(
    String? currentDepartmentId,
  ) async {
    List<Section> sectionList = state;

    if (sectionList.isEmpty) {
      sectionList =
          await ref.read(sectionRepositoryProvider.notifier).fetchSections();
    }
    if (currentDepartmentId != null) {
      sectionList = sectionList
          .where((section) =>
              section.departmentId.toString() == currentDepartmentId)
          .toList();
    }
    List<SelectOption<Section>> options = sectionList
        .map((section) => SelectOption<Section>(
              displayName: section.nameEnglish,
              key: section.id.toString(),
              value: section,
            ))
        .toList();

    return options;
  }
}

final sectionOptionsProvider =
    FutureProvider.family<List<SelectOption<Section>>, String?>(
        (ref, currentdepatmentId) async {
  return ref
      .read(sectionRepositoryProvider.notifier)
      .getSectionOptions(currentdepatmentId);
});
