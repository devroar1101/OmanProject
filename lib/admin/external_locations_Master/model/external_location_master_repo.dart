import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

final ExternalLocationMasterRepositoryProvider = StateNotifierProvider<
    ExternalLocationMasterRepository, List<ExternalLocationMaster>>((ref) {
  return ExternalLocationMasterRepository(ref);
});

class ExternalLocationMasterRepository
    extends StateNotifier<List<ExternalLocationMaster>> {
  ExternalLocationMasterRepository(this.ref) : super([]);
  final Ref ref;

  //Add
  Future<void> addExternalLocation({
    required String nameEnglish,
    required String nameArabic,
    required int typeId,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'nameEnglish': nameEnglish,
      'nameArabic': nameArabic,
      'typeId': typeId,
    };

    try {
      final response =
          await dio.post('/ExternalLocation/Create', data: requestBody);

      state = [
        ExternalLocationMaster(
            id: 0,
            nameArabic: nameArabic,
            nameEnglish: nameEnglish,
            typeId: typeId,
            isNew: response.data['data']['isNew'],
            isDeleted: response.data['data']['isDeleted'],
            objectId: 'as-da-sd-sa'),
        ...state
      ];
    } catch (e) {
      throw Exception('Error occurred while adding Subject: $e');
    }
  }

  //Edit
  Future<void> editExternalLocation(
      {required String nameEnglish,
      required String nameArabic,
      required int typeId,
      required int currentExternalLocationId}) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'externalLocationId': currentExternalLocationId,
      'nameEnglish': nameEnglish,
      'nameArabic': nameArabic,
      'typeId': typeId,
    };

    try {
      final response =
          await dio.put('/ExternalLocation/Update', data: requestBody);

      if (response.statusCode == 200) {
        final updatedExternalLocation = ExternalLocationMaster(
            id: currentExternalLocationId,
            nameArabic: nameArabic,
            nameEnglish: nameEnglish,
            typeId: typeId,
            isNew: response.data['data']['isNew'],
            isDeleted: response.data['data']['isDeleted'],
            objectId: '');

        state = [
          for (var externalLoaction in state)
            if (externalLoaction.id == currentExternalLocationId)
              updatedExternalLocation
            else
              externalLoaction
        ];
      } else {
        throw Exception(
            'Failed to update LetterSubject. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while editing LetterSubject: $e');
    }
  }

  /// Fetch Departments from the API
  Future<List<ExternalLocationMaster>> fetchExternalLocationMaster({
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
        '/Master/SearchAndListExternalLocation',
        data: requestBody,
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        state = data
            .map((item) =>
                ExternalLocationMaster.fromMap(item as Map<String, dynamic>))
            .toList();
            print( 'state :$state');
      } else {
        throw Exception('Failed to load External Location');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching Externa Location: $e');
    }
    return state;
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
