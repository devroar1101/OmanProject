class ExternalLocation {
  int id;
  String nameArabic;
  String nameEnglish;
  String type;
  String isNew;
  bool isDeleted;
  String? objectId;

  ExternalLocation({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.type,
    required this.isNew,
    required this.isDeleted,
    this.objectId,
  });

  // Factory constructor to create an instance from a Map
  factory ExternalLocation.fromMap(Map<String, dynamic> map) {
    return ExternalLocation(
      id: map['id'] ?? 0,
      nameArabic: map['nameArabic'] ?? '',
      nameEnglish: map['nameEnglish'] ?? '',
      type: map['type'] ?? '',
      isNew: map['isNew'] ?? '',
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
      'type': type,
      'isNew': isNew,
      'isDeleted': isDeleted,
    };
  }

  /// Convert a List of DgMaster objects to a List of Maps with 'sno' field
  static List<Map<String, dynamic>> listToMap(List<ExternalLocation> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      return itemMap;
    });
  }
}
