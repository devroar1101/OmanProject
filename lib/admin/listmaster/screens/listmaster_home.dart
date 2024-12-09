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

  @override
  Widget build(BuildContext context) {
    final listMasters = ref.watch(listMasterRepositoryProvider);

    return Scaffold(
      body: Column(
        children: [
          const ListMasterSearchForm(),
          if (listMasters.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const ['Code', 'Name Arabic', 'Name English'],
                  data: const ['code', 'nameArabic', 'nameEnglish'],
                  details: ListMaster.listToMap(listMasters),
                  iconButtons: [
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
                  ],
                  expandable: true,
                  onTap: (int index) {
                    final ListMaster currentListMaster = listMasters
                        .firstWhere((listmaster) => listmaster.id == index);
                    final int currentListMasterId = currentListMaster.id;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ListMasterItemHome(
                            currentListMasterId: currentListMasterId,
                          );
                          // return AddListmasterScreen(
                          //   currentListMaster: currentListMaster,
                          // );
                        });
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
