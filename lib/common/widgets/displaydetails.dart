import 'package:flutter/material.dart';
import 'package:tenderboard/common/themes/app_theme.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';

// ignore: must_be_immutable
class DisplayDetails extends StatefulWidget {
  final List<String> headers;
  final List<String> data;
  final List<Map<String, dynamic>> details;
  final List<Map<String, dynamic>>? iconButtons; // Actions with icons
  final bool expandable;
  final Function(int)? onTap;
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
        Container(
          decoration: const BoxDecoration(
            color: AppTheme.displayHeaderColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: widget.headers.take(headerColumns).map((header) {
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
            }).toList(),
          ),
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
              bool showSpeedDial =
                  id != 0 && widget.iconButtons != null && id != null;

              return Stack(
                children: [
                  // Main Row
                  InkWell(
                    onTap: () {
                      if (widget.onTap != null) {
                        widget.onTap!(row[widget.detailKey]);
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
                          ? const Color.fromARGB(255, 185, 241, 190)
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
                          ...?widget.iconButtons?.map((iconButton) {
                            return Card(
                              color: const Color.fromARGB(255, 238, 240, 241),
                              shape: const CircleBorder(),
                              child: IconButton(
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
