import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';
import 'package:tenderboard/common/utilities/dio_provider.dart';


final UserMasterRepositoryProvider = 
StateNotifierProvider<UserMasterRepository, List<UserMaster>>((ref){
  return UserMasterRepository(ref);
});

class UserMasterRepository extends StateNotifier<List<UserMaster>> {
  UserMasterRepository(this.ref) : super([]);
  final Ref ref;
 

 //Add

  Future<void> addUserMaster({
    required String name,
    required String displayName,
    required int dgId,
    required int departmentId,
    required int sectionId,
    required String email,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'name' : name,
      'systemName' : displayName,
      'email' : email,
      'dgId' : dgId,
      'departmentId' : departmentId,
      'sectionId' : sectionId,
    };


    try{
      final response = await dio.post('/User/Create',data: requestBody);
      print(requestBody);

      state = [
        UserMaster(
          id: 1, 
          eOfficeId: '1' , 
          name: name, 
          systemName: name, 
          designationName: '', 
          dgName: 'test DG', 
          departmentName: 'test Depat', 
          sectionName: 'Test Section', 
          isActive: true, 
          email: email, 
          roleName: 'name', 
          objectId: 'das-da'), ...state
      ];
    } catch (e) {
      throw Exception('Error occurred while adding User: $e');
    }
  }





  /// Fetch Departments from the API
  Future<List<UserMaster>> fetchUsers({
    int pageSize = 15,
    int pageNumber = 1,
  }) async {
    final dio = ref.watch(dioProvider);
    Map<String, dynamic> requestBody = {
      'paginationDetail': {
        'pageSize': pageSize,
        'pageNumber': pageNumber,
      }
    };
    try {
      final response = await dio.post(
        '/Master/SearchAndListUser',
        data: requestBody,
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        state =  data.map((item) => UserMaster.fromMap(item as Map<String,dynamic>)).toList();
      } else {
        throw Exception('Failed to load Users');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching Users: $e');
    }
    return state;
  }

  // /// Search and filter method for Departments based on optional nameArabic and nameEnglish
  // Future<List<UserMaster>> searchAndFilter(List<UserMaster> users,
  //     {String? nameArabic, String? nameEnglish}) async {
  //   // Filter the list based on the provided nameArabic and nameEnglish filters
  //   var filteredList = users.where((UserMaster) {
  //     bool matchesArabic =
  //         nameArabic == null || department.departmentNameArabic.contains(nameArabic);
  //     bool matchesEnglish =
  //         nameEnglish == null || department.departmentNameEnglish.contains(nameEnglish);

  //     return matchesArabic && matchesEnglish;
  //   }).toList();

  //   return filteredList;
  // }
}
