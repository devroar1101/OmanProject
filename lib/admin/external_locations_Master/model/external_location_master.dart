class ExternalLocationMaster {
  int id;
  String nameArabic;
  String nameEnglish;
  int typeId;
  bool isNew;
  bool isDeleted;
  String objectId;

  ExternalLocationMaster({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.typeId,
    required this.isNew,
    required this.isDeleted,
    required this.objectId,
  });

  // Factory constructor to create an instance from a Map
  factory ExternalLocationMaster.fromMap(Map<String, dynamic> map) {
    return ExternalLocationMaster(
      id: map['externalLocationId'] ?? 0,
      nameArabic: map['nameArabic'] ?? '',
      nameEnglish: map['nameEnglish'] ?? '',
      typeId: map['typeId'] ?? 0,
      isNew: map['isNew'] ?? false,
      isDeleted: map['isDeleted'] ?? false,
      objectId: map['objectId'] ?? '',
    );
  }

  // Method to convert an instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      'objectId': objectId,
      'typeId': typeId,
      'isNew': isNew,
      'isDeleted': isDeleted,
    };
  }

  /// Convert a List of DgMaster objects to a List of Maps with 'sno' field
  static List<Map<String, dynamic>> listToMap(List<ExternalLocationMaster> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      return itemMap;
    });
  }
}
