import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/listmaster/screens/add_listmaster.dart';
import 'package:tenderboard/admin/listmasteritem/screens/listmasteritem_home.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/admin/listmaster/model/listmaster.dart';
import 'package:tenderboard/admin/listmaster/model/listmaster_repo.dart';
import 'package:tenderboard/admin/listmaster/screens/listmaster_form.dart';

class ListMasterHome extends ConsumerStatefulWidget {
  const ListMasterHome({super.key});

  @override
  _ListMasterHomeState createState() => _ListMasterHomeState();
}

class _ListMasterHomeState extends ConsumerState<ListMasterHome> {
  @override
  void initState() {
    super.initState();
    ref.read(listMasterRepositoryProvider.notifier).fetchListMasters();
  }

   String searchNameArabic ='';
  String searchNameEnglish = '';

  bool search = false;

  void onSearch(String nameArabic, String nameEnglish)
  {
    setState(() {
      searchNameArabic = nameArabic;
      searchNameEnglish = nameEnglish;
        search = true;
    });
  }


 int isSelected = 1;
  @override
  Widget build(BuildContext context) {
    final listMasters = ref.watch(listMasterRepositoryProvider);
List<ListMaster> filteredListMaster = [];
    if(search == true){
        
        filteredListMaster= listMasters.where((singleListMaster){
      final matchesArabic = searchNameArabic =='' ||
          singleListMaster.nameArabic.toLowerCase().contains(searchNameArabic.toLowerCase());
      final matchesEnglish = searchNameEnglish=='' ||
          singleListMaster.nameEnglish.toLowerCase().contains(searchNameEnglish.toLowerCase());
      return matchesArabic && matchesEnglish;
    }).toList();
    }
   
     final iconButtons = [
                    {
                      "button": Icons.edit,
                      "function": (int id) {
                        final ListMaster currentListMaster = listMasters
                            .firstWhere((listMaster) => listMaster.id == id);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddListmasterScreen(
                              currentListMaster: currentListMaster,
                            );
                          },
                        );
                      },
                    },
                    {
                      "button": Icons.delete,
                      "function": (int id) => print("Delete $id")
                    },
                  ];

    return Scaffold(
      body: Column(
        children: [
          ListMasterSearchForm(onSearch: onSearch,),
          if (listMasters.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const ['Code', 'Name Arabic', 'Name English'],
                  data: const ['id', 'nameArabic', 'nameEnglish'],
                  selected: isSelected.toString(),
                  details: ListMaster.listToMap(search ? filteredListMaster : listMasters),
                  iconButtons: iconButtons,
                  expandable: true,
                  onTap: (int id) {
                    setState(() {
                      isSelected = id;
                    });

                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ListMasterItemHome(currentListMasterId: id)));
                  },
                  detailKey: 'id',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
