import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';
import 'package:tenderboard/office/createcircular_decision/model/circular_decision_attachment.dart';
import 'package:tenderboard/office/letter/model/letter_attachment.dart';

class CircularDecisionAttachmentRepository {
  final Dio dio;

  CircularDecisionAttachmentRepository(this.dio);

  Future<Response> createAttachment(Map<String, dynamic> attachmentData) async {
    try {
      final response =
          await dio.post('/CircularAndDecisionAttachment/Create', data: attachmentData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateAttachment(Map<String, dynamic> attachmentData) async {
    try {
      final response = await dio.put('/CircularAndDecisionAttachment/Update', data: attachmentData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAttachmentById({required int attachmentId}) async {
    try {
      final response = await dio.get('/CircularAndDecisionAttachment/GetById', queryParameters: {
        'CircularDecisionAttachmentId': attachmentId,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<CircularDecisionAttachment?> getAttachmentByObjectId({
    required String objectId,
  }) async {
    try {
      final response = await dio.get(
        '/CircularAndDecisionAttachment/GetById',
        queryParameters: {'LetterAttachementObjectId': objectId},
      );

      // Parse the data field into a CircularDecisionAttachment object
      if (response.data != null && response.data['data'] != null) {
        return CircularDecisionAttachment.fromMap(response.data['data']);
      }
      return null; // Return null if data is not available
    } catch (e) {
      // Handle errors and return null or rethrow as needed
      print('Error: $e');
      return null;
    }
  }
}

// Provider for CircularDecisionAttachmentRepository
final circularDecisionAttachmentRepositoryProvider =
    Provider<CircularDecisionAttachmentRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CircularDecisionAttachmentRepository(dio);
});
