import 'package:flutter/material.dart';
import 'package:tenderboard/admin/common/widgets/displaydetails.dart';
import 'package:tenderboard/admin/listmasteritem/model/listmasteritem.dart';
import 'package:tenderboard/admin/listmasteritem/model/listmasteritem_repo.dart';
import 'package:tenderboard/admin/listmasteritem/screens/listmasteritem_form.dart';

class ListMasterItemHome extends StatefulWidget {
  const ListMasterItemHome({super.key});

  @override
  _ListMasterItemHomeState createState() => _ListMasterItemHomeState();
}

class _ListMasterItemHomeState extends State<ListMasterItemHome> {
  final ListMasterItemRepository _repository = ListMasterItemRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListMaster Items'),
      ),
      body: FutureBuilder<List<ListMasterItem>>(
        future: _repository.fetchListMasterItems(),
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
              'Sno',
              'Name Arabic',
              'Name English',
              'Sno',
              'Name Arabic',
              'Name English',
              'Sno',
              'Name Arabic',
              'Name English',
              'Sno',
              'Name Arabic',
              'Name English',
              'Sno',
              'Name Arabic',
              'Name English',
              'Sno',
              'Name Arabic',
              'Name English',
            ];
            final dataKeys = [
              'sno',
              'nameArabic',
              'nameEnglish',
              'sno',
              'nameArabic',
              'nameEnglish',
              'sno',
              'nameArabic',
              'nameEnglish',
              'sno',
              'nameArabic',
              'nameEnglish',
            ];

            // Convert ListMasterItem list to map list with sno
            final details = ListMasterItem.listToMap(items);

            // Pass the converted list to DisplayDetails
            return Column(
              children: [
                ListMasterItemSearchForm(),
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
