import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/office/outbox/model/outbox.dart';
import 'package:tenderboard/office/outbox/model/outbox_repo.dart';
import 'package:tenderboard/office/outbox/screens/outbox_form.dart';

class OutboxScreen extends StatefulWidget {
  const OutboxScreen({super.key});

  @override
  _OutboxScreenState createState() => _OutboxScreenState();
}

class _OutboxScreenState extends State<OutboxScreen> {
  final OutboxRepository _repository = OutboxRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outbox'),
      ),
      body: FutureBuilder<List<Outbox>>(
        future: _repository.fetchOutboxItem(
          fromUserObjectId: 'C792ED5F-8763-46E9-BF31-7ED8201EEB96',
          screenName: 'Outbox',
        ),
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
              'Subject',
              'Location',
              'Reference #',
              'Date & Time',
            ];
            final dataKeys = [
              'subject',
              'location',
              'jobReferenceNumber',
              'actionDate',
            ];

            // Convert ListMasterItem list to map list with sno
            final details = Outbox.listToMap(items); 

            // Pass the converted list to DisplayDetails
            return Column(
              children: [
                OutboxSearchForm(),
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
                            child:const Icon(Icons.add),
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
