import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/office/inbox/model/inbox.dart';
import 'package:tenderboard/office/inbox/model/inbox_repo.dart';
import 'package:tenderboard/office/inbox/screens/inbox_form.dart';

class InboxHome extends StatefulWidget {
  const InboxHome({super.key});

  @override
  _InboxHomeState createState() => _InboxHomeState();
}

class _InboxHomeState extends State<InboxHome> {
  final ListInboxRepository _repository = ListInboxRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ListInbox>>(
        future: _repository.fetchListInboxItems(
          toUserObjectId: 'C792ED5F-8763-46E9-BF31-7ED8201EEB96',
          screenName: 'Inbox',
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
              'From',
              'Date & Time',
            ];
            final dataKeys = [
              'subject',
              'location',
              'jobReferenceNumber',
              'fromUserName',
              'actionDate',
            ];

            // Convert ListMasterItem list to map list with sno
            final details = ListInbox.listToMap(items);

            // Pass the converted list to DisplayDetails
            return Column(
              children: [
                InboxSearchForm(),
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
