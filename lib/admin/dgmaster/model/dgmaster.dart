class DgMaster {
  String nameArabic;
  String nameEnglish;
  String code;
  String objectId;

  DgMaster({
    required this.nameArabic,
    required this.nameEnglish,
    required this.code,
    required this.objectId,
  });

  /// Convert a Map to a DgMaster object
  factory DgMaster.fromMap(Map<String, dynamic> map) {
    return DgMaster(
      nameArabic: map['nameArabic'] ?? '', // Default to empty string if null
      nameEnglish: map['nameEnglish'] ?? '',
      code: map['code'] ?? '',
      objectId: map['dgObjectId'] ?? '',
    );
  }

  /// Convert a DgMaster object to a Map
  Map<String, dynamic> toMap() {
    return {
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      'code': code,
      'objectId': objectId,
    };
  }

  /// Convert a List of DgMaster objects to a List of Maps with 'sno' field
  static List<Map<String, dynamic>> listToMap(List<DgMaster> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      return itemMap;
    });
  }
}
