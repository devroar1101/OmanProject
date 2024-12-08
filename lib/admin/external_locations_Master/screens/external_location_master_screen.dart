import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master_repo.dart';
import 'package:tenderboard/admin/external_locations_Master/screens/external_location_master_form.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

class ExternalLocationMasterScreen extends ConsumerStatefulWidget {
  const ExternalLocationMasterScreen({super.key});

  @override
  _ExternalLocationMasterScreenState createState() => _ExternalLocationMasterScreenState();
}

class _ExternalLocationMasterScreenState extends ConsumerState<ExternalLocationMasterScreen> {
  
  final List<ExternalLocationMaster> items = [];

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(ExternalLocationMasterRepositoryProvider);
    return Scaffold(
      body: FutureBuilder<List<ExternalLocationMaster>>(
        future: repository.fetchExternalLocationMaster(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found'));
          } else {
            final items = snapshot.data!;

            // Define headers and data keys
            final headers = [
              'code',
              'Name Arabic',
              'Name English',
              'Type',
              'Active',
              'Location(New)',
            ];
            final dataKeys = [
              'locationCode',
              'locationNameArabic',
              'locationNameEnglish',
              'typeNameEnglish',
              'active',
              'isYes',
            ];

            // Convert ListMasterItem list to map list with sno
            final details = ExternalLocationMaster.listToMap(items);

            // Pass the converted list to DisplayDetails
            return Column(
              children: [
                const ExternalLocationMasterSearchForm(),
                Expanded(
                  child: Stack(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DisplayDetails(
                            detailKey: 'objectId',
                            headers: headers,
                            data: dataKeys,
                            details: details, // Pass the list of maps
                            expandable: true, // Set false to expand by default
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
