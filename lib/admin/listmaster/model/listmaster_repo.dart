import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/listmaster/model/listmaster.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';

final listMasterRepositoryProvider =
    Provider((ref) => ListMasterRepository(ref));

class ListMasterRepository {
  final Ref ref;

  ListMasterRepository(this.ref);

  /// Fetch ListMasters from the API
  Future<List<ListMaster>> fetchListMasters() async {
    final dio = ref.watch(dioProvider);

    try {
      final response = await dio.get('/ListMaster/LookUpListMaster');

      if (response.statusCode == 200) {
        // Parse the response data into a list of ListMaster
        List data = response.data as List;
        return data.map((item) => ListMaster.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load ListMasters: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching ListMasters: $e');
    }
  }

  /// Search and filter ListMasters by Arabic and English names
  Future<List<ListMaster>> searchAndFilter(List<ListMaster> listMasters,
      {String? nameArabic, String? nameEnglish}) async {
    // Filter the list based on the provided nameArabic and nameEnglish filters
    var filteredList = listMasters.where((listMaster) {
      final matchesArabic =
          nameArabic == null || listMaster.nameArabic.contains(nameArabic);
      final matchesEnglish =
          nameEnglish == null || listMaster.nameEnglish.contains(nameEnglish);

      return matchesArabic && matchesEnglish;
    }).toList();

    return filteredList;
  }
}
