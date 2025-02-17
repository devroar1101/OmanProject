class LetterSubjecct {
  String subject;
  String tenderNumber;
  String objectId;
  int id;

  LetterSubjecct({
    required this.subject,
    required this.tenderNumber,
    required this.objectId,
    required this.id,
  });

  // fromMap: Converts a Map to a LetterSubjecct instance
  factory LetterSubjecct.fromMap(Map<String, dynamic> map) {
    return LetterSubjecct(
      subject: map['name'] ?? '',
      tenderNumber: map['tenderNumber'] ?? '',
      objectId: map['objectId'] ?? '',
      id: map['id'] ?? 0,
    );
  }

  // toMap: Converts a LetterSubjecct instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'tenderNumber': tenderNumber,
      'objectId': objectId,
      'id': id,
    };
  }

  /// Convert a List of DgMaster objects to a List of Maps with 'sno' field
  static List<Map<String, dynamic>> listToMap(List<LetterSubjecct> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      return itemMap;
    });
  }
}
