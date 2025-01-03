import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder_permission.dart';

import 'package:tenderboard/common/utilities/dio_provider.dart';

final folderPermissionRepositoryProvider =
    StateNotifierProvider<FolderPermissionRepository, List<FolderPermission>>(
        (ref) {
  return FolderPermissionRepository(ref);
});

class FolderPermissionRepository extends StateNotifier<List<FolderPermission>> {
  FolderPermissionRepository(this.ref) : super([]);
  final Ref ref;

  // Add FolderPermission
  Future<void> addFolderPermission({
    required int folderId,
    required int userId,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'folderId': folderId,
      'userId': userId,
    };

    try {
      final response =
          await dio.post('/FolderPermission/Create', data: requestBody);

      state = [
        FolderPermission.fromMap(response.data['data']),
        ...state,
      ];
      print(state.length);
    } catch (e) {
      throw Exception('Error occurred while adding Folder Permission: $e');
    }
  }

  // Fetch FolderPermission by Folder ID
  Future<List<FolderPermission>> fetchPermissionsByFolderId(
      int folderId) async {
    final dio = ref.watch(dioProvider);

    try {
      final response =
          await dio.get('/FolderPermission/GetById', queryParameters: {
        'folderId': folderId,
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        state = data
            .map((item) =>
                FolderPermission.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Failed to load Folder Permissions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching Folder Permissions: $e');
    }

    return state;
  }

  // Edit FolderPermission
  Future<void> editFolderPermission({
    required int id,
    required int folderId,
    required int userId,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'id': id,
      'folderId': folderId,
      'userId': userId,
    };

    try {
      final response =
          await dio.put('/FolderPermission/Update', data: requestBody);

      final updatedPermission = FolderPermission.fromMap(response.data['data']);

      state = [
        for (var permission in state)
          if (permission.id == updatedPermission.id)
            updatedPermission
          else
            permission,
      ];
    } catch (e) {
      throw Exception('Error occurred while editing Folder Permission: $e');
    }
  }

  // Delete FolderPermission
  Future<void> deleteFolderPermission(int id) async {
    final dio = ref.watch(dioProvider);

    try {
      await dio.delete('/FolderPermission/Delete', queryParameters: {
        'id': id,
      });

      state = state.where((permission) => permission.id != id).toList();
    } catch (e) {
      throw Exception('Error occurred while deleting Folder Permission: $e');
    }
  }

  Future<List<FolderPermission>> fetchFolderPermissions() async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'paginationDetail': {
        'pageSize': '15',
        'pageNumber': '1',
      }
    };

    try {
      final response = await dio.post(
        '/Master/SearchAndListFolderPermission',
        data: requestBody,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        state = data
            .map((item) =>
                FolderPermission.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Failed to load Folder Permissions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching Folder Permissions: $e');
    }

    return state;
  }
}
