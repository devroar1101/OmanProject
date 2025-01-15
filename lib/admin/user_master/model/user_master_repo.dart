import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';

import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

final UserRepositoryProvider =
    StateNotifierProvider<UserRepository, List<User>>((ref) {
  return UserRepository(ref);
});

class UserRepository extends StateNotifier<List<User>> {
  UserRepository(this.ref) : super([]);
  final Ref ref;

  //Add

  Future<void> addUser({
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
    print('Secton ID $sectionId');
    print('dg ID $dgId');
    print('depat ID $departmentId');
    try {
      await dio.post('/User/Create', data: requestBody);

      state = [
        User(
            id: 1,
            eOfficeNumber: '1',
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
            loginId: '32192-12',
            dgId: dgId),
        ...state
      ];
    } catch (e) {
      throw Exception('Error occurred while adding User: $e');
    }
  }

  /// Fetch Departments from the API
  Future<List<User>> fetchUsers({
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
            .map((item) => User.fromMap(item as Map<String, dynamic>))
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

  Future<List<SelectOption<User>>> getUserOptions() async {
    List<User> userList = state;

    // Fetch userList if not already available
    if (userList.isEmpty) {
      userList = await fetchUsers();
    }

    // Build User Options with or without child options
    final List<SelectOption<User>> options = await Future.wait(
      userList.map((user) async {
        return SelectOption<User>(
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
    FutureProvider<List<SelectOption<User>>>((ref) async {
  return ref.read(UserRepositoryProvider.notifier).getUserOptions();
});
