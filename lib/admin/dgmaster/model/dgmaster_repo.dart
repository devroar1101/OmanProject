import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/department_master/model/department_repo.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/section_master/model/section_master.dart';
import 'package:tenderboard/admin/section_master/model/section_master_repo.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/utilities/auth_provider.dart';
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
          id: Response.data['data']['dgId'],
          nameArabic: nameArabic,
          nameEnglish: nameEnglish,
          code: Response.data['data']['code'],
        ),
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

  Future<List<SelectOption<DgMaster>>> getDGOptions(
      String currentLanguage, bool includeChildOptions) async {
    List<DgMaster> dgList = state;
    List<Department> departments = [];
    List<SectionMaster> sections = [];

    // Fetch DGList if not already available
    if (dgList.isEmpty) {
      dgList = await fetchDgMasters();
    }

    if (includeChildOptions) {
      departments = await ref
          .read(departmentMasterRepositoryProvider.notifier)
          .fetchDepartments();
      sections = await ref
          .read(sectionMasterRepositoryProvider.notifier)
          .fetchSections();
    }

    // Build DG Options with or without child options
    final List<SelectOption<DgMaster>> options = await Future.wait(
      dgList.map((dg) async {
        List<SelectOption<Department>>? childOptions;

        if (includeChildOptions) {
          // Filter departments associated with the current cabinet
          final List<Department> filteredDepartment = departments
              .where((department) => department.dgId == dg.id)
              .toList();

          childOptions = filteredDepartment.map((department) {
            List<SelectOption<SectionMaster>>? subchildOptions;

            /*  final List<SectionMaster> filteredSection = sections
                .where((section) => section.departmentId == department.id)
                .toList();

            subchildOptions = filteredSection.map((section) {
              return SelectOption<SectionMaster>(
                displayName: currentLanguage == 'en'
                    ? section.sectionNameArabic
                    : section.sectionNameEnglish,
                key: section.sectionId.toString(),
                value: section,
              );
            }).toList();*/

            print(department.nameArabic);
            print(department.nameEnglish);

            return SelectOption<Department>(
                displayName: currentLanguage == 'en'
                    ? department.nameEnglish
                    : department.nameArabic,
                key: department.id.toString(),
                value: department);
          }).toList();
        }
        print('${dg.id} -- ${childOptions![0].displayName}');
        return SelectOption<DgMaster>(
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

final dgOptionsProvider =
    FutureProvider.family<List<SelectOption<DgMaster>>, bool?>(
        (ref, bool? child) async {
  final authState = ref.watch(authProvider);
  final isChild = child ?? false;

  return ref
      .read(dgMasterRepositoryProvider.notifier)
      .getDGOptions(authState.selectedLanguage, isChild);
});
