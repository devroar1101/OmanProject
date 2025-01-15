class FolderPermission {
  int id;
  int folderId;
  int userId;

  FolderPermission({
    required this.id,
    required this.folderId,
    required this.userId,
  });

  // Convert a Map to a FolderPermission object
  factory FolderPermission.fromMap(Map<String, dynamic> map) {
    return FolderPermission(
      id: map['id'] ?? map['folderPermissionId'] ?? 0,
      folderId: map['folderId'] ?? 0,
      userId: map['userId'] ?? 0,
    );
  }

  // Convert a FolderPermission object to a Map
  Map<String, int> toMap() {
    return {
      'id': id,
      'folderId': folderId,
      'userId': userId,
    };
  }

  static List<Map<String, dynamic>> listToMap(List<FolderPermission> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      itemMap['sno'] = (index + 1).toString(); // Add sno field
      return itemMap;
    });
  }
}
