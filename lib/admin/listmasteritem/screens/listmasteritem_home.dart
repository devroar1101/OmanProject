import 'package:flutter/material.dart';
import 'package:tenderboard/admin/listmasteritem/model/listmasteritem.dart';
import 'package:tenderboard/admin/listmasteritem/model/listmasteritem_repo.dart';

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
        title: Text('ListMaster Items'),
      ),
      body: FutureBuilder<List<ListMasterItem>>(
        future: _repository.fetchListMasterItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found'));
          } else {
            final items = snapshot.data!;
            return Column(
              children: [
                // Static header row
                Container(
                  color: Colors.blue.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text('S.No',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                            child: Text('Name Arabic',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                            child: Text('Name English',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                            child: Text('System Field',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                ),

                // Scrollable content with data rows
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        child: DataTable(
                          dataRowColor: WidgetStateProperty.resolveWith(
                              (states) => Colors.grey.shade100),
                          columns: [
                            DataColumn(
                                label: SizedBox
                                    .shrink()), // Empty column for alignment with header
                            DataColumn(
                                label: SizedBox
                                    .shrink()), // Empty column for alignment with header
                            DataColumn(
                                label: SizedBox
                                    .shrink()), // Empty column for alignment with header
                            DataColumn(
                                label: SizedBox
                                    .shrink()), // Empty column for alignment with header
                          ],
                          rows: List<DataRow>.generate(
                            items.length,
                            (index) => DataRow(
                              cells: [
                                DataCell(Text('${index + 1}')),
                                DataCell(Text(items[index].nameArabic)),
                                DataCell(Text(items[index].nameEnglish)),
                                DataCell(Text(items[index].systemField)),
                              ],
                            ),
                          ),
                        ),
                      ),
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
