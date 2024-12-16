import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/section_master/model/section_master.dart';
import 'package:tenderboard/admin/section_master/model/section_master_repo.dart';
import 'package:tenderboard/admin/section_master/screens/add_section_master.dart';
import 'package:tenderboard/admin/section_master/screens/section_master_form.dart';
import 'package:tenderboard/common/widgets/custom_alert_box.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';

class SectionMasterScreen extends ConsumerStatefulWidget {
  const SectionMasterScreen({super.key});

  @override
  _SectionMasterScreenState createState() => _SectionMasterScreenState();
}

class _SectionMasterScreenState extends ConsumerState<SectionMasterScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch initial sections when the screen initializes
    ref.read(sectionMasterRepositoryProvider.notifier).fetchSections();
  }

  String searchNameArabic = '';
  String searchNameEnglish = '';
  String searchCode = '';
  String searchDG = '';
  String searchDepatment = '';
  int pageNumber = 1;
  int pageSize = 15;
  bool search = false;

  void onSearch(String nameArabic, String nameEnglish, String code, String? dg,
      String? department) {
    setState(() {
      searchNameArabic = nameArabic;
      searchNameEnglish = nameEnglish;
      searchCode = code;
      searchDG = dg ?? '';
      searchDepatment = department ?? '';
      search = true;
    });
  }

  List<SectionMaster> _applyFiltersAndPagination(List<SectionMaster> sections) {
    if (sections.isEmpty) {
      return [];
    }

    List<SectionMaster> filteredList = sections.where((singlesection) {
      final matchesArabic = searchNameArabic.isEmpty ||
          (singlesection.sectionNameArabic.toLowerCase())
              .contains(searchNameArabic.toLowerCase());
      final matchesEnglish = searchNameEnglish.isEmpty ||
          (singlesection.sectionNameEnglish.toLowerCase())
              .contains(searchNameEnglish.toLowerCase());
      final matchesCode = searchCode.isEmpty ||
          (singlesection.code.toLowerCase()).contains(searchCode.toLowerCase());
      final matchesDg =
          searchDG.isEmpty || singlesection.dgId.toString() == searchDG;
      final matchesDepartment = searchDepatment.isEmpty ||
          singlesection.departmentId.toString() == searchDepatment;
      return matchesArabic &&
          matchesEnglish &&
          matchesCode &&
          matchesDg &&
          matchesDepartment; // && matchesDg;
    }).toList();

    // Apply pagination
    int startIndex = (pageNumber - 1) * pageSize;
    int endIndex = startIndex + pageSize;
    endIndex = endIndex > filteredList.length ? filteredList.length : endIndex;

    return filteredList.sublist(startIndex, endIndex);
  }

  void onDelete(int sectionId) {
    ref
        .watch(sectionMasterRepositoryProvider.notifier)
        .deleteSection(sectionId: sectionId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Section Deleted successfully!')),
    );
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    final sections = ref.watch(sectionMasterRepositoryProvider);
    final filteredAndPaginatedList = _applyFiltersAndPagination(sections);

    final iconButtons = [
      {
        "button": Icons.edit,
        "function": (int id) {
          final SectionMaster currentSection =
              sections.firstWhere((section) => section.sectionId == id);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddSectionMaster(
                currentSection: currentSection,
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
              message: 'Are you sure you want to delete this section?',
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
          SectionMasterSearchForm(
            onSearch: onSearch,
          ),
          if (sections.isNotEmpty)
            Pagination(
              totalItems: search
                  ? sections.where((singlesection) {
                      final matchesArabic = searchNameArabic.isEmpty ||
                          singlesection.sectionNameArabic
                              .toLowerCase()
                              .contains(searchNameArabic.toLowerCase());
                      final matchesEnglish = searchNameEnglish.isEmpty ||
                          singlesection.sectionNameEnglish
                              .toLowerCase()
                              .contains(searchNameEnglish.toLowerCase());
                      final matchesCode = searchCode.isEmpty ||
                          singlesection.code
                              .toLowerCase()
                              .contains(searchCode.toLowerCase());
                      final matchesDg = searchDG.isEmpty ||
                          singlesection.dgId.toString() == searchDG;
                      final matchesDepartment = searchDepatment.isEmpty ||
                          singlesection.departmentId.toString() ==
                              searchDepatment;
                      return matchesArabic &&
                          matchesEnglish &&
                          matchesCode &&
                          matchesDg &&
                          matchesDepartment; //&& matchesDg;
                    }).length
                  : sections.length,
              initialPageSize: pageSize,
              onPageChange: (pageNo, newPageSize) {
                setState(() {
                  pageNumber = pageNo;
                  pageSize = newPageSize;
                });
              },
            ), // Search form widget
          if (sections.isEmpty)
            const Expanded(child: Center(child: Text('No sections found')))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const [
                    'Code',
                    'Name Arabic',
                    'Name English',
                    'Department',
                  ], // Headers for columns
                  data: const [
                    'code',
                    'sectionNameArabic',
                    'sectionNameEnglish',
                    'departmentId',
                  ], // Keys to extract data
                  details:
                      SectionMaster.listToMap(filteredAndPaginatedList), // Convert list to map
                  expandable: true, 
                  iconButtons: iconButtons,// Expandable table rows
                  onTap: (int index) {},
                  detailKey: 'sectionId', // Unique key for row selection
                ),
              ),
            ),
        ],
      ),
    );
  }
}
