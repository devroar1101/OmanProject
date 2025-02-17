import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/admin/dgmaster/screens/add_dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/screens/dgmaster_form.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';
import 'package:tenderboard/common/widgets/custom_alert_box.dart';
import 'package:tenderboard/common/widgets/custom_snackbar.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';

class DgScreen extends ConsumerStatefulWidget {
  const DgScreen({super.key});

  @override
  _DgScreenState createState() => _DgScreenState();
}

class _DgScreenState extends ConsumerState<DgScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(dgRepositoryProvider.notifier).fetchDgs();
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

  List<Dg> _applyFiltersAndPagination(List<Dg> dgs) {
    if (dgs.isEmpty) {
      return [];
    }

    // Apply search filters
    List<Dg> filteredList = dgs.where((dg) {
      final matchesArabic = searchNameArabic.isEmpty ||
          (dg.nameArabic.toLowerCase() ?? '')
              .contains(searchNameArabic.toLowerCase());
      final matchesEnglish = searchNameEnglish.isEmpty ||
          (dg.nameEnglish.toLowerCase() ?? '')
              .contains(searchNameEnglish.toLowerCase());
      final matchesCode = searchCode.isEmpty ||
          (dg.code.toLowerCase() ?? '').contains(searchCode.toLowerCase());
      return matchesArabic && matchesEnglish && matchesCode;
    }).toList();

    // Apply pagination
    int startIndex = (pageNumber - 1) * pageSize;
    int endIndex = startIndex + pageSize;
    endIndex = endIndex > filteredList.length ? filteredList.length : endIndex;

    return filteredList.sublist(startIndex, endIndex);
  }

  void onDelete(int dgId) {
    ref.watch(dgRepositoryProvider.notifier).deleteDg(dgId: dgId);
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dg Deleted successfully!')),
    );
  
  }

  @override
  Widget build(BuildContext context) {
    final dgs = ref.watch(dgRepositoryProvider);
    final filteredAndPaginatedList = _applyFiltersAndPagination(dgs);

    final iconButtons = [
      {
        "button": Icons.edit,
        "function": (int id) {
          final Dg currentDg = dgs.firstWhere((dg) => dg.id == id);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddDGScreen(
                currentDGId: currentDg.id,
                editNameArabic: currentDg.nameArabic,
                editNameEnglish: currentDg.nameEnglish,
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
                  message: getTranslation('Areyousureyouwanttodeletethisdg?'),
                  onConfirm: () {
                    onDelete(id);
                    Navigator.of(context).pop(context);
                    CustomSnackbar.show(
                        context: context,
                        title: 'successfully',
                        message: getTranslation('Dgdeletedsuccessfully!'),
                        typeId: 1,
                        durationInSeconds: 3);
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
          // Combine DgSearchForm and Pagination in a single row
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
                    ? dgs.where((dg) {
                        final matchesArabic = searchNameArabic.isEmpty ||
                            dg.nameArabic
                                .toLowerCase()
                                .contains(searchNameArabic.toLowerCase());
                        final matchesEnglish = searchNameEnglish.isEmpty ||
                            dg.nameEnglish
                                .toLowerCase()
                                .contains(searchNameEnglish.toLowerCase());
                        final matchesCode = searchCode.isEmpty ||
                            dg.code
                                .toLowerCase()
                                .contains(searchCode.toLowerCase());
                        return matchesArabic && matchesEnglish && matchesCode;
                      }).length
                    : dgs.length,
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

          if (dgs.isEmpty)
            Center(child: Text(getTranslation('Noitemtodisplay')))
          else
            Expanded(
              child: Card(
                elevation: 10,
                shadowColor: Colors.grey.withOpacity(0.3),
                child: DisplayDetails(
                  headers: const ['Code', 'NameArabic', 'NameEnglish'],
                  data: const ['code', 'nameArabic', 'nameEnglish'],
                  details: Dg.listToMap(filteredAndPaginatedList),
                  expandable: true,
                  iconButtons: iconButtons,
                  onTap: (id, {objectId}) {},
                  detailKey: 'id',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
