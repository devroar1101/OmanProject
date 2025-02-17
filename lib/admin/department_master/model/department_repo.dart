import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/utilities/auth_provider.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

final departmentRepositoryProvider =
    StateNotifierProvider<DepartmentRepository, List<Department>>((ref) {
  return DepartmentRepository(ref);
});

class DepartmentRepository extends StateNotifier<List<Department>> {
  DepartmentRepository(this.ref) : super([]);
  final Ref ref;

  //Add
  Future<void> addDepartment(
      {required String nameEnglish,
      required String nameArabic,
      required String dgId}) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'dgId': dgId,
      'nameArabic': nameEnglish,
      'nameEnglish': nameArabic,
    };

    try {
      final Response = await dio.post('/Department/Create', data: requestBody);
      final currentDGId = int.parse(dgId);
      state = [
        Department(
            code: Response.data['data']['code'],
            nameArabic: nameArabic,
            nameEnglish: nameEnglish,
            dgNameEnglish: 'test',
            objectId: Response.data['data']['objectId'],
            id: Response.data['data']['id'],
            dgId: currentDGId),
        ...state
      ];
    } catch (e) {
      throw Exception('Error occurred while adding Department: $e');
    }
  }

  //Edit
  Future<void> editDepartment({
    required int currentDepartmentId,
    required String nameArabic,
    required String nameEnglish,
    required int dgId,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'id': currentDepartmentId,
      'dgId': dgId,
      'nameEnglish': nameEnglish,
      'nameArabic': nameArabic,
    };

    try {
      final response = await dio.put('/Department/Update', data: requestBody);

      if (response.statusCode == 200) {
        final updatedDepartment = Department(
            code: response.data['data']['code'],
            nameArabic: nameArabic,
            nameEnglish: nameEnglish,
            dgNameEnglish: 'test',
            objectId:response.data['data']['objectId'],
            id: currentDepartmentId,
            dgId: dgId);

        // Update the state with the edited Dg
        state = [
          for (var Department in state)
            if (Department.id == currentDepartmentId)
              updatedDepartment
            else
              Department
        ];
      } else {
        throw Exception(
            'Failed to update Department. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while editing Department: $e');
    }
  }

  // Delete
  Future<void> deleteDpartment({required int departmentId}) async {
    final dio = ref.watch(dioProvider);

    try {
      final response = await dio.delete(
        '/Department/Delete',
        queryParameters: {'Id': departmentId},
      );

      if (response.statusCode == 200) {
        state =
            state.where((department) => department.id != departmentId).toList();
      } else {
        throw Exception(
            'Failed to delete Department. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while deleting Department: $e');
    }
  }

  /// Fetch Departments from the API
  Future<List<Department>> fetchDepartments({
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
        '/Master/SearchAndListDepartment',
        data: requestBody,
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        List data = response.data as List;
        state = data
            .map((item) => Department.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load Departments');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching Departments: $e');
    }
    return state;
  }

  /// Search and filter method for Departments based on optional nameArabic and nameEnglish
  Future<List<Department>> searchAndFilter(List<Department> departments,
      {String? nameArabic, String? nameEnglish}) async {
    // Filter the list based on the provided nameArabic and nameEnglish filters
    var filteredList = departments.where((department) {
      bool matchesArabic =
          nameArabic == null || department.nameArabic.contains(nameArabic);
      bool matchesEnglish =
          nameEnglish == null || department.nameEnglish.contains(nameEnglish);

      return matchesArabic && matchesEnglish;
    }).toList();

    return filteredList;
  }

  Future<List<SelectOption<Department>>> getDepartMentOptions(
      String? currentDGId, String currentLanguage) async {
    List<Department> departmentList = state;

    if (departmentList.isEmpty) {
      departmentList = await fetchDepartments();
    }

    if (currentDGId != null) {
      departmentList = departmentList
          .where((deparment) => deparment.dgId.toString() == currentDGId)
          .toList();
    }
    print('Department List2 : $departmentList');
    List<SelectOption<Department>> options = departmentList
        .map((depatment) => SelectOption<Department>(
              displayName: currentLanguage == 'en'
                  ? depatment.nameEnglish
                  : depatment.nameArabic,
              key: depatment.id.toString(),
              value: depatment,
            ))
        .toList();

    return options;
  }
}

final departmentOptionsProvider =
    FutureProvider.family<List<SelectOption<Department>>, String?>(
        (ref, dgId) async {
  final authState = ref.watch(authProvider);
  print('Get depatment for dg :-> $dgId');
  return ref
      .read(departmentRepositoryProvider.notifier)
      
      .getDepartMentOptions(dgId, authState.selectedLanguage);
});
