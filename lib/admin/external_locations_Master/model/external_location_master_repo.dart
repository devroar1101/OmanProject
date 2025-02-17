import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/utilities/auth_provider.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

final ExternalLocationRepositoryProvider =
    StateNotifierProvider<ExternalLocationRepository, List<ExternalLocation>>(
        (ref) {
  return ExternalLocationRepository(ref);
});

class ExternalLocationRepository extends StateNotifier<List<ExternalLocation>> {
  ExternalLocationRepository(this.ref) : super([]);
  final Ref ref;

  //Add
  Future<void> addExternalLocation({
    required String nameEnglish,
    required String nameArabic,
    required String type,
    required String isNew,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'nameEnglish': nameEnglish,
      'nameArabic': nameArabic,
      'type': type,
      'isNew': isNew,
    };

    try {
      final response =
          await dio.post('/ExternalLocation/Create', data: requestBody);

      state = [
        ExternalLocation(
          id: response.data['data']['id'],
          nameArabic: nameArabic,
          nameEnglish: nameEnglish,
          type: type,
          isNew: isNew,
          isDeleted: response.data['data']['isDeleted'],
          objectId: response.data['data']['objectId'],
        ),
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
      required String type,
      required String isNew,
      required int currentExternalLocationId}) async {
    print('Id $currentExternalLocationId');
    print('English $nameEnglish');
    print('Arabic $nameArabic');
    print('type $type');
    print('isNew $isNew');
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'id': currentExternalLocationId,
      'nameEnglish': nameEnglish,
      'nameArabic': nameArabic,
      'type': type,
      'isNew': isNew,
    };

    try {
      final response =
          await dio.put('/ExternalLocation/Update', data: requestBody);
      print('external Location Object Id ${response.data}');
      if (response.statusCode == 200) {
        final updatedExternalLocation = ExternalLocation(
            id: currentExternalLocationId,
            nameArabic: nameArabic,
            nameEnglish: nameEnglish,
            type: type,
            isNew: isNew,
            isDeleted: false,
            objectId: response.data['data']['objectId']);

        state = [
          for (var externalLoaction in state)
            if (externalLoaction.id == currentExternalLocationId)
              updatedExternalLocation
            else
              externalLoaction
        ];
      } else {
        throw Exception(
            'Failed to update External Location. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while editing External Location: $e');
    }
  }

  Future<void> deleteExternalLocation({required int locationId}) async {
    final dio = ref.watch(dioProvider);

    try {
      final response = await dio.delete(
        '/ExternalLocation/Delete',
        queryParameters: {'Id': locationId},
      );

      if (response.statusCode == 200) {
        state = state.where((location) => location.id != locationId).toList();
      } else {
        throw Exception(
            'Failed to delete External Location. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while deleting External Locatioszn: $e');
    }
  }

  /// Fetch Departments from the API
  Future<List<ExternalLocation>> fetchExternalLocation({
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
                ExternalLocation.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load External Location');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching Externa Location: $e');
    }
    return state;
  }

  Future<List<SelectOption<ExternalLocation>>> getLocationOptions(
      String currentLanguage) async {
    List<ExternalLocation> locations = state;

    if (locations.isEmpty) {
      locations = await fetchExternalLocation();
    }

    // Create the options list
    final List<SelectOption<ExternalLocation>> options = await Future.wait(
      locations.map((location) async {
        return SelectOption<ExternalLocation>(
          displayName: currentLanguage == 'en'
              ? location.nameEnglish
              : location.nameArabic,
          key: location.id.toString(),
          filter1: location.isNew.toString(),
          value: location,
        );
      }).toList(),
    );

    return options;
  }
}

final locationOptionsProvider =
    FutureProvider<List<SelectOption<ExternalLocation>>>((ref) async {
  final authState = ref.watch(authProvider);

  return ref
      .read(ExternalLocationRepositoryProvider.notifier)
      .getLocationOptions(authState.selectedLanguage);
});
