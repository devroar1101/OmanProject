class Department {
  String code;
  String nameArabic;
  String nameEnglish;
  String dgNameEnglish;
  String objectId;
  int id;
  int dgId;

  Department({
    required this.code,
    required this.nameArabic,
    required this.nameEnglish,
    required this.dgNameEnglish,
    required this.objectId,
    required this.id,
    required this.dgId,
  });

  /// Convert a Map to a Department object
  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      code: map['code'] ?? '',
      nameArabic: map['departmentNameArabic'] ?? '',
      nameEnglish: map['departmentNameEnglish'] ?? '',
      dgNameEnglish: map['dgNameEnglish'] ?? '',
      objectId: map['departmentObjectId'] ?? '',
      id: map['departmentId'] ?? 0,
      dgId: map['dgId'] ?? 0,
    );
  }

  /// Convert a Department object to a Map
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      'dgNameEnglish': dgNameEnglish,
      'departmentObjectId': objectId,
      'dgId': dgId,
      'id': id,
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
