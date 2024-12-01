class LetterSubjecct {
  String subjectNameEnglish;
  String tenderNumber;
  String objectId;

  LetterSubjecct({
    required this.subjectNameEnglish,
    required this.tenderNumber,
    required this.objectId,
  });

  // fromMap: Converts a Map to a LetterSubjecct instance
  factory LetterSubjecct.fromMap(Map<String, dynamic> map) {
    return LetterSubjecct(
      subjectNameEnglish: map['subjectNameEnglish'] ?? '',
      tenderNumber: map['tenderNumber'] ?? '',
      objectId: map['subjectObjectId'] ?? '',
    );
  }

  // toMap: Converts a LetterSubjecct instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'subjectNameEnglish': subjectNameEnglish,
      'tenderNumber': tenderNumber,
      'objectId': objectId,
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
