import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/department_master/model/department_repo.dart';
import 'package:tenderboard/admin/department_master/screens/add_department.dart';
import 'package:tenderboard/admin/department_master/screens/deparment_form.dart';

import 'package:tenderboard/common/utilities/global_helper.dart';
import 'package:tenderboard/common/widgets/custom_alert_box.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';

class DepartmentScreen extends ConsumerStatefulWidget {
  const DepartmentScreen({super.key});

  @override
  _DepartmentScreenState createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends ConsumerState<DepartmentScreen> {
  @override
  void initState() {
    super.initState();
  }

  String searchNameArabic = '';
  String searchNameEnglish = '';
  String searchCode = '';
  String searchDG = '';
  int pageNumber = 1;
  int pageSize = 15;
  bool search = false;

  void onSearch(
      String nameArabic, String nameEnglish, String code, String? dg) {
    setState(() {
      searchNameArabic = nameArabic;
      searchNameEnglish = nameEnglish;
      searchCode = code;
      searchDG = dg ?? '';
      search = true;
      pageNumber = 1;
      pageSize = 15;
    });
  }

  List<Department> _applyFiltersAndPagination(List<Department> departments) {
    if (departments.isEmpty) {
      return [];
    }

    List<Department> filteredList = departments.where((department) {
      final matchesArabic = searchNameArabic.isEmpty ||
          (department.nameArabic.toLowerCase())
              .contains(searchNameArabic.toLowerCase());
      final matchesEnglish = searchNameEnglish.isEmpty ||
          (department.dgNameEnglish.toLowerCase())
              .contains(searchNameEnglish.toLowerCase());
      final matchesCode = searchCode.isEmpty ||
          (department.code.toLowerCase()).contains(searchCode.toLowerCase());
      final matchesDg =
          searchDG.isEmpty || department.dgId.toString() == searchDG;
      return matchesArabic &&
          matchesEnglish &&
          matchesCode &&
          matchesDg; // && matchesDg;
    }).toList();

    // Apply pagination
    int startIndex = (pageNumber - 1) * pageSize;
    int endIndex = startIndex + pageSize;
    endIndex = endIndex > filteredList.length ? filteredList.length : endIndex;

    return filteredList.sublist(startIndex, endIndex);
  }

  void onDelete(int departmentId) {
    ref
        .watch(departmentRepositoryProvider.notifier)
        .deleteDpartment(DepartmentId: departmentId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Department Deleted successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final departments = ref.watch(departmentRepositoryProvider);
    final filteredAndPaginatedList = _applyFiltersAndPagination(departments);

    final iconButtons = [
      {
        "button": (Icons.edit,),
        "function": (int id) {
          final Department currentDepartment =
              departments.firstWhere((department) => department.id == id);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddDepartment(
                currentDepartment: currentDepartment,
              );
            },
          );
        },
      },
      {
        "button": Icons.delete,
        "function": (int id) {
          showDialog(
            context: context,
            builder: (context) => ConfirmationAlertBox(
              messageType: 3,
              message: getTranslation('Areyousureyouwanttodeletethisdg?'),
              onConfirm: () {
                onDelete(id);
              },
              onCancel: () {
                Navigator.pop(context);
              },
            ),
          );
        }
      },
    ];

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: DepartmentSearchForm(
                  onSearch: onSearch,
                ),
              ),
              const SizedBox(width: 8.0),
              Pagination(
                totalItems: search
                    ? departments.where((department) {
                        final matchesArabic = searchNameArabic.isEmpty ||
                            department.nameArabic
                                .toLowerCase()
                                .contains(searchNameArabic.toLowerCase());
                        final matchesEnglish = searchNameEnglish.isEmpty ||
                            department.nameEnglish
                                .toLowerCase()
                                .contains(searchNameEnglish.toLowerCase());
                        final matchesCode = searchCode.isEmpty ||
                            department.code
                                .toLowerCase()
                                .contains(searchCode.toLowerCase());
                        final matchesDg = searchDG.isEmpty ||
                            department.dgId.toString() == searchDG;
                        return matchesArabic &&
                            matchesEnglish &&
                            matchesCode &&
                            matchesDg; //&& matchesDg;
                      }).length
                    : departments.length,
                initialPageSize: pageSize,
                onPageChange: (pageNo, newPageSize) {
                  setState(() {
                    pageNumber = pageNo;
                    pageSize = newPageSize;
                  });
                },
              ),
            ],
          ), // Search form widget

          if (departments.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const [
                    'Code',
                    'NameArabic',
                    'NameEnglish',
                    'DG',
                  ], // Headers for columns
                  data: const [
                    'code',
                    'nameArabic',
                    'nameEnglish',
                    'dgNameEnglish',
                  ], // Keys to extract data
                  details: Department.listToMap(
                      filteredAndPaginatedList), // Convert list to map
                  expandable: true, // Expandable table rows
                  iconButtons: iconButtons,
                  onTap: (index, {objectId}) {},
                  detailKey: 'id', // Unique key for row selection
                ),
              ),
            ),
        ],
      ),
    );
  }
}
