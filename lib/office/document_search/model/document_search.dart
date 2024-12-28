import 'package:intl/intl.dart';

class DocumentSearch {
  String subject;
  String location;
  String jobReferenceNumber;
  String letterNumber;
  String direction;
  String objectId;

  DocumentSearch({
    required this.subject,
    required this.location,
    required this.jobReferenceNumber,
    required this.letterNumber,
    required this.direction,
    required this.objectId,
  });


  // Convert a Map to a ListInbox object
  factory DocumentSearch.fromMap(Map<String, dynamic>map) {
    return DocumentSearch(
      subject: map['subject'] ?? '',
      location: map['externallocation'] ?? '',
      jobReferenceNumber: map['referenecNumber'] ?? '',
      letterNumber: map['letterNumber'] ?? '',
      direction: map['direction'] ?? '',
      objectId: map['objectId'] ?? '',
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

  Map<String,dynamic> toMap(){
    return{
      'subject': subject,
      'location': location,
      'jobReferenceNumber': jobReferenceNumber,
      'letterNumber' : letterNumber,
      'direction' : direction,
      'objectId': objectId,
    };
  }

  // Convert a list of DocumentSearch objects to a list of maps, adding 'sno' field
  static List<Map<String, dynamic>> listToMap(List<DocumentSearch> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      itemMap['sno'] = (index + 1).toString(); // Add serial number (sno) field
      return itemMap;
    });
  }

}