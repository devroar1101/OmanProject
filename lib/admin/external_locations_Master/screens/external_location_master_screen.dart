import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master_repo.dart';

import 'package:tenderboard/admin/external_locations_Master/screens/external_location_master_form.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';

class ExternalLocationScreen extends ConsumerStatefulWidget {
  const ExternalLocationScreen({super.key});

  @override
  _ExternalLocationScreenState createState() => _ExternalLocationScreenState();
}

class _ExternalLocationScreenState
    extends ConsumerState<ExternalLocationScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch External Location Master items during initialization
    ref
        .read(ExternalLocationRepositoryProvider.notifier)
        .fetchExternalLocation();
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
    });
  }

  List<ExternalLocation> _applyFiltersAndPagination(
      List<ExternalLocation> externalLocations) {
    // Apply search filters
    List<ExternalLocation> filteredList =
        externalLocations.where((externalLocation) {
      final matchesArabic = searchNameArabic.isEmpty ||
          externalLocation.nameArabic
              .toLowerCase()
              .contains(searchNameArabic.toLowerCase());
      final matchesEnglish = searchNameEnglish.isEmpty ||
          externalLocation.nameEnglish
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
    final externalLocations = ref.watch(ExternalLocationRepositoryProvider);
    final filteredAndPaginatedList =
        _applyFiltersAndPagination(externalLocations);

    final iconButtons = [
      {
        "button": Icons.edit,
        "function": (int id) {
          // final ExternalLocation currentLocation =
          //               externalLocations.firstWhere(
          //                   (location) => location.id == id);
          //           showDialog(
          //             context: context,
          //             builder: (BuildContext context) {
          //               return const AddUserMasterScreen(

          //               );
          //             },
          //           );
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
                child: ExternalLocationMasterSearchForm(
                  onSearch: onSearch,
                ),
              ),
              const SizedBox(width: 8.0),
              Pagination(
                totalItems: search
                    ? externalLocations.where((externalLocation) {
                        final matchesArabic = searchNameArabic.isEmpty ||
                            externalLocation.nameArabic
                                .toLowerCase()
                                .contains(searchNameArabic.toLowerCase());
                        final matchesEnglish = searchNameEnglish.isEmpty ||
                            externalLocation.nameEnglish
                                .toLowerCase()
                                .contains(searchNameEnglish.toLowerCase());
                        return matchesArabic && matchesEnglish;
                      }).length
                    : externalLocations.length,
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
          if (externalLocations.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const [
                    'Name Arabic',
                    'Name English',
                    'Type',
                    'Active',
                    'Location (New)',
                  ],
                  data: const [
                    'nameArabic',
                    'nameEnglish',
                    'typeNameEnglish',
                    'active',
                    'isYes',
                  ],
                  details: ExternalLocation.listToMap(filteredAndPaginatedList),
                  expandable: true,
                  iconButtons: iconButtons,
                  onTap: (int index, {objectId}) {},
                  detailKey: 'objectId',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
