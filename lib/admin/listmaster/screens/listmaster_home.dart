import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/listmaster/screens/add_listmaster.dart';
import 'package:tenderboard/admin/listmasteritem/screens/listmasteritem_home.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/admin/listmaster/model/listmaster.dart';
import 'package:tenderboard/admin/listmaster/model/listmaster_repo.dart';
import 'package:tenderboard/admin/listmaster/screens/listmaster_form.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';

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

  String searchNameArabic = '';
  String searchNameEnglish = '';
  int pageNumber = 1; // Default to the first page
  int pageSize = 15; // Default page size
  bool search = false;

  void onSearch(String nameArabic, String nameEnglish) {
    setState(() {
      searchNameArabic = nameArabic;
      searchNameEnglish = nameEnglish;
      search = true;
      pageNumber = 1; // Default to the first page
      pageSize = 15;
    });
  }

  List<ListMaster> _applyFiltersAndPagination(List<ListMaster> listMasters) {
    // Apply search filters
    List<ListMaster> filteredList = listMasters.where((listMaster) {
      final matchesArabic = searchNameArabic.isEmpty ||
          listMaster.nameArabic
              .toLowerCase()
              .contains(searchNameArabic.toLowerCase());
      final matchesEnglish = searchNameEnglish.isEmpty ||
          listMaster.nameEnglish
              .toLowerCase()
              .contains(searchNameEnglish.toLowerCase());
      return matchesArabic && matchesEnglish;
    }).toList();

    // Apply pagination
    int startIndex = (pageNumber - 1) * pageSize;
    int endIndex = startIndex + pageSize;
    endIndex = endIndex > filteredList.length ? filteredList.length : endIndex;

    return filteredList.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    final listMasters = ref.watch(listMasterRepositoryProvider);
    final filteredAndPaginatedList = _applyFiltersAndPagination(listMasters);

    final iconButtons = [
      {
        "button": Icons.edit,
        "function": (int id) {
          final ListMaster currentListMaster =
              listMasters.firstWhere((listMaster) => listMaster.id == id);
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
      {"button": Icons.delete, "function": (int id) => print("Delete $id")},
    ];

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(width: 8.0),
          Row(
            children: [
              Expanded(
                child: ListMasterSearchForm(
                  onSearch: onSearch,
                ),
              ),
              const SizedBox(width: 8.0),
              Pagination(
                totalItems: search
                    ? listMasters.where((listMaster) {
                        final matchesArabic = searchNameArabic.isEmpty ||
                            listMaster.nameArabic
                                .toLowerCase()
                                .contains(searchNameArabic.toLowerCase());
                        final matchesEnglish = searchNameEnglish.isEmpty ||
                            listMaster.nameEnglish
                                .toLowerCase()
                                .contains(searchNameEnglish.toLowerCase());
                        return matchesArabic && matchesEnglish;
                      }).length
                    : listMasters.length,
                initialPageSize: pageSize,
                onPageChange: (pageNo, newPageSize) {
                  setState(() {
                    pageNumber = pageNo;
                    pageSize = newPageSize;
                  });
                },
              ),
            ],
          ),
          if (listMasters.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const ['Code', 'NameArabic', 'NameEnglish'],
                  data: const ['id', 'nameArabic', 'nameEnglish'],
                  selected: '1',
                  details: ListMaster.listToMap(filteredAndPaginatedList),
                  iconButtons: iconButtons,
                  expandable: true,
                  onTap: (int id, {objectId}) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) =>
                            ListMasterItemHome(currentListMasterId: id),
                      ),
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
