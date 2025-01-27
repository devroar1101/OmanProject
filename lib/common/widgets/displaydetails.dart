import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tenderboard/common/themes/app_theme.dart';
import 'package:tenderboard/common/utilities/color_picker.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';
import 'dart:html' as html;

// ignore: must_be_immutable
class DisplayDetails extends StatefulWidget {
  final List<String> headers;
  final List<String> data;
  final String? reportName;
  final List<Map<String, dynamic>> details;
  List<Map<String, dynamic>>? reportContent;
  final List<Map<String, dynamic>>? iconButtons; // Actions with icons
  final bool expandable;
  final Function(dynamic)? onTap;
  final Function(dynamic)? onLongPress;
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
    this.reportContent,
    this.reportName,
    required this.detailKey,
  }) : isSelected = selected ?? '';

  @override
  _DisplayDetailsState createState() => _DisplayDetailsState();
}

class _DisplayDetailsState extends State<DisplayDetails>
    with SingleTickerProviderStateMixin {
  int? activeRowIndex; // Active row index for showing the speed dial
  bool isSpeedDialExpanded = false;
  bool isProcessing = false; // Flag to track if processing is ongoing

//Export methods
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

  // Modify exportPdf to use state variable for isProcessing
  Future<void> exportPdf(BuildContext context, List<String> headers,
      List<String> data, List<Map<String, dynamic>> details) async {
    try {
      // Create a background isolate to handle PDF creation and downloading
      final result = await _generatePdfInBackground({
        'headers': headers,
        'data': data,
        'details': details,
      });

      // Export PDF as a downloadable file
      final pdfBytes = result['pdfBytes'] as List<int>;
      final url = result['url'] as String;

      html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = 'exported_data.pdf'
        ..click();

      html.Url.revokeObjectUrl(url);

      // Show success message on the main UI thread
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF file is being downloaded')),
      );
    } catch (e) {
      print("Error generating PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate PDF file')),
      );
    } finally {
      setState(() {
        isProcessing = false; // Reset the processing flag after operation
      });
    }
  }

  // Background isolate to generate PDF and return download URL
  Future<Map<String, dynamic>> _generatePdfInBackground(
      Map<String, dynamic> args) async {
    // Create a separate isolate to handle the PDF generation
    final result = await compute(generatePdf, args);
    return result;
  }

  // Background task to generate PDF
  Future<Map<String, dynamic>> generatePdf(Map<String, dynamic> args) async {
    final headers = args['headers'] as List<String>;
    final data = args['data'] as List<String>;
    final details = args['details'] as List<Map<String, dynamic>>;

    final pdf = pw.Document();

    // Load Kufam font
    final regularFontBytes =
        await rootBundle.load('assets/fonts/Kufam-Regular.ttf');
    final boldFontBytes = await rootBundle.load('assets/fonts/Kufam-Bold.ttf');

    // Use ByteData directly to load fonts
    final regularFont = pw.Font.ttf(regularFontBytes);
    final boldFont = pw.Font.ttf(boldFontBytes);

    // Load the logo
    final logoBytes = await rootBundle.load('assets/gstb_logo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    // Create PDF content
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Add Logo
              pw.Image(logoImage, height: 100),
              pw.SizedBox(height: 20),

              // Add Headers
              pw.Row(
                children: headers.map((header) {
                  return pw.Expanded(
                    child: pw.Text(
                      header,
                      style: pw.TextStyle(
                        fontSize: 12,
                        font: boldFont,
                      ),
                    ),
                  );
                }).toList(),
              ),
              pw.Divider(),

              // Add Data Rows
              ...details.map((row) {
                return pw.Row(
                  children: data.map((key) {
                    return pw.Expanded(
                      child: pw.Text(
                        row[key]?.toString() ?? '',
                        style: pw.TextStyle(
                          fontSize: 10,
                          font: regularFont,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    // Save PDF
    final pdfBytes = await pdf.save();

    // Prepare file download URL
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    return {
      'pdfBytes': pdfBytes,
      'url': url,
    };
  }

  @override
  Widget build(BuildContext context) {
    int maxColumns = 8;
    int headerColumns = widget.headers.length <= maxColumns
        ? widget.headers.length
        : maxColumns;
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppTheme.displayHeaderColor,
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
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
            Positioned(
              top: 3,
              left: isRtl ? 4 : null,
              right: isRtl ? null : 4,
              child: !isProcessing
                  ? Row(
                      children: [
                        // Export CSV Button
                        IconButton(
                          icon: const Icon(
                            Icons.download_for_offline_outlined,
                            color: Colors.white,
                          ),
                          onPressed: isProcessing
                              ? null
                              : () {
                                  exportData(context, widget.headers,
                                      widget.data, widget.details);
                                },
                          tooltip: 'Export as CSV',
                        ),
                        // Export PDF Button
                        IconButton(
                          icon: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.white,
                          ),
                          onPressed: isProcessing
                              ? null
                              : () async {
                                  setState(() {
                                    isProcessing =
                                        true; // Set the processing flag to true
                                  });
                                  await exportPdf(context, widget.headers,
                                      widget.data, widget.details);
                                },
                          tooltip: 'Export as PDF',
                        ),
                      ],
                    )
                  : const CircularProgressIndicator(),
            ),
          ],
        ),
        const SizedBox(height: 2),
        if (widget.details.isNotEmpty)
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
                          widget.onLongPress!(id);
                        }
                      },
                      child: Container(
                        color: widget.isSelected.toString() ==
                                row[widget.detailKey].toString()
                            ? const Color.fromARGB(123, 142, 174, 155)
                            : rowIndex % 2 == 0
                                ? Colors.grey[100]
                                : Colors.grey[200],
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                      activeRowIndex =
                                          activeRowIndex == rowIndex
                                              ? null
                                              : rowIndex;
                                      isSpeedDialExpanded =
                                          activeRowIndex != null;
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
                              const SizedBox(
                                width: 4,
                              )
                            ],
                          ),
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
                          children: [
                            ...?widget.iconButtons?.map((iconButton) {
                              return IconButton(
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
                                iconSize: 20,
                              );
                            }),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          )
        else
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 50,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  '"No data available',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
