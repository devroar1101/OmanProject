import 'package:dio/dio.dart';
import 'package:tenderboard/office/scan_document_summary/model/scan_document_summary.dart';

class ScanSummaryRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://eofficetbdevdal.cloutics.net/api/JobWorkflowQueries',
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
    },
  ));

  Future<ScanDocumentSummary?> fetchSingleScanSummaryItem({
    required String scanDocumentObjectId,
  }) async {
    Map<String, dynamic> requestBody = {
      'scanDocumentObjectId': scanDocumentObjectId,
    };

    try {
      final response = await _dio.post(
        '/ScanAndIndexDocument',
        data: requestBody,
      );
      print('Response status code: ${response.statusCode}');

      // Check if the response is successful
      if (response.statusCode == 200) {
       if (response.data != null) {
  print("1113${response.data}");
  // Assuming response.data is a list
  List<dynamic> dataList = response.data as List<dynamic>;
  
  // Fetch the first item from the list or a specific item by condition
  if (dataList.isNotEmpty) {
    Map<String, dynamic> data = dataList[0] as Map<String, dynamic>; // Get the first item

    // Alternatively, find a specific item by condition
    // Map<String, dynamic>? data = dataList.firstWhere(
    //   (item) => item['scanDocumentObjectId'] == 'desired_id',
    //   orElse: () => null,
    // );

    return ScanDocumentSummary.fromMap(data);
  } else {
    throw Exception("The response list is empty.");
  }
} else {
          print('No data found for the provided scanDocumentObjectId');
          return null;
        }
      } else {
        throw Exception('Failed to load the ScanIndex item');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error occurred while fetching the ScanIndex item: $e');
    }
  }
}
