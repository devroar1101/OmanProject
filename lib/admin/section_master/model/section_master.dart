class SectionMaster {
  String sectionCode;
  String sectionNameArabic;
  String sectionNameEnglish;
  String departmentNameEnglish;
  String departmentNameArabic;
  String sectionObjectId;
  int sectionId;

  SectionMaster({
    required this.sectionCode,
    required this.sectionNameArabic,
    required this.sectionNameEnglish,
    required this.departmentNameEnglish,
    required this.departmentNameArabic,
    required this.sectionObjectId,
    required this.sectionId,
  });

  // Create a SectionMaster instance from a map (e.g., from JSON)
  factory SectionMaster.fromMap(Map<String, dynamic> map) {
    return SectionMaster(
      sectionCode: map['sectionCode'] ?? '',
      sectionNameArabic: map['sectionNameArabic'] ?? '',
      sectionNameEnglish: map['sectionNameEnglish'] ?? '',
      departmentNameEnglish: map['departmentNameEnglish'] ?? '',
      departmentNameArabic: map['departmentNameArabic'] ?? '',
      sectionObjectId: map['sectionObjectId'] ?? '',
      sectionId: map['sectionId'] ?? '',
    );
  }

  // Convert a SectionMaster instance to a map (e.g., for JSON)
  Map<String, dynamic> toMap() {
    return {
      'sectionCode': sectionCode,
      'sectionNameArabic': sectionNameArabic,
      'sectionNameEnglish': sectionNameEnglish,
      'departmentNameEnglish': departmentNameEnglish,
      'departmentNameArabic': departmentNameArabic,
      'sectionObjectId': sectionObjectId,
      'sectionId': sectionId,
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
