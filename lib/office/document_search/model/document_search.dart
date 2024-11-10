import 'package:intl/intl.dart';

class DocumentSearch {
  String subject;
  String location;
  String jobReferenceNumber;
  DateTime recievedDate;
  String tenderNumber;
  DateTime dateOntheLetter;

  DocumentSearch({
    required this.subject,
    required this.location,
    required this.jobReferenceNumber,
    required this.recievedDate,
    required this.tenderNumber,
    required this.dateOntheLetter,
  });


  // Convert a Map to a ListInbox object
  factory DocumentSearch.fromMap(Map<String, dynamic>map) {
    return DocumentSearch(
      subject: map['scanDocumentLetterSubject'] ?? '',
      location: map['fromExternalLocationName'] ?? '',
      jobReferenceNumber: map['referenceNumber'] ?? '',
      recievedDate: parseDate(map['recievedDate']),
      tenderNumber: map['tenderNumber'] ?? '',
      dateOntheLetter: parseDate(map['dateOntheLetter']),
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
      'recievedDate': recievedDate.toIso8601String(),
      'tenderNumber': tenderNumber,
      'dateOntheLetter': dateOntheLetter.toIso8601String(),
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