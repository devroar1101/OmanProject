class LetterSubject {
  String subject;
  String tenderNumber;
  String objectId;
  int id;

  LetterSubject({
    required this.subject,
    required this.tenderNumber,
    required this.objectId,
    required this.id,
  });

  // fromMap: Converts a Map to a LetterSubject instance
  factory LetterSubject.fromMap(Map<String, dynamic> map) {
    return LetterSubject(
      subject: map['name'] ?? map['subject'] ?? '',
      tenderNumber: map['tenderNumber'] ?? '',
      objectId: map['objectId'] ?? '',
      id: map['id'] ?? 0,
    );
  }

  // toMap: Converts a LetterSubject instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'tenderNumber': tenderNumber,
      'objectId': objectId,
      'id': id,
    };
  }

  /// Convert a List of DgMaster objects to a List of Maps with 'sno' field
  static List<Map<String, dynamic>> listToMap(List<LetterSubject> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      return itemMap;
    });
  }
}
