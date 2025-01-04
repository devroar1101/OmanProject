import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/department_master/model/department_repo.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/section_master/model/section_master.dart';
import 'package:tenderboard/admin/section_master/model/section_master_repo.dart';
import 'package:tenderboard/common/model/select_option.dart';

import 'package:tenderboard/common/utilities/auth_provider.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

final dgRepositoryProvider =
    StateNotifierProvider<DgRepository, List<Dg>>((ref) {
  return DgRepository(ref);
});

class DgRepository extends StateNotifier<List<Dg>> {
  DgRepository(this.ref) : super([]);
  final Ref ref;

//Add
  Future<void> addDg(
      {required String nameEnglish, required String nameArabic}) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'dgNameEnglish': nameEnglish,
      'dgNameArabic': nameArabic,
    };

    try {
      final Response = await dio.post('/DG/Create', data: requestBody);

      state = [
        Dg(
          id: Response.data['data']['dgId'],
          nameArabic: nameArabic,
          nameEnglish: nameEnglish,
          code: Response.data['data']['code'],
        ),
        ...state
      ];
    } catch (e) {
      throw Exception('Error occurred while adding DG: $e');
    }
  }

  ///  Onload  // Fetch Dgs from the API
  Future<List<Dg>> fetchDgs({
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
            .map((item) => Dg.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load Dgs');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching Dgs: $e');
    }
    return state;
  }

  //Edit
  Future<void> editDG({
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
        // Create the updated Dg object
        final updatedDg = Dg(
          id: currentDGId,
          nameArabic: editNameArabic,
          nameEnglish: editNameEnglish,
          code: '0', // Update this as needed
        );

        // Update the state with the edited Dg
        state = [
          for (var dg in state)
            if (dg.id == currentDGId) updatedDg else dg
        ];
      } else {
        throw Exception(
            'Failed to update DG. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while editing DG: $e');
    }
  }

  //Delete

  // Add this method in the DgRepository class
  Future<void> deleteDg({required int dgId}) async {
    final dio = ref.watch(dioProvider);

    try {
      // Send the DELETE request to the API
      final response = await dio.delete(
        '/DG/Delete',
        queryParameters: {'dgId': dgId}, // Add dgId as a query parameter
      );

      if (response.statusCode == 200) {
        // Update the state by removing the deleted Dg
        state = state.where((dg) => dg.id != dgId).toList();
      } else {
        throw Exception(
            'Failed to delete DG. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while deleting DG: $e');
    }
  }

  /// Search and filter method for Dg based on optional nameArabic and nameEnglish
  Future<List<Dg>> searchAndFilter(List<Dg> dgs,
      {String? nameArabic, String? nameEnglish}) async {
    // Filter the list based on the provided nameArabic and nameEnglish filters
    var filteredList = dgs.where((dg) {
      bool matchesArabic =
          nameArabic == null || dg.nameArabic.contains(nameArabic);
      bool matchesEnglish =
          nameEnglish == null || dg.nameEnglish.contains(nameEnglish);

      return matchesArabic && matchesEnglish;
    }).toList();

    return filteredList;
  }

  Future<List<SelectOption<Dg>>> getDGOptions(
      String currentLanguage, bool includeChildOptions) async {
    List<Dg> dgList = state;
    List<Department> departments = [];
    List<Section> sections = [];

    // Fetch DGList if not already available
    if (dgList.isEmpty) {
      dgList = await fetchDgs();
    }

    if (includeChildOptions) {
      departments = await ref
          .read(departmentRepositoryProvider.notifier)
          .fetchDepartments();
      sections =
          await ref.read(sectionRepositoryProvider.notifier).fetchSections();
    }

    // Build DG Options with or without child options
    final List<SelectOption<Dg>> options = await Future.wait(
      dgList.map((dg) async {
        List<SelectOption<Department>>? childOptions;

        if (includeChildOptions) {
          // Filter departments associated with the current cabinet
          final List<Department> filteredDepartment = departments
              .where((department) => department.dgId == dg.id)
              .toList();

          childOptions = filteredDepartment.map((department) {
            List<SelectOption<Section>>? subchildOptions;

            final List<Section> filteredSection = sections
                .where((section) => section.departmentId == department.id)
                .toList();

            subchildOptions = filteredSection.map((section) {
              print('${department.id}--${section.id}');
              return SelectOption<Section>(
                displayName: currentLanguage == 'en'
                    ? section.nameArabic
                    : section.nameEnglish,
                key: section.id.toString(),
                value: section,
              );
            }).toList();

            return SelectOption<Department>(
                displayName: currentLanguage == 'en'
                    ? department.nameEnglish
                    : department.nameArabic,
                key: department.id.toString(),
                value: department,
                childOptions: subchildOptions);
          }).toList();
        }

        return SelectOption<Dg>(
          displayName: currentLanguage == 'en' ? dg.nameEnglish : dg.nameArabic,
          key: dg.id.toString(),
          value: dg,
          childOptions: childOptions,
        );
      }).toList(),
    );

    return options;
  }
}

final dgOptionsProvider = FutureProvider.family<List<SelectOption<Dg>>, bool?>(
    (ref, bool? child) async {
  final authState = ref.watch(authProvider);
  final isChild = child ?? false;

  return ref
      .read(dgRepositoryProvider.notifier)
      .getDGOptions(authState.selectedLanguage, isChild);
});
