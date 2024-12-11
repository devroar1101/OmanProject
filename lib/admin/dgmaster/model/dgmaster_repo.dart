import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

final dgMasterRepositoryProvider =
    StateNotifierProvider<DgMasterRepository, List<DgMaster>>((ref) {
  return DgMasterRepository(ref);
});

class DgMasterRepository extends StateNotifier<List<DgMaster>> {
  DgMasterRepository(this.ref) : super([]);
  final Ref ref;

//Add
  Future<void> addDgMaster(
      {required String nameEnglish, required String nameArabic}) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'dgNameEnglish': nameEnglish,
      'dgNameArabic': nameArabic,
    };

    try {
      final Response = await dio.post('/DG/Create', data: requestBody);

      state = [
        DgMaster(
            id: Response.data['dgId'],
            nameArabic: nameArabic,
            nameEnglish: nameEnglish,
            code: Response.data['code'],
            objectId: 'aa-aa-a'),
        ...state
      ];
    } catch (e) {
      throw Exception('Error occurred while adding DGMaster: $e');
    }
  }

  ///  Onload  // Fetch DgMasters from the API
  Future<List<DgMaster>> fetchDgMasters({
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
        '/Master/SearchAndListDG',
        data: requestBody,
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        state = data
            .map((item) => DgMaster.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load DgMasters');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching DgMasters: $e');
    }
    return state;
  }

  //Edit
  Future<void> editDGMaster({
    required String editNameEnglish,
    required String editNameArabic,
    required int currentDGId,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'dgId': currentDGId,
      'dgNameArabic': editNameArabic,
      'dgNameEnglish': editNameEnglish,
    };

    try {
      // Use await to ensure the request completes before proceeding
      final response = await dio.put('/DG/Update', data: requestBody);

      if (response.statusCode == 200) {
        // Create the updated DgMaster object
        final updatedDgMaster = DgMaster(
          id: currentDGId,
          nameArabic: editNameArabic,
          nameEnglish: editNameEnglish,
          code: '0', // Update this as needed
          objectId: 'das-das-d', // Update this as needed
        );

        // Update the state with the edited DgMaster
        state = [
          for (var dgMaster in state)
            if (dgMaster.id == currentDGId) updatedDgMaster else dgMaster
        ];
      } else {
        throw Exception(
            'Failed to update DGMaster. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while editing DGMaster: $e');
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

  Future<List<SelectOption<DgMaster>>> getDGOptions() async {
    List<DgMaster> DGList = state;

    if (DGList.isEmpty) {
      DGList =
          await ref.read(dgMasterRepositoryProvider.notifier).fetchDgMasters();
    }

    final List<SelectOption<DgMaster>> options =
        DGList.map((dg) => SelectOption<DgMaster>(
              displayName: dg.nameEnglish,
              key: dg.id.toString(),
              value: dg,
            )).toList();

    return options;
  }
}

final dgOptionsProvider =
    FutureProvider<List<SelectOption<DgMaster>>>((ref) async {
  return ref.read(dgMasterRepositoryProvider.notifier).getDGOptions();
});
