import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';
import 'package:tenderboard/office/createcircular_decision/model/circular_decision_content.dart';
import 'package:tenderboard/office/letter/model/letter_content.dart';

class CircularDecisionContentRepository {
  final Dio dio;

  CircularDecisionContentRepository(this.dio);

  Future<Response> createContent(Map<String, dynamic> contentData) async {
    try {
      final response =
          await dio.post('/CircularAndDecisionContent/Create', data: contentData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateContent(Map<String, dynamic> contentData) async {
    try {
      final response = await dio.put('/CircularAndDecisionContent/Update', data: contentData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getContentById({required int contentId}) async {
    try {
      final response = await dio.get('/CircularAndDecisionContent/GetById', queryParameters: {
        'Id': contentId,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<CircularDecisionContent?> getContentByObjectId({
    required String objectId,
    required int pageNumber,
  }) async {
    try {
      final response = await dio.get(
        '/CircularAndDecisionContent/GetByObjectId',
        queryParameters: {
          'ObjectId': objectId,
          'PageNumber': pageNumber,
        },
      );

      // Parse the data field into a CircularDecisionContent object
      if (response.data != null && response.data['data'] != null) {
        return CircularDecisionContent.fromMap(response.data['data']);
      }
      return null; // Return null if data is not available
    } catch (e) {
      // Handle errors and return null or rethrow as needed
      print('Error: $e');
      return null;
    }
  }
}

// Provider for CircularDecisionContentRepository
final circularDecisionContentRepositoryProvider =
    Provider<CircularDecisionContentRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CircularDecisionContentRepository(dio);
});
