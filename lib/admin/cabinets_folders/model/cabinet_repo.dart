import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder_repo.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/utilities/auth_provider.dart';

import 'package:tenderboard/common/utilities/dio_provider.dart';

final cabinetRepositoryProvider =
    StateNotifierProvider<CabinetRepository, List<Cabinet>>((ref) {
  return CabinetRepository(ref);
});

class CabinetRepository extends StateNotifier<List<Cabinet>> {
  CabinetRepository(this.ref) : super([]);
  final Ref ref;

  //Add
  Future<void> addCabinet(
      {required String nameEnglish, required String nameArabic}) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'nameEnglish': nameEnglish,
      'nameArabic': nameArabic,
    };

    try {
      await dio.post('/Cabinet/Create', data: requestBody);

      // After adding a Cabinet, we update the state to trigger a rebuild
      state = [
        Cabinet(
            nameEnglish: nameEnglish,
            nameArabic: nameArabic,
            id: 0,
            code: '0',
            objectId: '1111'),
        ...state
      ];
    } catch (e) {
      throw Exception('Error occurred while adding Cabinet: $e');
    }
  }

  //Onload
  Future<List<Cabinet>> fetchCabinets() async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'paginationDetail': {
        'pageSize': 15,
        'pageNumber': 1,
      }
    };

    try {
      if (state.isEmpty) {
        final response =
            await dio.post('/Master/SearchAndListCabinet', data: requestBody);

        if (response.statusCode == 200) {
          final List<dynamic> data = response.data as List;
          state = data
              .map((item) => Cabinet.fromMap(item as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Failed to load Cabinets: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error occurred while fetching Cabinets: $e');
    }
    return state;
  }

  //Edit
  Future<void> editCabinet(
      {required int id,
      required String nameEnglish,
      required String nameArabic}) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'nameEnglish': nameEnglish,
      'nameArabic': nameArabic,
    };

    try {
      // Make a PUT or PATCH request to edit the existing Cabinet
      await dio.put(
        '/Cabinet/Update', // Assuming you're using a RESTful API where you pass the ID in the URL
        data: requestBody,
      );

      final updatedCabinet = Cabinet(
        id: id,
        nameEnglish: nameEnglish,
        nameArabic: nameArabic,
        code: 'UpdatedCode',
        objectId: 'UpdatedObjectId',
      );

      // Update the state to reflect the edited Cabinet
      state = [
        for (var cabinet in state)
          if (cabinet.id == id) updatedCabinet else cabinet
      ];
    } catch (e) {
      throw Exception('Error occurred while editing Cabinet: $e');
    }
  }

  Future<List<SelectOption<Cabinet>>> getCabinetOptions(
      String currentLanguage, bool child) async {
    List<Cabinet> cabinets = state;

    if (cabinets.isEmpty) {
      cabinets =
          await ref.read(cabinetRepositoryProvider.notifier).fetchCabinets();
    }

    final List<SelectOption<Cabinet>> options = await Future.wait(
      cabinets.map((cabinet) async {
        List<SelectOption<Folder>>? childOptions;

        return SelectOption<Cabinet>(
          displayName: currentLanguage == 'en'
              ? cabinet.nameEnglish
              : cabinet.nameArabic,
          key: cabinet.id.toString(),
          value: cabinet,
          childOptions: childOptions,
        );
      }).toList(),
    );

    return options;
  }
}

final cabinetOptionsProvider =
    FutureProvider.family<List<SelectOption<Cabinet>>, bool?>(
        (ref, child) async {
  final authState = ref.watch(authProvider);
  bool isChild = child ?? false;
  return ref
      .read(cabinetRepositoryProvider.notifier)
      .getCabinetOptions(authState.selectedLanguage, isChild);
});
