import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

// Repository Class
class CircularDecisionRepository {
  final Dio dio;

  CircularDecisionRepository(this.dio);

  Future<Response> createCircularDecision(Map<String, dynamic> circularDecisionData) async {
    try {
      print('body:- $circularDecisionData');
      final response = await dio.post('/CircularAndDecision/Create', data: circularDecisionData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Future<Response> updateLetter(Map<String, dynamic> circularDecisionData) async {
  //   try {
  //     final response = await dio.put('/Update', data: circularDecisionData);
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<Response> getById(
      {required int id, String? objectId}) async {
    try {
      final response = await dio.get('/CircularAndDecision/GetById', queryParameters: {
        'Id': id,
        'ObjectId': objectId,
      });
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }
}

// Provider for CircularDecisionRepository
final circularDecisionRepositoryProvider = Provider<CircularDecisionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CircularDecisionRepository(dio);
});
