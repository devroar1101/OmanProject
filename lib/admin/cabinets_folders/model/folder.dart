class Folder {
  int id;
  int cabinetId;
  String objectId;
  String code;
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
      id: map['cabinetFolderId'],
      cabinetId: map['cabinetId'],
      objectId: map['objectId'] ?? '', // Defaulting to empty string if null
      code: map['cabinetFolderId'] ?? '', // Defaulting to empty string if null
      nameArabic: map['cabinetFolderNameEnglish'] ?? '',
      nameEnglish: map['cabinetFolderNameArabic'] ?? '',
    );
  }

  // Convert a Folder object to a Map
  Map<String, dynamic> toMap() {
    return {
      'cabinetFolderId': id,
      'cabinetId': cabinetId,
      'objectId': objectId,
      //'FolderCode': code,
      'cabinetFolderNameArabic': nameArabic,
      'cabinetFolderNameEnglish': nameEnglish,
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
