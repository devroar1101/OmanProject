class Folder {
  int id;
  int cabinetId;
  String objectId;
  int code;
  String nameArabic;
  String nameEnglish;

  Folder({
    required this.id,
    required this.cabinetId,
    required this.objectId,
    required this.code,
    required this.nameArabic,
    required this.nameEnglish,
  });

  // Convert a Map to a Folder object
  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['folderId'],
      cabinetId: map['cabinetId'],
      objectId: map['objectId'] ?? '', // Defaulting to empty string if null
      code: map['folderId'] ?? '', // Defaulting to empty string if null
      nameArabic: map['nameEnglish'] ?? '',
      nameEnglish: map['nameArabic'] ?? '',
    );
  }

  // Convert a Folder object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cabinetId': cabinetId,
      'objectId': objectId,
      //'FolderCode': code,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
    };
  }

  static List<Map<String, dynamic>> listToMap(List<Folder> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      itemMap['sno'] = (index + 1).toString(); // Add sno field
      return itemMap;
    });
  }
}
