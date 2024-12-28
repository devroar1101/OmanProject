import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';
import 'package:tenderboard/office/letter/model/letter_content.dart';

class LetterContentRepository {
  final Dio dio;

  LetterContentRepository(this.dio);

  Future<Response> createContent(Map<String, dynamic> contentData) async {
    try {
      final response =
          await dio.post('/LetterContent/Create', data: contentData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateContent(Map<String, dynamic> contentData) async {
    try {
      final response = await dio.put('/UpdateContent', data: contentData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getContentById({required int contentId}) async {
    try {
      final response = await dio.get('/GetContentById', queryParameters: {
        'LetterContentId': contentId,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<LetterContent?> getContentByObjectId({
    required String objectId,
    required int pageNumber,
  }) async {
    try {
      final response = await dio.get(
        '/LetterContent/GetByObjectId',
        queryParameters: {
          'LetterAttachementObjectId': objectId,
          'PageNumber': pageNumber,
        },
      );

      // Parse the data field into a LetterContent object
      if (response.data != null && response.data['data'] != null) {
        return LetterContent.fromMap(response.data['data']);
      }
      return null; // Return null if data is not available
    } catch (e) {
      // Handle errors and return null or rethrow as needed
      print('Error: $e');
      return null;
    }
  }
}

// Provider for LetterContentRepository
final letterContentRepositoryProvider =
    Provider<LetterContentRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LetterContentRepository(dio);
});
