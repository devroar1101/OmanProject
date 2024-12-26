import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/admin/listmasteritem/model/listmasteritem.dart';
import 'package:tenderboard/admin/listmasteritem/model/listmasteritem_repo.dart';
import 'package:tenderboard/admin/listmasteritem/screens/add_listmasteritem.dart';
import 'package:tenderboard/admin/listmasteritem/screens/listmasteritem_form.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';

class ListMasterItemHome extends ConsumerStatefulWidget {
  final int currentListMasterId;
  const ListMasterItemHome({super.key, required this.currentListMasterId});

  @override
  _ListMasterItemHomeState createState() => _ListMasterItemHomeState();
}

class _ListMasterItemHomeState extends ConsumerState<ListMasterItemHome> {
  @override
  void initState() {
    super.initState();
    ref
        .read(listMasterItemRepositoryProvider.notifier)
        .fetchListMasterItems(currentListMasterId: widget.currentListMasterId);
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

  List<ListMasterItem> _applyFiltersAndPagination(
      List<ListMasterItem> listMasterItems) {
    // Apply search filters
    List<ListMasterItem> filteredList =
        listMasterItems.where((singlelistMaster) {
      final matchesArabic = searchNameArabic.isEmpty ||
          singlelistMaster.nameArabic
              .toLowerCase()
              .contains(searchNameArabic.toLowerCase());
      final matchesEnglish = searchNameEnglish.isEmpty ||
          singlelistMaster.nameEnglish
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
    final listMasterItems = ref.watch(listMasterItemRepositoryProvider);
    final filteredAndPaginatedList =
        _applyFiltersAndPagination(listMasterItems);

    final iconButtons = [
      {
        "button": Icons.edit,
        "function": (int id) {
          final ListMasterItem currentListMasterItem =
              listMasterItems.firstWhere((item) => item.id == id);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddListMasterItemScreen(
                currentListMasterItem: currentListMasterItem,
                currentListMasterId: currentListMasterItem.listMasterId,
              );
            },
          );
        },
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListMaster Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add New Item',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddListMasterItemScreen(
                    currentListMasterId: widget.currentListMasterId,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListMasterItemSearchForm(
                  onSearch: onSearch,
                ),
              ),
              const SizedBox(width: 8.0),
              Pagination(
                totalItems: search
                    ? listMasterItems.where((singlelistMaster) {
                        final matchesArabic = searchNameArabic.isEmpty ||
                            singlelistMaster.nameArabic
                                .toLowerCase()
                                .contains(searchNameArabic.toLowerCase());
                        final matchesEnglish = searchNameEnglish.isEmpty ||
                            singlelistMaster.nameEnglish
                                .toLowerCase()
                                .contains(searchNameEnglish.toLowerCase());
                        return matchesArabic && matchesEnglish;
                      }).length
                    : listMasterItems.length,
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
          if (listMasterItems.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const ['SNO', 'NameArabic', 'NameEnglish'],
                  data: const ['sno', 'nameArabic', 'nameEnglish'],
                  details: ListMasterItem.listToMap(filteredAndPaginatedList),
                  expandable: true,
                  selected: '1',
                  iconButtons: iconButtons,
                  onTap: (int index, {objectId}) {},
                  detailKey: 'id',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
