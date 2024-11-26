// Models

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});
}

class FolderPermission {
  final int id;
  final int cabinetId;
  final int folderId;
  final int userId;

  FolderPermission({
    required this.id,
    required this.cabinetId,
    required this.folderId,
    required this.userId,
  });
}
