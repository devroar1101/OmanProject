class Folder {
  final int id;
  String name;
  final int cabinetId;

  Folder({required this.id, required this.name, required this.cabinetId});

  // Convert from Map to Folder
  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'],
      cabinetId: map['cabinetId'],
    );
  }

  // Convert from Folder to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cabinetId': cabinetId,
    };
  }

  static List<Map<String, dynamic>> foldersToListOfMaps(List<Folder> folders) {
    return folders.map((folder) => folder.toMap()).toList();
  }
}
