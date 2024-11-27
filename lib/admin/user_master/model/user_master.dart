class UserMaster {
  String userId;
  String objectId;
  String name;
  String loginId;
  String roleNameEnglish;
  String roleNameArabic;
  String designationNameArabic;
  String designationNameEnglish;
  String active;
  String dgNameEnglish;
  String dgNameArabic;
  String dgObjectId;
  String departmentNameEnglish;
  String departmentNameArabic;
  String departmentObjectId;
  String authenticationNameEnglish;
  String authenticationNameArabic;
  String sectionObjectId;
  String sectionNameEnglish;
  String sectionNameArabic;
  String ldapIdentifier;
  String email;
  int officeNumber;

  UserMaster({
    required this.userId,
    required this.objectId,
    required this.name,
    required this.loginId,
    required this.roleNameEnglish,
    required this.roleNameArabic,
    required this.designationNameArabic,
    required this.designationNameEnglish,
    required this.active,
    required this.dgNameEnglish,
    required this.dgNameArabic,
    required this.dgObjectId,
    required this.departmentNameEnglish,
    required this.departmentNameArabic,
    required this.departmentObjectId,
    required this.authenticationNameEnglish,
    required this.authenticationNameArabic,
    required this.sectionObjectId,
    required this.sectionNameEnglish,
    required this.sectionNameArabic,
    required this.ldapIdentifier,
    required this.email,
    required this.officeNumber,
  });

  /// Create a `UserMaster` instance from a map.
  factory UserMaster.fromMap(Map<String, dynamic> map) {
    return UserMaster(
      userId: map['userId'] ?? '',
      objectId: map['objectId'] ?? '',
      name: map['name'] ?? '',
      loginId: map['loginId'] ?? '',
      roleNameEnglish: map['roleNameEnglish'] ?? '',
      roleNameArabic: map['roleNameArabic'] ?? '',
      designationNameArabic: map['designationNameArabic'] ?? '',
      designationNameEnglish: map['designationNameEnglish'] ?? '',
      active: map['active'] ?? '',
      dgNameEnglish: map['dgNameEnglish'] ?? '',
      dgNameArabic: map['dgNameArabic'] ?? '',
      dgObjectId: map['dgObjectId'] ?? '',
      departmentNameEnglish: map['departmentNameEnglish'] ?? '',
      departmentNameArabic: map['departmentNameArabic'] ?? '',
      departmentObjectId: map['departmentObjectId'] ?? '',
      authenticationNameEnglish: map['authenticationNameEnglish'] ?? '',
      authenticationNameArabic: map['authenticationNameArabic'] ?? '',
      sectionObjectId: map['sectionObjectId'] ?? '',
      sectionNameEnglish: map['sectionNameEnglish'] ?? '',
      sectionNameArabic: map['sectionNameArabic'] ?? '',
      ldapIdentifier: map['ldapIdentifier'] ?? '',
      email: map['email'] ?? '',
      officeNumber: map['officeNumber'] ?? 0,
    );
  }

  /// Convert a `UserMaster` instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'objectId': objectId,
      'name': name,
      'loginId': loginId,
      'roleNameEnglish': roleNameEnglish,
      'roleNameArabic': roleNameArabic,
      'designationNameArabic': designationNameArabic,
      'designationNameEnglish': designationNameEnglish,
      'active': active,
      'dgNameEnglish': dgNameEnglish,
      'dgNameArabic': dgNameArabic,
      'dgObjectId': dgObjectId,
      'departmentNameEnglish': departmentNameEnglish,
      'departmentNameArabic': departmentNameArabic,
      'departmentObjectId': departmentObjectId,
      'authenticationNameEnglish': authenticationNameEnglish,
      'authenticationNameArabic': authenticationNameArabic,
      'sectionObjectId': sectionObjectId,
      'sectionNameEnglish': sectionNameEnglish,
      'sectionNameArabic': sectionNameArabic,
      'ldapIdentifier': ldapIdentifier,
      'email': email,
      'officeNumber': officeNumber,
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
