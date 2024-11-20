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
  bool _isFormVisible = true; // Sidebar visible on load
  List<DocumentSearch> _items = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      final items = await _repository.fetchListDocumentSearch(
        userObjectId: 'C792ED5F-8763-46E9-BF31-7ED8201EEB96',
      );
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void toggleSidebar() {
    setState(() {
      _isFormVisible = !_isFormVisible; // Toggle sidebar visibility
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _items.isEmpty
                  ? const Center(child: Text('No items found'))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isFormVisible) const DocumentSearchForm(),

                        // DisplayDetails widget
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DisplayDetails(
                              headers: const [
                                'Subject',
                                'Location',
                                'Reference #',
                                'Received Date',
                                'Tender Number',
                                'Date of Letter',
                              ],
                              data: const [
                                'subject',
                                'location',
                                'jobReferenceNumber',
                                'receivedDate',
                                'tenderNumber',
                                'dateOntheLetter',
                              ],
                              details: DocumentSearch.listToMap(_items),
                              expandable: true,
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }
}
