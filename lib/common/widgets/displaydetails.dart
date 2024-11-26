import 'package:flutter/material.dart';
import 'package:tenderboard/common/themes/app_theme.dart';

class DisplayDetails extends StatefulWidget {
  final List<String> headers;
  final List<String> data;
  final List<Map<String, dynamic>> details;
  final bool expandable;
  final Function(int)? onTap;
  final Function()? onLongPress;
  final int isSelected;

  const DisplayDetails({
    super.key,
    required this.headers,
    required this.data,
    required this.details,
    this.expandable = true,
    this.onTap,
    this.onLongPress,
    int? selectedNo,
  }) : isSelected = selectedNo ?? -1;

  @override
  _DisplayDetailsState createState() => _DisplayDetailsState();
}

class _DisplayDetailsState extends State<DisplayDetails> {
  Set<int> expandedRows = {}; // Track which rows are expanded

  @override
  void initState() {
    super.initState();
    // Expand all rows if expandable is false
    if (!widget.expandable) {
      expandedRows =
          Set<int>.from(List.generate(widget.details.length, (index) => index));
    }
  }

  @override
  Widget build(BuildContext context) {
    int maxColumns = 8;
    int headerColumns = widget.headers.length <= maxColumns
        ? widget.headers.length
        : maxColumns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row with colorful background
        headerColumns != 1
            ? Container(
                decoration: const BoxDecoration(
                  color: AppTheme.displayHeaderColor,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: widget.headers.take(headerColumns).map((header) {
                    return Expanded(
                      child: Text(
                        header,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),
              )
            : const SizedBox.shrink(),
        headerColumns != 1
            ? const SizedBox(height: 10)
            : const SizedBox.shrink(),

        // Data Rows
        Expanded(
          child: ListView.builder(
            itemCount: widget.details.length,
            itemBuilder: (context, int rowIndex) {
              final row = widget.details[rowIndex];
              bool hasMoreThanMaxColumns = widget.data.length > maxColumns;

              return InkWell(
                onTap: () {
                  if (widget.onTap != null) {
                    widget.onTap!(row['id'] as int);
                  }
                },
                onLongPress: () {
                  if (widget.onLongPress != null) {
                    widget.onLongPress!();
                  }
                }, // Trigger onTap if it’s not null
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main row with full background
                    Container(
                      color: widget.isSelected != row['id'] as int
                          ? (row['id'] as int) % 2 == 0
                              ? Colors.grey[100]
                              : Colors.grey[200]
                          : const Color.fromARGB(255, 185, 241, 190),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: widget.data.take(headerColumns).map((key) {
                          return Expanded(
                            child: Text(
                              row[key]?.toString() ?? '',
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Divider and Expand/Collapse Icon
                    if (hasMoreThanMaxColumns && widget.expandable)
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1.5,
                              color: Colors.grey[300],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              expandedRows.contains(rowIndex)
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                if (expandedRows.contains(rowIndex)) {
                                  expandedRows.remove(rowIndex);
                                } else {
                                  expandedRows.add(rowIndex);
                                }
                              });
                            },
                          ),
                        ],
                      ),

                    // Expanded Section with gradient background
                    if (expandedRows.contains(rowIndex))
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[50]!, Colors.blue[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 8),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: _buildExpandedRows(row, headerColumns),
                        ),
                      ),
                    if (expandedRows.contains(rowIndex))
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Divider(),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Build rows for expanded columns with unified gradient background
  List<Widget> _buildExpandedRows(Map<String, dynamic> row, int headerColumns) {
    int maxItemsPerRow = 4;
    List<Widget> expandedRows = [];
    List<String> extraDataKeys = widget.data.skip(headerColumns).toList();

    for (int i = 0; i < extraDataKeys.length; i += maxItemsPerRow) {
      int end = (i + maxItemsPerRow) < extraDataKeys.length
          ? (i + maxItemsPerRow)
          : extraDataKeys.length;

      expandedRows.add(
        Row(
          children: extraDataKeys.sublist(i, end).map((key) {
            int headerIndex = widget.data.indexOf(key);
            String header = widget.headers[headerIndex];

            return Expanded(
              child: Column(
                children: [
                  Text(
                    header,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    row[key]?.toString() ?? '',
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    }

    return expandedRows;
  }
}
