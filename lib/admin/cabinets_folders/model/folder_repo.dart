import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';

import 'package:tenderboard/common/utilities/dio_provider.dart';

final FolderRepositoryProvider =
    StateNotifierProvider<FolderRepository, List<Folder>>((ref) {
  return FolderRepository(ref);
});

class FolderRepository extends StateNotifier<List<Folder>> {
  FolderRepository(this.ref) : super([]);
  final Ref ref;

  //Add
  Future<void> addFolder(
      {required String nameEnglish,
      required String nameArabic,
      required int cabinetId}) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'cabinetFolderNameEnglish': nameEnglish,
      'cabinetFolderNameArabic': nameArabic,
      'cabinetId': cabinetId
    };

    try {
      await dio.post('/CabinetFolder/Create', data: requestBody);

      // After adding a Folder, we update the state to trigger a rebuild
      state = [
        Folder(
            nameEnglish: nameEnglish,
            nameArabic: nameArabic,
            cabinetId: cabinetId,
            id: 0,
            code: '0',
            objectId: '1111'),
        ...state
      ];
    } catch (e) {
      throw Exception('Error occurred while adding Folder: $e');
    }
  }

  //Onload
  Future<List<Folder>> fetchFolders() async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'paginationDetail': {
        'pageSize': 15,
        'pageNumber': 1,
      }
    };

    try {
      if (state.isEmpty) {
        final response = await dio.post('/Master/SearchAndListCabinetFolder',
            data: requestBody);

        if (response.statusCode == 200) {
          final List<dynamic> data = response.data as List;
          state = data
              .map((item) => Folder.fromMap(item as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Failed to load Folders: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error occurred while fetching Folders: $e');
    }
    return state;
  }

  //Edit
  Future<void> editFolder(
      {required int id,
      required String nameEnglish,
      required String nameArabic,
      required int cabinetId}) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'nameEnglish': nameEnglish,
      'nameArabic': nameArabic,
    };

    try {
      // Make a PUT or PATCH request to edit the existing Folder
      await dio.put(
        '/CabinetFolder/Update', // Assuming you're using a RESTful API where you pass the ID in the URL
        data: requestBody,
      );

      final updatedFolder = Folder(
        id: id,
        cabinetId: cabinetId,
        nameEnglish: nameEnglish,
        nameArabic: nameArabic,
        code: 'UpdatedCode',
        objectId: 'UpdatedObjectId',
      );

      // Update the state to reflect the edited Folder
      state = [
        for (var Folder in state)
          if (Folder.id == id) updatedFolder else Folder
      ];
    } catch (e) {
      throw Exception('Error occurred while editing Folder: $e');
    }
  }
}
