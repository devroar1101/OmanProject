class Dg {
  int id;
  String nameArabic;
  String nameEnglish;
  String code;
  //String objectId;

  Dg({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.code,
    //required this.objectId,
  });

  /// Convert a Map to a Dg object
  factory Dg.fromMap(Map<String, dynamic> map) {
    return Dg(
      id: map['id'] ?? 0, // Default to empty string if null
      nameArabic: map['nameArabic'] ?? '', // Default to empty string if null
      nameEnglish: map['nameEnglish'] ?? '',
      code: map['code'] ?? '',
      //objectId: map['objectId'] ?? '',
    );
  }

  /// Convert a Dg object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      'code': code,
      //'objectId': objectId,
    };
  }

  /// Convert a List of Dg objects to a List of Maps with 'sno' field
  static List<Map<String, dynamic>> listToMap(List<Dg> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      return itemMap;
    });
  }
}
