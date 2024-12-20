import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/utilities/auth_provider.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

final UserMasterRepositoryProvider =
    StateNotifierProvider<UserMasterRepository, List<UserMaster>>((ref) {
  return UserMasterRepository(ref);
});

class UserMasterRepository extends StateNotifier<List<UserMaster>> {
  UserMasterRepository(this.ref) : super([]);
  final Ref ref;

  //Add

  Future<void> addUserMaster({
    required String name,
    required String displayName,
    required int dgId,
    required int departmentId,
    required int sectionId,
    required String email,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'name': name,
      'systemName': displayName,
      'email': email,
      'dgId': dgId,
      'departmentId': departmentId,
      'sectionId': sectionId,
    };

    try {
      await dio.post('/User/Create', data: requestBody);

      state = [
        UserMaster(
            id: 1,
            eOfficeId: '1',
            name: name,
            systemName: name,
            designationName: '',
            dgName: 'test User',
            departmentName: 'test Depat',
            sectionName: 'Test Section',
            isActive: true,
            email: email,
            roleName: 'name',
            objectId: 'das-da',
            departmentId: departmentId,
            sectionId: sectionId,
            dgId: dgId),
        ...state
      ];
    } catch (e) {
      throw Exception('Error occurred while adding User: $e');
    }
  }

  /// Fetch Departments from the API
  Future<List<UserMaster>> fetchUsers({
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
        '/Master/SearchAndListUser',
        data: requestBody,
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        state = data
            .map((item) => UserMaster.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load Users');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching Users: $e');
    }
    return state;
  }

  Future<List<SelectOption<UserMaster>>> getUserOptions() async {
    List<UserMaster> userList = state;

    // Fetch userList if not already available
    if (userList.isEmpty) {
      userList = await fetchUsers();
    }

    // Build User Options with or without child options
    final List<SelectOption<UserMaster>> options = await Future.wait(
      userList.map((user) async {
        return SelectOption<UserMaster>(
          displayName: user.name,
          key: user.id.toString(),
          value: user,
          filter: user.dgId.toString(),
          filter1: user.departmentId.toString(),
        );
      }).toList(),
    );

    return options;
  }
}

final userOptionsProvider =
    FutureProvider<List<SelectOption<UserMaster>>>((ref) async {
  return ref.read(UserMasterRepositoryProvider.notifier).getUserOptions();
});
