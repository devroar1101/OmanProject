import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/listmaster/model/listmaster.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

final listMasterRepositoryProvider = StateNotifierProvider<ListMasterRepository, List<ListMaster>>((ref) {
  return ListMasterRepository(ref);
});

class ListMasterRepository extends StateNotifier<List<ListMaster>> {
  ListMasterRepository(this.ref) : super([]);
  final Ref ref;

  //Add
  Future<void> addListMaster({required String nameEnglish, required String nameArabic}) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'nameEnglish': nameEnglish,
      'nameArabic': nameArabic,
    };

    try {
      final response = await dio.post('/ListMaster/Create', data: requestBody);

      // After adding a ListMaster, we update the state to trigger a rebuild
      state = [ ListMaster(
        nameEnglish: nameEnglish, 
        nameArabic: nameArabic,
        id: response.data['data']['id'],
        listMasterCode: response.data['data']['code'],
        objectId: response.data['data']['objectId'],),...state];
    } catch (e) {
      throw Exception('Error occurred while adding ListMaster: $e');
    }
  }
  //Onload
  Future<List<ListMaster>> fetchListMasters() async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'paginationDetail': {
        'pageSize': 15,
        'pageNumber': 1,
      }
    };

    try {
      final response = await dio.post('/Master/SearchAndListMaster', data: requestBody);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        state = data.map((item) => ListMaster.fromMap(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load ListMasters: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching ListMasters: $e');
    }
    return state;
  }

  //Edit
  Future<void> editListMaster({required int id, required String nameEnglish, required String nameArabic}) async {
  final dio = ref.watch(dioProvider);
  Map<String, dynamic> requestBody = {
    'id': id,
    'nameEnglish': nameEnglish,
    'nameArabic': nameArabic,
  };

  try {
    // Make a PUT or PATCH request to edit the existing ListMaster
    final response = await dio.put(
      '/ListMaster/Update',  // Assuming you're using a RESTful API where you pass the ID in the URL
      data: requestBody,
    );
    print('listmaster commig result== > ${response.data}');

    // After successfully editing, update the state by replacing the old ListMaster with the updated one
    final updatedListMaster = ListMaster(
      id: id, // Ensure the id remains the same as the existing ListMaster
      nameEnglish: nameEnglish,
      nameArabic: nameArabic,
      listMasterCode: response.data['data']['code'],
        objectId: response.data['data']['objectId'], // Optionally update this if you receive a new value from the backend
      // Update if there are any changes to the items list, otherwise leave as is
    );

    // Update the state to reflect the edited ListMaster
    state = [
      for (var listMaster in state)
        if (listMaster.id == id) updatedListMaster else listMaster
    ];
  } catch (e) {
    throw Exception('Error occurred while editing ListMaster: $e');
  }
}

}







