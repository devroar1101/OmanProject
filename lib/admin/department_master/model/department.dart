
class Department {
  String code;
  String departmentNameArabic;
  String departmentNameEnglish;
  String objectId;
  String dgNameEnglish;
  String dgNameArabic;

  Department({
    required this.code,
    required this.departmentNameArabic,
    required this.departmentNameEnglish,
    required this.objectId,
    required this.dgNameEnglish,
    required this.dgNameArabic,
  });

  /// Convert a Map to a Department object
  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      code: map['departmentCode'] ?? '',
      departmentNameArabic: map['departmentNameArabic'] ?? '',
      departmentNameEnglish: map['departmentNameEnglish'] ?? '',
      objectId: map['departmentObjectId'] ?? '',
      dgNameEnglish: map['dgNameEnglish'] ?? '',
      dgNameArabic: map['dgNameArabic'] ?? '',
    );
  }

  /// Convert a Department object to a Map
  Map<String, dynamic> toMap() {
    return {
      'departmentCode': code,
      'departmentNameArabic': departmentNameArabic,
      'departmentNameEnglish': departmentNameEnglish,
      'departmentObjectId': objectId,
      'dgNameEnglish': dgNameEnglish,
      'dgNameArabic': dgNameArabic,
    };
  }

  /// Convert a List of DgMaster objects to a List of Maps with 'sno' field
  static List<Map<String, dynamic>> listToMap(List<Department> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      return itemMap;
    });
  }
}
