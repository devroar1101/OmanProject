import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

// Repository Class
class LetterRepository {
  final Dio dio;

  LetterRepository(this.dio);

  Future<Response> createLetter(Map<String, dynamic> letterData) async {
    try {
      final response = await dio.post('/Letter/Create', data: letterData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateLetter(Map<String, dynamic> letterData) async {
    try {
      final response = await dio.put('/Update', data: letterData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getLetterById(
      {required int letterId, required String letterObjectId}) async {
    try {
      final response = await dio.get('/GetById', queryParameters: {
        'LetterId': letterId,
        'LetterObjectId': letterObjectId,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

// Provider for LetterRepository
final letterRepositoryProvider = Provider<LetterRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LetterRepository(dio);
});
