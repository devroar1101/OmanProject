import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';
import 'package:tenderboard/office/List_circular/model/circular_decision.dart';

final circularDecisiondetailsRepositoryProvider = StateNotifierProvider<circularDecisiondetailsRepository, List<CircularDecisionSearch>>(
  (ref) {
    return circularDecisiondetailsRepository(ref);
  }
);


class circularDecisiondetailsRepository extends StateNotifier<List<CircularDecisionSearch>>{
  final Ref ref;
  circularDecisiondetailsRepository(this.ref) : super([]);

  //Onload:-

  Future<List<CircularDecisionSearch>> fetchListCircularDecisions(
     String typeId,
  ) async{
    final dio = ref.watch(dioProvider);
    Map<String,dynamic> queryParams = {
      'typyId': typeId,
      'paginationDetail': {
        'pageSize': 15,
        'pageNumber': 1
      }
    };

    try{
      final response = await dio.post('/JobFlow/SearchAndListCircularAndDecisionSearch', data: queryParams);
      if(response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        state = data.map((item) => CircularDecisionSearch.fromMap(item as Map<String,dynamic>)).toList();
      } else{
        throw Exception('Failed to load CircularDecisions');
      }
    }catch (e) {
      throw Exception('Error occurred while fetching circularDecisions: $e');
    }
    return state;
  }

  // Future<CircularDecisionSearch?> getContentByObjectId({
  //   required String objectId,
  //   required int pageNumber,
  // }) async {
  //   final dio = ref.watch(dioProvider);
  //   try {
  //     final response = await dio.get(
  //       '/LetterContent/GetByObjectId',
  //       queryParameters: {
  //         'LetterAttachementObjectId': objectId,
  //         'PageNumber': pageNumber,
  //       },
  //     );

  //     // Parse the data field into a LetterContent object
  //     if (response.data != null && response.data['data'] != null) {
  //       return CircularDecisionSearch.fromMap(response.data['data']);
  //     }
  //     return null; // Return null if data is not available
  //   } catch (e) {
  //     // Handle errors and return null or rethrow as needed
  //     print('Error: $e');
  //     return null;
  //   }
  // }

}