// LetterAttachmentRepository Class
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

class LetterAttachmentRepository {
  final Dio dio;

  LetterAttachmentRepository(this.dio);

  Future<Response> createAttachment(Map<String, dynamic> attachmentData) async {
    try {
      final response =
          await dio.post('/LetterAttachment/Create', data: attachmentData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateAttachment(Map<String, dynamic> attachmentData) async {
    try {
      final response = await dio.put('/UpdateAttachment', data: attachmentData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAttachmentById({required int attachmentId}) async {
    try {
      final response = await dio.get('/GetAttachmentById', queryParameters: {
        'LetterAttachmentId': attachmentId,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

// Provider for LetterAttachmentRepository
final letterAttachmentRepositoryProvider =
    Provider<LetterAttachmentRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LetterAttachmentRepository(dio);
});
