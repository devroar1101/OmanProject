import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';
import 'package:tenderboard/office/inbox/model/inbox.dart';
import 'package:tenderboard/office/inbox/model/inbox_repo.dart';
import 'package:tenderboard/office/inbox/screens/inbox_form.dart';
import 'package:tenderboard/office/scan_document_summary/screens/scan_document_summary_screen.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package

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
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align children to the left (default)
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: InboxSearchForm(),
          ),
          // Wrap Pagination widget in a Row to control its positioning
          const Row(
            mainAxisAlignment: MainAxisAlignment
                .end, // Align the pagination to the end of the row
            children: [
              Pagination(),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<ListInbox>>(
              future: _repository.fetchListInboxItems(
                toUserObjectId: 'C792ED5F-8763-46E9-BF31-7ED8201EEB96',
                screenName: 'Inbox',
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerEffect(); // Show shimmer effect when loading
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
                  return DisplayDetails(
                    headers: headers,
                    data: dataKeys,
                    details: details, // Pass the list of maps
                    expandable: true,
                    onTap: (int Index) {
                      final jobId = items[Index].scanDocumentObjectId;

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ScanDocumentSummaryScreen(jobId)));
                    }, // Set false to expand by default
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method to build shimmer effect for loading state
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount:
            10, // Adjust the number of shimmer items to match the rows you expect
        itemBuilder: (context, index) {
          return Container(
            height:
                60, // Set the height of each shimmer item (similar to your list rows)
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(5), // Keep the rounded corners
            ),
          );
        },
      ),
    );
  }
}
