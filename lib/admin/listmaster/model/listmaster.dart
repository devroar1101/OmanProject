import 'package:tenderboard/admin/listmasteritem/model/listmasteritem.dart';

class ListMaster {
  int id;
  String objectId;
  String listMasterCode;
  String nameArabic;
  String nameEnglish;
  List<ListMasterItem> items;

  ListMaster({
    required this.id,
    required this.objectId,
    required this.listMasterCode,
    required this.nameArabic,
    required this.nameEnglish,
    required this.items,
  });

  // Convert a Map to a ListMaster object
  factory ListMaster.fromMap(Map<String, dynamic> map) {
    return ListMaster(
      id: map['listMasterId'],
      objectId: map['objectId'] ?? '', // Defaulting to empty string if null
      listMasterCode: map['code'] ?? '' , // Defaulting to empty string if null
      nameArabic: map['listMasterNameArabic'] ?? '',
      nameEnglish: map['listMasterNameEnglish'] ?? '',
      // Assuming that 'items' is a list of maps that needs to be converted to ListMasterItem
      items: List<ListMasterItem>.from(
        map['items']?.map((item) => ListMasterItem.fromMap(item)) ?? [],
      ),
    );
  }

  // Convert a ListMaster object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'objectId': objectId,
      'listMasterCode': listMasterCode,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      // Convert the ListMaster objects back to maps
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  static List<Map<String, dynamic>> listToMap(List<ListMaster> items) {
    return List<Map<String, dynamic>>.generate(items.length, (index) {
      Map<String, dynamic> itemMap = items[index].toMap();
      itemMap['sno'] = (index + 1).toString(); // Add sno field
      return itemMap;
    });
  }
}
