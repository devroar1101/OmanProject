import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/admin/listmaster/model/listmaster.dart';
import 'package:tenderboard/admin/listmaster/model/listmaster_repo.dart';
import 'package:tenderboard/admin/listmaster/screens/listmaster_form.dart';

class ListMasterHome extends StatefulWidget {
  const ListMasterHome({super.key});

  @override
  _ListMasterHomeState createState() => _ListMasterHomeState();
}

class _ListMasterHomeState extends State<ListMasterHome> {
  final ListMasterRepository _repository = ListMasterRepository();
  final List<ListMaster> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListMaster'),
      ),
      body: FutureBuilder<List<ListMaster>>(
        future: _repository.fetchListMasters(),
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
              'System Field',
            ];
            final dataKeys = [
              'systemField',
              'nameArabic',
              'nameEnglish',
              'systemField',
            ];

            // Convert ListMasterItem list to map list with sno
            final details = ListMaster.listToMap(items);

            // Pass the converted list to DisplayDetails
            return Column(
              children: [
                ListMasterSearchForm(),
                Expanded(
                  child: Stack(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DisplayDetails(
                            headers: headers,
                            data: dataKeys,
                            details: details, // Pass the list of maps
                            expandable: true, // Set false to expand by default
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 10,
                          right: 10,
                          child: FloatingActionButton(
                            onPressed: () {},
                            child: const Icon(Icons.add),
                          ))
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
