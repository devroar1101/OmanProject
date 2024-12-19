// LetterContentRepository Class
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

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
}

// Provider for LetterContentRepository
final letterContentRepositoryProvider =
    Provider<LetterContentRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LetterContentRepository(dio);
});
