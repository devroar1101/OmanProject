// LetterActionRepository Class
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

class LetterActionRepository {
  final Dio dio;

  LetterActionRepository(this.dio);

  Future<Response> createLetterAction(
      Map<String, dynamic> letterActionData) async {
    try {
      final response =
          await dio.post('/LetterAction/Create', data: letterActionData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateLetterAction(
      Map<String, dynamic> letterActionData) async {
    try {
      final response = await dio.put('/UpdateAction', data: letterActionData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getLetterActionById({required int letterActionId}) async {
    try {
      final response = await dio.get('/GetActionById', queryParameters: {
        'LetterActionId': letterActionId,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

// Provider for LetterActionRepository
final letterActionRepositoryProvider = Provider<LetterActionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LetterActionRepository(dio);
});
