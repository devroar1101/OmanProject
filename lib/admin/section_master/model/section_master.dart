class Section {
  int id;
  int departmentId;
  int dgId;
  String code;
  String nameArabic;
  String nameEnglish;
  String objectId;
  // String timeStamp;

  Section({
    required this.id,
    required this.departmentId,
    required this.dgId,
    required this.code,
    required this.nameArabic,
    required this.nameEnglish,
    required this.objectId,
    //required this.timeStamp,
  });

  // Create a SectionMaster instance from a map (e.g., from JSON)
  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      id: map['id'] ?? 0,
      departmentId: map['departmentId'] ?? 0,
      dgId: map['dgId'] ?? 0,
      code: map['code'] ?? '',
      nameArabic: map['nameArabic'] ?? '',
      nameEnglish: map['nameEnglish'] ?? '',
      objectId: map['objectId'] ?? '',
      // timeStamp: map['timeStamp'] ?? '',
    );
  }

  // Convert a SectionMaster instance to a map (e.g., for JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'departmentId': departmentId,
      'dgId': dgId,
      'code': code,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      'objectId': objectId,
      //'timeStamp': timeStamp,
    };
  }

  /// Convert a List of DgMaster objects to a List of Maps with 'sno' field
  static List<Map<String, dynamic>> listToMap(List<Section> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      return itemMap;
    });
  }
}
