class ExternalLocationMaster {
  int locationCode;
  String locationNameArabic;
  String locationNameEnglish;
  String externalLocationObjectId;
  String typeNameEnglish;
  String typeNameArabic;
  String typeObjectId;
  String active;
  String isYes;

  ExternalLocationMaster({
    required this.locationCode,
    required this.locationNameArabic,
    required this.locationNameEnglish,
    required this.externalLocationObjectId,
    required this.typeNameEnglish,
    required this.typeNameArabic,
    required this.typeObjectId,
    required this.active,
    required this.isYes,
  });

  // Factory constructor to create an instance from a Map
  factory ExternalLocationMaster.fromMap(Map<String, dynamic> map) {
    return ExternalLocationMaster(
      locationNameArabic: map['locationNameArabic'] ?? 0,
      locationCode: map['locationCode'] ?? '',
      locationNameEnglish: map['locationNameEnglish'] ?? '',
      externalLocationObjectId: map['externalLocationObjectId'] ?? '',
      typeNameEnglish: map['typeNameEnglish'] ?? '',
      typeNameArabic: map['typeNameArabic'] ?? '',
      typeObjectId: map['typeObjectId'] ?? '',
      active: map['active'] ?? '',
      isYes: map['isYes'] ?? '',
    );
  }

  // Method to convert an instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'locationCode': locationCode,
      'locationNameArabic': locationNameArabic,
      'locationNameEnglish': locationNameEnglish,
      'externalLocationObjectId': externalLocationObjectId,
      'typeNameEnglish': typeNameEnglish,
      'typeNameArabic': typeNameArabic,
      'typeObjectId': typeObjectId,
      'active': active,
      'isYes': isYes,
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
