import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/admin/listmasteritem/model/listmasteritem.dart';
import 'package:tenderboard/admin/listmasteritem/model/listmasteritem_repo.dart';
import 'package:tenderboard/admin/listmasteritem/screens/add_listmasteritem.dart';
import 'package:tenderboard/admin/listmasteritem/screens/listmasteritem_form.dart';

class ListMasterItemHome extends ConsumerStatefulWidget {
    final int currentListMasterId;
  const ListMasterItemHome({super.key,required this.currentListMasterId});

  @override
  _ListMasterItemHomeState createState() => _ListMasterItemHomeState();
}

class _ListMasterItemHomeState extends ConsumerState<ListMasterItemHome> {
 
  @override
  void initState() {
    super.initState();
    ref.read(listMasterItemRepositoryProvider.notifier).fetchListMasterItems(currentListMasterId: widget.currentListMasterId );
    
  }

  @override
  Widget build(BuildContext context) {
    final listMasterItems = ref.watch(listMasterItemRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ListMaster Items'),
      ),
      body: Column(
        children: [
          const ListMasterItemSearchForm(),
          if (listMasterItems.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const ['Sno', 'Name Arabic', 'Name English'],
                  data: const ['sno', 'nameArabic', 'nameEnglish'],
                  details: ListMasterItem.listToMap(listMasterItems),
                  expandable: true,
                  onTap: (int index) {
                    final ListMasterItem currentListMasterItem =
                        listMasterItems.firstWhere((item) => item.id == index);
                    showDialog(
                      context: context,
                      
                      builder: (BuildContext context) {
                        return AddListMasterItemScreen(
                          currentListMasterItem: currentListMasterItem,currentListMasterId: currentListMasterItem.listMasterId,
                        );
                      },
                    );
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
