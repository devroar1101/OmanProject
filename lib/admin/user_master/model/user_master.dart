class UserMaster {
  int id;
  String eOfficeId;
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
  

  UserMaster({
    required this.id,
    required this.eOfficeId,
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
   
  });

  /// Create a `UserMaster` instance from a map.
  factory UserMaster.fromMap(Map<String, dynamic> map) {
    return UserMaster(
      id: map['userId'] ?? 0,
      eOfficeId: map['eOfficeId'] ?? '',
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
    
      
    );
  }

  /// Convert a `UserMaster` instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eOfficeId': eOfficeId,
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
      
    };
  }

  /// Convert a List of DgMaster objects to a List of Maps with 'sno' field
  static List<Map<String, dynamic>> listToMap(List<UserMaster> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      return itemMap;
    });
  }
}
