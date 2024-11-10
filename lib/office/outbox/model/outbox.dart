import 'package:intl/intl.dart';
class Outbox {
  String subject;
  String location;
  String jobReferenceNumber;
  DateTime actionDate;

  Outbox({
    required this.subject,
    required this.location,
    required this.jobReferenceNumber,
    required this.actionDate,
  });

  // Convert a Map to a Outbox object
  factory Outbox.fromMap(Map<String, dynamic> map) {
    return Outbox(
      subject: map['scanDocumentSubjectName'] ?? '',
      location: map['fromExternalLocationNameEnglish'] ?? '',
      jobReferenceNumber: map['jobReferenceNumber'] ?? '',
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

  Map<String,dynamic> toMap() {
    return{
      'subject': subject,
      'location': location,
      'jobReferenceNumber': jobReferenceNumber,
      'actionDate': actionDate.toIso8601String(),
    };
  }

  // Convert a list of ListInbox objects to a list of maps, adding 'sno' field
  static List<Map<String, dynamic>> listToMap(List<Outbox> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      itemMap['sno'] = (index + 1).toString(); // Add serial number (sno) field
      return itemMap;
    });
  }
}