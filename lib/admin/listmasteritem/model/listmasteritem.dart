class ListMasterItem {
  String objectId;
  int listMasterId;
  int id;
  String code;
  String nameArabic;
  String nameEnglish;
  //String systemField;

  ListMasterItem({
    required this.objectId,
    required this.listMasterId,
    required this.id,
    required this.code,
    required this.nameArabic,
    required this.nameEnglish,
    //required this.systemField,
  });

  // Convert a Map to a ListMasterItem instance
  factory ListMasterItem.fromMap(Map<String, dynamic> map) {
    return ListMasterItem(
      objectId: map['objectId'] ?? '',
      listMasterId: map['listMasterId'] ?? 0,
      id: map['id'] ?? 0,
      code: map['code'] ?? '',
      nameArabic: map['nameArabic'] ?? '',
      nameEnglish: map['nameEnglish'] ?? '',
      //systemField: map['systemField'] ?? 'false',
    );
  }

  // Convert a ListMasterItem instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'objectId': objectId,
      'id': id,
      'code': code,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      //'systemField': systemField,
    };
  }

  // Convert list of ListMasterItems to a list of maps, adding 'sno'
  static List<Map<String, dynamic>> listToMap(List<ListMasterItem> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      itemMap['sno'] = (index + 1).toString(); // Add sno field
      return itemMap;
    });
  }
}
