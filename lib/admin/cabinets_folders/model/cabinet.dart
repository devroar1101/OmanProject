class Cabinet {
  int id;
  String objectId;
  String code;
  String nameArabic;
  String nameEnglish;

  Cabinet({
    required this.id,
    required this.objectId,
    required this.code,
    required this.nameArabic,
    required this.nameEnglish,
  });

  // Convert a Map to a Cabinet object
  factory Cabinet.fromMap(Map<String, dynamic> map) {
    return Cabinet(
      id: map['cabinetId'],
      objectId: map['objectId'] ?? '', // Defaulting to empty string if null
      code: map['code'] ?? '', // Defaulting to empty string if null
      nameArabic: map['nameEnglish'] ?? '',
      nameEnglish: map['nameArabic'] ?? '',
    );
  }

  // Convert a Cabinet object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'objectId': objectId,
      'CabinetCode': code,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
    };
  }

  static List<Map<String, dynamic>> listToMap(List<Cabinet> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      itemMap['sno'] = (index + 1).toString(); // Add sno field
      return itemMap;
    });
  }
}
