import 'package:tenderboard/admin/listmasteritem/model/listmasteritem.dart';

class ListMaster {
  String objectId;

  String nameArabic;
  String nameEnglish;
  List<ListMasterItem> items;

  ListMaster(
      {required this.objectId,
      required this.nameArabic,
      required this.nameEnglish,
      required this.items});
}
