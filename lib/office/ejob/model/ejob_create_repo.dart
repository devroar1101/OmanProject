import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

class EjobRepository{
  final Dio dio;

  EjobRepository(this.dio);

  Future<Response> createEjob(Map<String, dynamic> ejobData) async{
    try{
      final response = await dio.post('/Ejob/Create', data: ejobData);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}

final ejobRepositoryProvider = Provider<EjobRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return EjobRepository(dio);
});