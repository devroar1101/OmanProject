import 'package:flutter/material.dart';
//import 'package:tenderboard/office/inbox/model/inbox.dart';
//import 'package:tenderboard/office/inbox/model/inbox_repo.dart';

class OutboxSearchForm extends StatefulWidget {
  // Optional: Callback to pass search results to parent
  //final Function(List<ListMasterItem>)? onSearch;

  const OutboxSearchForm({super.key});

  @override
  _OutboxSearchFormState createState() => _OutboxSearchFormState();
}

class _OutboxSearchFormState extends State<OutboxSearchForm> {
  final TextEditingController _filterController = TextEditingController();
  final TextEditingController _searchForController = TextEditingController();
  //final ListInboxRepository _repository = ListInboxRepository();

  void _resetFields() {
    _filterController.clear();
    _searchForController.clear();
  }

  // Future<void> _handleSearch() async {
  //   String filter = _filterController.text;
  //   String searchFor = _searchForController.text;
  //   String status = _statusController.text;

  //   try {
  //     // Fetch filtered list of ListMasterItems
  //     List<ListInbox> results = await _repository.fetchListInboxItems(
  //       filter: filter,
  //       searchFor: searchFor,
  //       status: status, // Assuming status is equivalent to status in your model
  //     );

  //     // Optional: Pass results back to parent widget if a callback is provided
  //     if (widget.onSearch != null) {
  //       widget.onSearch!(results);
  //     }
  //   } catch (e) {
  //     // Handle errors if any
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error occurred during search: $e')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Filter Text Field
            Expanded(
              child: TextField(
                controller: _filterController,
                decoration: InputDecoration(
                  labelText: 'Filter',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8.0), // Spacing between fields

            // SearchFor Text Field
            Expanded(
              child: TextField(
                controller: _searchForController,
                decoration: InputDecoration(
                  labelText: 'Search For',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),

            // SizedBox(width: 8.0), // Spacing between fields

            // // status (Status) Text Field
            // Expanded(
            //   child: TextField(
            //     controller: _statusController,
            //     decoration: InputDecoration(
            //       labelText: 'status',
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8.0),
            //       ),
            //     ),
            //   ),
            // ),

            const SizedBox(width: 8.0), // Spacing between fields and icons

            // Search Icon Button
            Card(
              color: const Color.fromARGB(255, 238, 240, 241),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
                tooltip: 'Search',
              ),
            ),

            // Reset Icon Button
            Card(
              color: const Color.fromARGB(255, 240, 234, 235),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _resetFields,
                tooltip: 'Reset',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
