import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/office/document_search/model/document_search.dart';
import 'package:tenderboard/office/document_search/model/document_search_repo.dart';
import 'package:tenderboard/office/document_search/screens/document_search_form.dart';

class DocumentSearchHome extends StatefulWidget {
  const DocumentSearchHome({super.key});

  @override
  _DocumentSearchHomeState createState() => _DocumentSearchHomeState();
}

class _DocumentSearchHomeState extends State<DocumentSearchHome> {
  final DocumentSearchRepository _repository = DocumentSearchRepository();
  late Future<List<DocumentSearch>> _documentSearchFuture; // Initialize once
  bool _isFormVisible = false;

  @override
  void initState() {
    super.initState();
    _documentSearchFuture = _repository.fetchListDocumentSearch(
      userObjectId: 'C792ED5F-8763-46E9-BF31-7ED8201EEB96',
    );
  }

  void toggleSidebar() {
    setState(() {
      _isFormVisible = !_isFormVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: toggleSidebar,
          ),
        ],
      ),
      body: FutureBuilder<List<DocumentSearch>>(
        future: _documentSearchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found'));
          } else {
            final items = snapshot.data!;
            final headers = [
              'Subject',
              'Location',
              'Reference #',
              'Received Date',
              'Tender Number',
              'Date of Letter',
            ];
            final dataKeys = [
              'subject',
              'location',
              'jobReferenceNumber',
              'receivedDate',
              'tenderNumber',
              'dateOntheLetter',
            ];

            final details = DocumentSearch.listToMap(items);

            return Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DisplayDetails(
                          headers: headers,
                          data: dataKeys,
                          details: details,
                          expandable: true,
                        ),
                      ),
                    ),
                  ],
                ),
                // Inside the AnimatedPositioned in the DocumentSearchHome screen
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  right: _isFormVisible ? 0 : -400, // Adjust based on new width
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 400, // New sidebar width
                    color:
                        Colors.black.withOpacity(0.0), // Transparent background
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: toggleSidebar,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  // Calculate height based on number of fields (example: 10 fields, each row is about 60.0 height)
                                  maxHeight: 100.0 *
                                      5, // Adjust multiplier based on the number of fields
                                ),
                                child: DocumentSearchForm(),
                              ),
                            ),
                          ),
                        ],
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
