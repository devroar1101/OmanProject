import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/admin/listmaster/model/listmaster.dart';
import 'package:tenderboard/admin/listmaster/model/listmaster_repo.dart';
import 'package:tenderboard/admin/listmaster/screens/listmaster_form.dart';

class ListMasterHome extends ConsumerStatefulWidget {
  const ListMasterHome({super.key});

  @override
  _ListMasterHomeState createState() => _ListMasterHomeState();
}

class _ListMasterHomeState extends ConsumerState<ListMasterHome> {
  @override
  Widget build(BuildContext context) {
    final repository =
        ref.watch(listMasterRepositoryProvider); // Access the repository

    return Scaffold(
      body: FutureBuilder<List<ListMaster>>(
        future: repository.fetchListMasters(), // Use the repository here
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
              'Code',
              'Name Arabic',
              'Name English',
            ];
            final dataKeys = [
              'code',
              'nameArabic',
              'nameEnglish',
            ];

            // Convert ListMasterItem list to map list with sno
            final details = ListMaster.listToMap(items);

            return Column(
              children: [
                const ListMasterSearchForm(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DisplayDetails(
                      headers: headers,
                      data: dataKeys,
                      details: details,
                      expandable: true,
                      selectedNo: -1,
                    ),
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
