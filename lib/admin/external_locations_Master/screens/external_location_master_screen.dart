import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master_repo.dart';
import 'package:tenderboard/admin/external_locations_Master/screens/add_external_location.dart';

import 'package:tenderboard/admin/external_locations_Master/screens/external_location_master_form.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';
import 'package:tenderboard/common/widgets/custom_alert_box.dart';
import 'package:tenderboard/common/widgets/custom_snackbar.dart';
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
        .read(externalLocationRepositoryProvider.notifier)
        .fetchExternalLocation();
  }

  String searchNameArabic = '';
  String searchNameEnglish = '';
  String searchType = '';
  int pageNumber = 1; // Default to the first page
  int pageSize = 15; // Default page size
  bool search = false;

  void onSearch(String nameArabic, String nameEnglish, String type) {
    setState(() {
      searchNameArabic = nameArabic;
      searchNameEnglish = nameEnglish;
      searchType = type;
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
      final matchesType = searchType.isEmpty ||
          externalLocation.type
              .toLowerCase()
              .contains(searchType.toLowerCase());
      return matchesArabic && matchesEnglish && matchesType;
    }).toList();

    // Apply pagination
    int startIndex = (pageNumber - 1) * pageSize;
    int endIndex = startIndex + pageSize;
    endIndex = endIndex > filteredList.length ? filteredList.length : endIndex;

    return filteredList.sublist(startIndex, endIndex);
  }

  void onDelete(int locationId) {
    ref
        .watch(externalLocationRepositoryProvider.notifier)
        .deleteExternalLocation(locationId: locationId);
  }

  @override
  Widget build(BuildContext context) {
    final externalLocations = ref.watch(externalLocationRepositoryProvider);
    final filteredAndPaginatedList =
        _applyFiltersAndPagination(externalLocations);

    final iconButtons = [
      {
        "button": Icons.edit,
        "function": (int id) {
          final ExternalLocation currentLocation =
              externalLocations.firstWhere((location) => location.id == id);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddExternalLocation(
                currentExternalLocationId: currentLocation.id,
                currentlocation: currentLocation,
                editNameArabic: currentLocation.nameArabic,
                editNameEnglish: currentLocation.nameEnglish,
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
                  message: getTranslation(
                      'AreyousureyouwanttodeletethisExternalLocation?'),
                  onConfirm: () {
                    onDelete(id);
                    Navigator.of(context).pop(context);
                    CustomSnackbar.show(
                        context: context,
                        title: 'successfully',
                        message: getTranslation(
                            'ExternalLocationdeletedsuccessfully!'),
                        typeId: 1,
                        durationInSeconds: 3);
                  },
                  onCancel: () {
                    Navigator.of(context).pop(context);
                  },
                ),
              )
            },
      }
    ];

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 8.0),
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
                        final matchesType = searchType.isEmpty ||
                            externalLocation.type
                                .toLowerCase()
                                .contains(searchType.toLowerCase());
                        return matchesArabic && matchesEnglish && matchesType;
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
                    'NameArabic',
                    'NameEnglish',
                    'Type',
                    'category'
                  ],
                  data: const [
                    'nameArabic',
                    'nameEnglish',
                    'type',
                    'isNew',
                  ],
                  details: ExternalLocation.listToMap(filteredAndPaginatedList),
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
