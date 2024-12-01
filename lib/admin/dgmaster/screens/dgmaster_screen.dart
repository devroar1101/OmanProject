import 'package:flutter/material.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/admin/dgmaster/screens/dgmaster_form.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

class DgMasterScreen extends StatefulWidget {
  const DgMasterScreen({super.key});

  @override
  _DgMasterScreenState createState() => _DgMasterScreenState();
}

class _DgMasterScreenState extends State<DgMasterScreen> {
  final DgMasterRepository _repository = DgMasterRepository();
  final List<DgMaster> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<DgMaster>>(
        future: _repository.fetchDgMasters(),
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
            ];
            final dataKeys = [
              'code',
              'nameArabic',
              'nameEnglish',
            ];

            // Convert ListMasterItem list to map list with sno
            final details = DgMaster.listToMap(items);

            // Pass the converted list to DisplayDetails
            return Column(
              children: [
                const DgMasterSearchForm(),
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
