import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';

class ListSearchForm extends StatefulWidget {
  final int totalCount;
  final Function(String) search;
  final Function() reset;
  final Function(int, int) updatepagenation;
  final int pagenumber;
  final int pageSize;
  const ListSearchForm(
      {required this.pageSize,
      required this.pagenumber,
      required this.totalCount,
      required this.updatepagenation,
      required this.search,
      required this.reset,
      super.key});

  @override
  _ListSearchFormState createState() => _ListSearchFormState();
}

class _ListSearchFormState extends State<ListSearchForm> {
  final TextEditingController _searchForController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  bool showFilter = false;

  void _resetFields() {
    _searchForController.clear();
    _statusController.clear();
    widget.reset();
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
                          widget.search(_searchForController.text);
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
          totalItems: widget.totalCount,
          initialPageSize: widget.pageSize,
          onPageChange: widget.updatepagenation,
        ),
      ],
    );
  }
}
