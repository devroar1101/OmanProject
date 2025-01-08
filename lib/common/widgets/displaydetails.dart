import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:tenderboard/common/themes/app_theme.dart';
import 'package:tenderboard/common/utilities/color_picker.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';
import 'dart:html' as html;

// ignore: must_be_immutable
class DisplayDetails extends StatefulWidget {
  final List<String> headers;
  final List<String> data;
  final List<Map<String, dynamic>> details;
  final List<Map<String, dynamic>>? iconButtons; // Actions with icons
  final bool expandable;
  final Function(dynamic)? onTap;
  final Function()? onLongPress;
  String isSelected;
  final String detailKey;

  DisplayDetails({
    super.key,
    required this.headers,
    required this.data,
    required this.details,
    this.iconButtons,
    this.expandable = true,
    this.onTap,
    this.onLongPress,
    String? selected,
    required this.detailKey,
  }) : isSelected = selected ?? '';

  @override
  _DisplayDetailsState createState() => _DisplayDetailsState();
}

class _DisplayDetailsState extends State<DisplayDetails>
    with SingleTickerProviderStateMixin {
  int? activeRowIndex; // Active row index for showing the speed dial
  bool isSpeedDialExpanded = false;

  @override
  Widget build(BuildContext context) {
    int maxColumns = 8;
    int headerColumns = widget.headers.length <= maxColumns
        ? widget.headers.length
        : maxColumns;
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppTheme.displayHeaderColor,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  ...widget.headers.take(headerColumns).map((header) {
                    return Expanded(
                      child: Text(
                        getTranslation(header),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Export Button
            Positioned(
              top: 3,
              left: isRtl ? 4 : null,
              right: isRtl ? null : 4,
              child: IconButton(
                icon: const Icon(
                  Icons.download_for_offline_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Add your export functionality here
                  exportData(
                      context, widget.headers, widget.data, widget.details);
                },
                tooltip: 'Export Data',
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),

        // Data Rows
        Expanded(
          child: ListView.builder(
            itemCount: widget.details.length,
            itemBuilder: (context, int rowIndex) {
              final row = widget.details[rowIndex];
              final id = row[widget.detailKey];

              // Check if the row meets the conditions for speed dial
              bool showSpeedDial = widget.iconButtons != null;

              return Stack(
                children: [
                  // Main Row
                  InkWell(
                    onTap: () {
                      if (widget.onTap != null) {
                        widget.onTap!(id);
                      }
                      setState(() {
                        activeRowIndex = null;
                        isSpeedDialExpanded = false;
                        widget.isSelected = id.toString();
                      });
                    },
                    onLongPress: () {
                      if (widget.onLongPress != null) {
                        widget.onLongPress!();
                      }
                    },
                    child: Container(
                      color: widget.isSelected.toString() ==
                              row[widget.detailKey].toString()
                          ? const Color.fromARGB(123, 142, 174, 155)
                          : rowIndex % 2 == 0
                              ? Colors.grey[100]
                              : Colors.grey[200],
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ...widget.data.take(headerColumns).map((key) {
                            return Expanded(
                              child: Text(
                                row[key]?.toString() ?? '',
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }),

                          // Show the vertical speed dial icon
                          if (showSpeedDial)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  activeRowIndex = activeRowIndex == rowIndex
                                      ? null
                                      : rowIndex;
                                  isSpeedDialExpanded = activeRowIndex != null;
                                  widget.isSelected = id.toString();
                                });
                              },
                              child: Icon(
                                color: AppTheme.textColor,
                                isSpeedDialExpanded &&
                                        activeRowIndex == rowIndex
                                    ? Icons.close
                                    : Icons.more_vert,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Speed Dial Overlay (Icons in Row)
                  if (isSpeedDialExpanded &&
                      activeRowIndex == rowIndex &&
                      widget.isSelected.toString() == id.toString())
                    Positioned(
                      right: isRtl ? null : 16,
                      left: isRtl ? 16 : null,
                      top: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...?widget.iconButtons?.map((
                            iconButton,
                          ) {
                            return Card(
                              color: const Color.fromARGB(255, 238, 240, 241),
                              shape: const CircleBorder(),
                              child: IconButton(
                                color: ColorPicker.formIconColor,
                                icon: Icon(iconButton["button"]),
                                onPressed: () {
                                  iconButton["function"]!(id);
                                  setState(() {
                                    isSpeedDialExpanded = false;
                                    activeRowIndex = null;
                                  });
                                },
                                tooltip: iconButton["tooltip"],
                              ),
                            );
                          }),
                          const SizedBox(
                            width: 18,
                          )
                        ],
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
}

Future<void> exportData(BuildContext context, List<String> headers,
    List<String> data, List<Map<String, dynamic>> details) async {
  try {
    // Prepare the CSV rows
    List<List<dynamic>> rows = [];

    // Add headers as the first row
    rows.add(headers);

    // Map each detail (row) to the corresponding data
    for (var row in details) {
      List<dynamic> rowData = [];

      // Loop through each key in data and extract corresponding value from row
      for (var key in data) {
        var value = row[key];

        // Add the value to the rowData (if null, use empty string)
        rowData.add(value ?? '');
      }

      rows.add(rowData);
    }

    // Convert the list of rows to CSV string
    String csvData = const ListToCsvConverter().convert(rows);

    // Add BOM for UTF-8 encoding (important for non-Latin characters like Arabic)
    String utf8CsvData = "\u{FEFF}$csvData";

    // Create a Blob from the CSV data (web-specific)
    final blob = html.Blob([utf8CsvData], 'text/csv');

    // Create a URL for the Blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and trigger the download
    html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'exported_data.csv' // The file name for the downloaded CSV
      ..click();

    // Clean up the URL after the download is triggered
    html.Url.revokeObjectUrl(url);

    // Optionally, show a snackbar or a message that the file is being downloaded
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CSV file is being downloaded')));
  } catch (e) {
    print("Error saving CSV file: $e");
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate CSV file')));
  }
}
