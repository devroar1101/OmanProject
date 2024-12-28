import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';
import 'package:tenderboard/office/letter/model/letter_attachment.dart';

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

  Future<LetterAttachment?> getAttachmentByObjectId({
    required String objectId,
  }) async {
    try {
      final response = await dio.get(
        '/LetterAttachment/GetByObjectId',
        queryParameters: {'LetterAttachementObjectId': objectId},
      );

      // Parse the data field into a LetterAttachment object
      if (response.data != null && response.data['data'] != null) {
        return LetterAttachment.fromMap(response.data['data']);
      }
      return null; // Return null if data is not available
    } catch (e) {
      // Handle errors and return null or rethrow as needed
      print('Error: $e');
      return null;
    }
  }
}

// Provider for LetterAttachmentRepository
final letterAttachmentRepositoryProvider =
    Provider<LetterAttachmentRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LetterAttachmentRepository(dio);
});
