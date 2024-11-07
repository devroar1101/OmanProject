import 'package:flutter/material.dart';

class DisplayDetails extends StatefulWidget {
  final List<String> headers;
  final List<String> data;
  final List<Map<String, dynamic>> details;
  final bool expandable;

  const DisplayDetails({
    super.key,
    required this.headers,
    required this.data,
    required this.details,
    this.expandable = false, // Default is false to expand by default
  });

  @override
  _DisplayDetailsState createState() => _DisplayDetailsState();
}

class _DisplayDetailsState extends State<DisplayDetails> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    int maxColumns = 8;
    int headerColumns = widget.headers.length <= maxColumns
        ? widget.headers.length
        : maxColumns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Static Header Row (only first 8 columns)
        Row(
          children: widget.headers.take(headerColumns).map((header) {
            return Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  header,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        ),

        const Divider(),

        // Data Rows with Scroll
        Expanded(
          child: ListView.builder(
            itemCount: widget.details.length,
            itemBuilder: (context, rowIndex) {
              final row = widget.details[rowIndex];

              // Check if there are more than 8 columns of data
              bool hasMoreThanMaxColumns = widget.data.length > maxColumns;

              return Column(
                children: [
                  // Display first 8 columns (visible columns)
                  Row(
                    children: widget.data.take(headerColumns).map((key) {
                      return Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(row[key]?.toString() ?? ''),
                        ),
                      );
                    }).toList(),
                  ),

                  // Display arrow icon after the last visible column (8th column)
                  if (hasMoreThanMaxColumns)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child:
                                Container(), // Empty container to push icon to the end
                          ),
                          IconButton(
                            icon: Icon(
                              isExpanded
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                            ),
                            onPressed: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                  // Divider will appear after expansion
                  if (isExpanded) const Divider(),

                  // Display extra columns (columns 9 and beyond)
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        children: _buildExpandedRows(row, headerColumns),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // Method to build rows for expanded columns (columns 9 and beyond)
  List<Widget> _buildExpandedRows(Map<String, dynamic> row, int headerColumns) {
    int maxItemsPerRow = 8; // You want 8 per row
    List<Widget> expandedRows = [];
    List<String> extraData = widget.data.skip(headerColumns).toList();

    // Calculate how many rows are needed to fit the extra columns
    for (int i = 0; i < extraData.length; i += maxItemsPerRow) {
      int end = (i + maxItemsPerRow) < extraData.length
          ? (i + maxItemsPerRow)
          : extraData.length;
      expandedRows.add(
        Row(
          children: extraData.sublist(i, end).map((key) {
            return Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(row[key]?.toString() ?? ''),
              ),
            );
          }).toList(),
        ),
      );
    }

    return expandedRows;
  }
}
