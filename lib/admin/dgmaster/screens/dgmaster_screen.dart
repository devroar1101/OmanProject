import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/admin/dgmaster/screens/add_dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/screens/dgmaster_form.dart';
import 'package:tenderboard/common/widgets/custom_alert_box.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';

class DgMasterScreen extends ConsumerStatefulWidget {
  const DgMasterScreen({super.key});

  @override
  _DgMasterScreenState createState() => _DgMasterScreenState();
}

class _DgMasterScreenState extends ConsumerState<DgMasterScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(dgMasterRepositoryProvider.notifier).fetchDgMasters();
  }

  String searchNameArabic = '';
  String searchNameEnglish = '';
  String searchCode = '';
  int pageNumber = 1;
  int pageSize = 15;
  bool search = false;

  void onSearch(String nameArabic, String nameEnglish, String code) {
    setState(() {
      searchNameArabic = nameArabic;
      searchNameEnglish = nameEnglish;
      searchCode = code;
      search = true;
      pageNumber = 1;
      pageSize = 15;
    });
  }

  List<DgMaster> _applyFiltersAndPagination(List<DgMaster> dgMasters) {
    if (dgMasters.isEmpty) {
      return [];
    }

    // Apply search filters
    List<DgMaster> filteredList = dgMasters.where((dgMaster) {
      final matchesArabic = searchNameArabic.isEmpty ||
          (dgMaster.nameArabic.toLowerCase() ?? '')
              .contains(searchNameArabic.toLowerCase());
      final matchesEnglish = searchNameEnglish.isEmpty ||
          (dgMaster.nameEnglish.toLowerCase() ?? '')
              .contains(searchNameEnglish.toLowerCase());
      final matchesCode = searchCode.isEmpty ||
          (dgMaster.code.toLowerCase() ?? '')
              .contains(searchCode.toLowerCase());
      return matchesArabic && matchesEnglish && matchesCode;
    }).toList();

    // Apply pagination
    int startIndex = (pageNumber - 1) * pageSize;
    int endIndex = startIndex + pageSize;
    endIndex = endIndex > filteredList.length ? filteredList.length : endIndex;

    return filteredList.sublist(startIndex, endIndex);
  }

  void onDelete(int dgId) {
    ref.watch(dgMasterRepositoryProvider.notifier).deleteDgMaster(dgId: dgId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('DG master Deleted successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dgMasters = ref.watch(dgMasterRepositoryProvider);
    final filteredAndPaginatedList = _applyFiltersAndPagination(dgMasters);

    final iconButtons = [
      {
        "button": Icons.edit,
        "function": (int id) {
          final DgMaster currentDgMaster =
              dgMasters.firstWhere((dgMaster) => dgMaster.id == id);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddDGmasterScreen(
                currentDGId: currentDgMaster.id,
                editNameArabic: currentDgMaster.nameArabic,
                editNameEnglish: currentDgMaster.nameEnglish,
              );
            },
          );
        },
      },
      {
        "button": Icons.delete,
        "function": (int id) => {
              showDialog(
                context: context,
                builder: (context) => ConfirmationAlertBox(
                  messageType: 3,
                  message: 'Are you sure you want to delete this DG?',
                  onConfirm: () {
                    onDelete(id);
                  },
                  onCancel: () {
                    Navigator.of(context).pop(context);
                  },
                ),
              )
            }
      },
    ];

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 8.0),
          // Combine DgMasterSearchForm and Pagination in a single row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: DgMasterSearchForm(
                  onSearch: onSearch,
                ),
              ),
              const SizedBox(
                  width: 8.0), // Add spacing between form and pagination
              Pagination(
                totalItems: search
                    ? dgMasters.where((dgMaster) {
                        final matchesArabic = searchNameArabic.isEmpty ||
                            dgMaster.nameArabic
                                .toLowerCase()
                                .contains(searchNameArabic.toLowerCase());
                        final matchesEnglish = searchNameEnglish.isEmpty ||
                            dgMaster.nameEnglish
                                .toLowerCase()
                                .contains(searchNameEnglish.toLowerCase());
                        final matchesCode = searchCode.isEmpty ||
                            dgMaster.code
                                .toLowerCase()
                                .contains(searchCode.toLowerCase());
                        return matchesArabic && matchesEnglish && matchesCode;
                      }).length
                    : dgMasters.length,
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

          if (dgMasters.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Card(
                elevation: 10,
                shadowColor: Colors.grey.withOpacity(0.3),
                child: DisplayDetails(
                  headers: const ['Code', 'Name Arabic', 'Name English'],
                  data: const ['code', 'nameArabic', 'nameEnglish'],
                  details: DgMaster.listToMap(filteredAndPaginatedList),
                  expandable: true,
                  iconButtons: iconButtons,
                  onTap: (int id, {objectId}) {},
                  detailKey: 'id',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
