class SectionMaster {
  int sectionId;
  int departmentId;
  int dgId;
  String code;
  String sectionNameArabic;
  String sectionNameEnglish;
  String objectId;
  String timeStamp;

  SectionMaster({
    required this.sectionId,
    required this.departmentId,
    required this.dgId,
    required this.code,
    required this.sectionNameArabic,
    required this.sectionNameEnglish,
    required this.objectId,
    required this.timeStamp,
  });

  // Create a SectionMaster instance from a map (e.g., from JSON)
  factory SectionMaster.fromMap(Map<String, dynamic> map) {
    return SectionMaster(
      sectionId: map['sectionId'] ?? 0,
      departmentId: map['departmentId'] ?? 0,
      dgId: map['dgId'] ?? 0,
      code: map['code'] ?? '',
      sectionNameArabic: map['sectionNameArabic'] ?? '',
      sectionNameEnglish: map['sectionNameEnglish'] ?? '',
      objectId: map['objectId'] ?? '',
      timeStamp: map['timeStamp'] ?? '',
    );
  }

  // Convert a SectionMaster instance to a map (e.g., for JSON)
  Map<String, dynamic> toMap() {
    return {
      'sectionId': sectionId,
      'departmentId': departmentId,
      'dgId': dgId,
      'code': code,
      'sectionNameArabic': sectionNameArabic,
      'sectionNameEnglish': sectionNameEnglish,
      'objectId': objectId,
      'timeStamp': timeStamp,
    };
  }

  /// Convert a List of DgMaster objects to a List of Maps with 'sno' field
  static List<Map<String, dynamic>> listToMap(List<SectionMaster> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      return itemMap;
    });
  }
}
