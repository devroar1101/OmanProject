
class Department {
  String departmentCode;
  String departmentNameArabic;
  String departmentNameEnglish;
  String departmentObjectId;
  String dgNameEnglish;
  String dgNameArabic;

  Department({
    required this.departmentCode,
    required this.departmentNameArabic,
    required this.departmentNameEnglish,
    required this.departmentObjectId,
    required this.dgNameEnglish,
    required this.dgNameArabic,
  });

  /// Convert a Map to a Department object
  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      departmentCode: map['departmentCode'] ?? '',
      departmentNameArabic: map['departmentNameArabic'] ?? '',
      departmentNameEnglish: map['departmentNameEnglish'] ?? '',
      departmentObjectId: map['departmentObjectId'] ?? '',
      dgNameEnglish: map['dgNameEnglish'] ?? '',
      dgNameArabic: map['dgNameArabic'] ?? '',
    );
  }

  /// Convert a Department object to a Map
  Map<String, dynamic> toMap() {
    return {
      'departmentCode': departmentCode,
      'departmentNameArabic': departmentNameArabic,
      'departmentNameEnglish': departmentNameEnglish,
      'departmentObjectId': departmentObjectId,
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
