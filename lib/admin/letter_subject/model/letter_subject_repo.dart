import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/letter_subject/model/letter_subjecct.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

final letterSubjectMasterRepositoryProvider =
    StateNotifierProvider<LetterSubjectMasterRepository, List<LetterSubject>>(
        (ref) {
  return LetterSubjectMasterRepository(ref);
});

class LetterSubjectMasterRepository extends StateNotifier<List<LetterSubject>> {
  LetterSubjectMasterRepository(this.ref) : super([]);
  final Ref ref;

  //Add
  Future<void> addLetterSubject({
    required String subjectName,
    required String tenderNumber,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'name': subjectName,
      'tenderNumber': tenderNumber,
    };

    try {
      final response = await dio.post('/Subject/Create', data: requestBody);

      state = [
        LetterSubject(
          subject: subjectName,
          tenderNumber: tenderNumber,
          objectId: response.data['data']['objectId'],
          id: response.data['data']['id'],
        ),
        ...state
      ];
    } catch (e) {
      throw Exception('Error occurred while adding Subject: $e');
    }
  }

  /// Fetch Departments from the API
  Future<List<LetterSubject>> fetchLetterSubjects({
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
        '/Master/SearchAndListSubject',
        data: requestBody,
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        state = data
            .map((item) => LetterSubject.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load Letter Subject');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching Letter Subject: $e');
    }
    return state;
  }

  //Edit
  Future<void> editLetterSubject({
    required String subjectName,
    required String tenderNumber,
    required int currentSubjectId,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'subjectId': currentSubjectId,
      'name': subjectName,
      'tenderNumber': tenderNumber,
    };

    try {
      final response = await dio.put('/Subject/Update', data: requestBody);

      if (response.statusCode == 200) {
        final updatedLetterSubject = LetterSubject(
            subject: subjectName,
            tenderNumber: tenderNumber,
            objectId: response.data['data']['objectId'],
            id: response.data['data']['id']);

        state = [
          for (var letterSubject in state)
            if (letterSubject.id == currentSubjectId)
              updatedLetterSubject
            else
              letterSubject
        ];
      } else {
        throw Exception(
            'Failed to update LetterSubject. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while editing LetterSubject: $e');
    }
  }

  // Delete

  Future<void> deleteSubject({required int subjectId}) async {
    final dio = ref.watch(dioProvider);

    try {
      // Send the DELETE request to the API
      final response = await dio.delete(
        '/Subject/Delete',
        queryParameters: {'dgId': subjectId}, // Add dgId as a query parameter
      );

      if (response.statusCode == 200) {
        // Update the state by removing the deleted DgMaster
        state = state.where((subject) => subject.id != subjectId).toList();
      } else {
        throw Exception(
            'Failed to delete Subject. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while deleting Subject: $e');
    }
  }

  Future<List<SelectOption<LetterSubject>>> getSubjectByTenderNumber(
      String tenderNumber) async {
    final dio = ref.watch(dioProvider);

    Map<String, dynamic> requestBody = {"tenderNumber": tenderNumber};

    try {
      final response = await dio.post(
        '/Master/SearchListSubjectByTenderNumber',
        data: requestBody,
      );

      if (response.statusCode == 200 && response.data['isSuccess'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];

        print(data);

        // Convert API response into ListMasterItem objects
        List<LetterSubject> subjectItems =
            data.map((item) => LetterSubject.fromMap(item)).toList();

        // Convert subjectItems into SelectOption<ListMasterItem>
        List<SelectOption<LetterSubject>> options = subjectItems.map((item) {
          return SelectOption<LetterSubject>(
            displayName: item.tenderNumber,
            key: item.objectId, // Unique key for selection
            value: item, // Store full item as value
          );
        }).toList();

        return options;
      } else {
        throw Exception('Failed to fetch list master items');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching ListMaster items: $e');
    }
  }
}
