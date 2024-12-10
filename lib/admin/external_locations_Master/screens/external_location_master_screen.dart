import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master_repo.dart';
import 'package:tenderboard/admin/external_locations_Master/screens/external_location_master_form.dart';
import 'package:tenderboard/admin/user_master/screens/add_user_master.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

class ExternalLocationMasterScreen extends ConsumerStatefulWidget {
  const ExternalLocationMasterScreen({super.key});

  @override
  _ExternalLocationMasterScreenState createState() =>
      _ExternalLocationMasterScreenState();
}

class _ExternalLocationMasterScreenState
    extends ConsumerState<ExternalLocationMasterScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch External Location Master items during initialization
    ref
        .read(ExternalLocationMasterRepositoryProvider.notifier)
        .fetchExternalLocationMaster();
  }

  @override
  Widget build(BuildContext context) {
    final externalLocations = ref.watch(ExternalLocationMasterRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('External Location Master'),
      ),
      body: Column(
        children: [
          const ExternalLocationMasterSearchForm(),
          if (externalLocations.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const [
                    'Code',
                    'Name Arabic',
                    'Name English',
                    'Type',
                    'Active',
                    'Location (New)',
                  ],
                  data: const [
                    'locationCode',
                    'locationNameArabic',
                    'locationNameEnglish',
                    'typeNameEnglish',
                    'active',
                    'isYes',
                  ],
                  details: ExternalLocationMaster.listToMap(externalLocations),
                  expandable: true,
                  onTap: (int index) {
                    final ExternalLocationMaster currentLocation =
                        externalLocations.firstWhere(
                            (location) => location.objectId == index);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AddUserMasterScreen(
                          
                        );
                      },
                    );
                  },
                  detailKey: 'objectId',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
