import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';

class ListSearchForm extends StatefulWidget {
  const ListSearchForm({super.key});

  @override
  _ListSearchFormState createState() => _ListSearchFormState();
}

class _ListSearchFormState extends State<ListSearchForm> {
  final TextEditingController _filterController = TextEditingController();
  final TextEditingController _searchForController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  bool showFilter = false;

  void _resetFields() {
    _filterController.clear();
    _searchForController.clear();
    _statusController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Filter Card
        Visibility(
          visible: showFilter,
          child: Expanded(
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              margin: const EdgeInsets.all(2.0),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  children: [
                    // Filter TextField
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
                    const SizedBox(width: 8.0), // Spacing

                    // Search For TextField
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
                    const SizedBox(width: 8.0), // Spacing

                    // Status TextField
                    Expanded(
                      child: TextField(
                        controller: _statusController,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0), // Spacing

                    // Search Icon Button
                    Card(
                      color: const Color.fromARGB(255, 238, 240, 241),
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // Add search functionality here
                        },
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
            ),
          ),
        ),

        // Toggle Filter Button
        Card(
          color: const Color.fromARGB(255, 240, 234, 235),
          shape: const CircleBorder(),
          child: IconButton(
            icon: showFilter
                ? const Icon(Icons.filter_alt_off)
                : const Icon(Icons.filter_alt),
            onPressed: () {
              setState(() {
                showFilter = !showFilter;
              });
            },
            tooltip: showFilter ? 'Hide filter' : 'Show filter',
          ),
        ),

        // Pagination
        Pagination(
          totalItems: 18412,
          initialPageSize: 30,
          onPageChange: (page, pageSize) {
            print('Page: $page, Page Size: $pageSize');
            // Fetch new data based on `page` and `pageSize`
          },
        ),
      ],
    );
  }
}
