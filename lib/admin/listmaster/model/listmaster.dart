import 'package:tenderboard/admin/listmasteritem/model/listmasteritem.dart';

class ListMaster {
  String objectId;
  String nameArabic;
  String nameEnglish;
  List<ListMasterItem> items;

  ListMaster({
    required this.objectId,
    required this.nameArabic,
    required this.nameEnglish,
    required this.items,
  });

  // Convert a Map to a ListMaster object
  factory ListMaster.fromMap(Map<String, dynamic> map) {
    return ListMaster(
      objectId: map['objectId'] ?? '', // Defaulting to empty string if null
      nameArabic: map['nameArabic'] ?? '',
      nameEnglish: map['nameEnglish'] ?? '',
      // Assuming that 'items' is a list of maps that needs to be converted to ListMasterItem
      items: List<ListMasterItem>.from(
        map['items']?.map((item) => ListMasterItem.fromMap(item)) ?? [],
      ),
    );
  }

  // Convert a ListMaster object to a Map
  Map<String, dynamic> toMap() {
    return {
      'objectId': objectId,
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
