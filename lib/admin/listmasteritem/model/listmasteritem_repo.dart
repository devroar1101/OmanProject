import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/listmasteritem/model/listmasteritem.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

final listMasterItemRepositoryProvider =
    StateNotifierProvider<ListMasterItemRepository, List<ListMasterItem>>(
        (ref) {
  return ListMasterItemRepository(ref);
});

class ListMasterItemRepository extends StateNotifier<List<ListMasterItem>> {
  final Ref ref;
  ListMasterItemRepository(this.ref) : super([]);

  //Onload:-
  Future<List<ListMasterItem>> fetchListMasterItems({
    String? nameArabic,
    String? nameEnglish,
    required int currentListMasterId,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> queryParams = {
      'listMasterId': currentListMasterId,
      'paginationDetail': {
        'pageSize': 15,
        'pageNumber': 1,
      }
    };

    try {
      final response = await dio.post(
        '/Master/SearchAndListMasterItem',
        data: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data as List;
        state = data.map((item) => ListMasterItem.fromMap(item as Map<String,dynamic>)).toList();
      } else {
        throw Exception('Failed to load ListMasterItems');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching ListMasterItems: $e');
    }
    return state;
  }

  //Add:-
  Future<void> addListMasterItem(
      {required int listMasterId,
      required String nameEnglish,
      required String nameArabic}) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'listMasterId': listMasterId,
      'listMasterItemNameEnglish': nameEnglish,
      'listMasterItemNameArabic': nameArabic,
    };

    try {
      await dio.post('/ListMasterItem/Create', data: requestBody);
      state = [
        ListMasterItem(
            id: 0,
            listMasterId: listMasterId,
            nameArabic: nameArabic,
            nameEnglish: nameEnglish,
            code: '0',
            objectId: 'da-32,aaa'),...state
      ];
    } catch (e) {
      throw Exception('Error occurred while adding ListMasterItem: $e');
    }
  }

  //Edit

  Future<void> editListMasterItem(
      {
      required int listMasterItemId,
      required int listMasterId,
      required nameEnglish,
      required nameArabic}) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'listMasterItemId': listMasterItemId,
      'listMasterId': listMasterId,
      'listMasterItemNameEnglish': nameEnglish,
      'listMasterItemNameArabic': nameArabic,
    };

    try {
      await dio.put(
        '/ListMasterItem/Update',
        data: requestBody,
      );

      // After successfully editing, update the state by replacing the old ListMaster with the updated one
      final updatedListMasterItem = ListMasterItem(
        id: 0,
        listMasterId:
            listMasterId, // Ensure the id remains the same as the existing ListMaster
        nameEnglish: nameEnglish,
        nameArabic: nameArabic,
        code:
            '1', // Optionally update this if you receive a new value from the backend
        objectId:
            'UpdatedObjectId', // Optionally update this if you receive a new value from the backend
      );
      // Update the state to reflect the edited ListMaster
      state = [
        for (var listMasterItem in state)
          if (listMasterItem.id == listMasterId)
            updatedListMasterItem
          else
            listMasterItem
      ];
    } catch (e) {
      throw Exception('Error occurred while editing ListMasterItem: $e');
    }
  }
}
