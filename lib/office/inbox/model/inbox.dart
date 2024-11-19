import 'package:intl/intl.dart';

class ListInbox {
  String subject;
  String location;
  String jobReferenceNumber;
  String fromUserName;
  String scanDocumentObjectId;
  String eJobObjectId;
  DateTime actionDate;

  ListInbox({
    required this.subject,
    required this.location,
    required this.jobReferenceNumber,
    required this.fromUserName,
    required this.scanDocumentObjectId,
    required this.eJobObjectId,
    required this.actionDate,
  });

  // Convert a Map to a ListInbox object
  factory ListInbox.fromMap(Map<String, dynamic> map) {
    return ListInbox(
      subject: map['scanDocumentSubjectName'] ?? '',
      location: map['fromExternalLocationNameEnglish'] ?? '',
      jobReferenceNumber: map['jobReferenceNumber'] ?? '',
      scanDocumentObjectId: map['scanDocumentObjectId'] ?? '',
      eJobObjectId: map['eJobObjectId'] ?? '',
      fromUserName: map['fromUserName'] ?? '',
      actionDate: parseDate(map['actionDate']),
    );
  }

  // Method to parse date
  static DateTime parseDate(String? dateStr) {
    if (dateStr == null) return DateTime.now();
    try {
      return DateFormat("MM/dd/yyyy HH:mm:ss").parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'location': location,
      'jobReferenceNumber': jobReferenceNumber,
      'fromUserName': fromUserName,
      'actionDate': actionDate.toIso8601String(),
    };
  }


// Convert a list of ListInbox objects to a list of maps, adding 'sno' field
  static List<Map<String, dynamic>> listToMap(List<ListInbox> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      itemMap['sno'] = (index + 1).toString(); // Add serial number (sno) field
      return itemMap;
    });
  }

}





  