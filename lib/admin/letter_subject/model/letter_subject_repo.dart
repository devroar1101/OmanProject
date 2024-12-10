
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/letter_subject/model/letter_subjecct.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

final LetterSubjectMasterRepositoryProvider =
    StateNotifierProvider<LetterSubjectMasterRepository, List<LetterSubjecct>>(
        (ref) {
  return LetterSubjectMasterRepository(ref);
});

class LetterSubjectMasterRepository
    extends StateNotifier<List<LetterSubjecct>> {
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
        LetterSubjecct(
          subject: subjectName,
          tenderNumber: tenderNumber,
          objectId: 'weq-eqw-eq',
          subjectId: 0,
        ),
        ...state
      ];
    } catch (e) {
      throw Exception('Error occurred while adding Subject: $e');
    }
  }

  /// Fetch Departments from the API
  Future<List<LetterSubjecct>> fetchLetterSubjects({
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
            .map((item) => LetterSubjecct.fromMap(item as Map<String, dynamic>))
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
        final updatedLetterSubject = LetterSubjecct(
            subject: subjectName,
            tenderNumber: tenderNumber,
            objectId: 'das-das',
            subjectId: 0);

        state = [
          for (var letterSubject in state)
            if (letterSubject.subjectId == currentSubjectId)
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

  // /// Search and filter method for Departments based on optional nameArabic and nameEnglish
  // Future<List<UserMaster>> searchAndFilter(List<UserMaster> users,
  //     {String? nameArabic, String? nameEnglish}) async {
  //   // Filter the list based on the provided nameArabic and nameEnglish filters
  //   var filteredList = users.where((UserMaster) {
  //     bool matchesArabic =
  //         nameArabic == null || department.departmentNameArabic.contains(nameArabic);
  //     bool matchesEnglish =
  //         nameEnglish == null || department.departmentNameEnglish.contains(nameEnglish);

  //     return matchesArabic && matchesEnglish;
  //   }).toList();

  //   return filteredList;
  // }
}
