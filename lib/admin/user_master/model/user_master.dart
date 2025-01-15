class User {
  int id;
  String eOfficeNumber;
  String name;
  String systemName;
  String designationName;
  String dgName;
  String departmentName;
  String sectionName;
  bool isActive;
  String email;
  String roleName;
  String objectId;
  int dgId;
  int departmentId;
  int sectionId;
  String loginId;

  User({
    required this.id,
    required this.eOfficeNumber,
    required this.name,
    required this.systemName,
    required this.designationName,
    required this.dgName,
    required this.departmentName,
    required this.sectionName,
    required this.isActive,
    required this.email,
    required this.roleName,
    required this.objectId,
    required this.dgId,
    required this.departmentId,
    required this.sectionId,
    required this.loginId,
  });

  /// Create a `User` instance from a map.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      eOfficeNumber: map['eOfficeNumber'] ?? '',
      name: map['name'] ?? '',
      systemName: map['systemName'] ?? '',
      designationName: map['designationItemName'] ?? '',
      dgName: map['dgName'] ?? '',
      departmentName: map['departmentName'] ?? '',
      sectionName: map['sectionName'] ?? '',
      isActive: map['isActive'] ?? false,
      email: map['email'] ?? '',
      roleName: map['roleName'] ?? '',
      objectId: map['objectId'] ?? '',
      dgId: map['dgId'] ?? 0,
      departmentId: map['departmentId'] ?? 0,
      sectionId: map['sectionId'] ?? 0,
      loginId: map['loginId'] ?? '',
    );
  }

  /// Convert a `User` instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eOfficeNumber': eOfficeNumber,
      'name': name,
      'systemName': systemName,
      'designationName': designationName,
      'dgName': dgName,
      'departmentName': departmentName,
      'sectionName': sectionName,
      'isActive': isActive,
      'email': email,
      'roleName': roleName,
      'objectId': objectId,
      'dgId': dgId,
      'departmentId': departmentId,
      'sectionId': sectionId,
    };
  }

  /// Convert a List of Dg objects to a List of Maps with 'sno' field
  static List<Map<String, dynamic>> listToMap(List<User> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      return itemMap;
    });
  }
}
