import 'package:flutter/material.dart';
import 'package:tenderboard/common/themes/app_theme.dart';

class DisplayDetails extends StatefulWidget {
  final List<String> headers;
  final List<String> data;
  final List<Map<String, dynamic>> details;
  final List<Map<String, dynamic>>? iconButtons; // List of actions with icons
  final bool expandable;
  final Function(int)? onTap;
  final Function()? onLongPress;
  final String isSelected;
  final String detailKey;

  const DisplayDetails({
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

class _DisplayDetailsState extends State<DisplayDetails> {
  Set<int> expandedRows = {};
  int? activeRowIndex; // Track the active row for showing the drawer

  @override
  void initState() {
    super.initState();
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

    return Stack(
      children: [
        Column(
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
            ),
            const SizedBox(height: 10),

            // Data Rows
            Expanded(
              child: ListView.builder(
                itemCount: widget.details.length,
                itemBuilder: (context, int rowIndex) {
                  final row = widget.details[rowIndex];
                  bool hasMoreThanMaxColumns = widget.data.length > maxColumns;

                  return Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          if (widget.onTap != null) {
                            widget.onTap!(row[widget.detailKey]);
                          }
                        },
                        onLongPress: () {
                          if (widget.onLongPress != null) {
                            widget.onLongPress!();
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main row
                            Container(
                              color: widget.isSelected != row[widget.detailKey]
                                  ? rowIndex % 2 == 0
                                      ? Colors.grey[100]
                                      : Colors.grey[200]
                                  : const Color.fromARGB(255, 185, 241, 190),
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
                                  }).toList(),
                                  if (row['id'] != 0 &&
                                      widget.iconButtons != null &&
                                      widget.iconButtons!
                                          .isNotEmpty) // Show icon only if id = 0
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () {
                                        setState(() {
                                          activeRowIndex =
                                              activeRowIndex == rowIndex
                                                  ? null
                                                  : rowIndex;
                                        });
                                      },
                                    ),
                                ],
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
                          ],
                        ),
                      ),

                      // Drawer-like overlay for icon buttons
                      if (activeRowIndex == rowIndex)
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                activeRowIndex = null;
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Spacer(),
                                  Container(
                                    width: 300,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue[50]!,
                                          Colors.blue[100]!
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: widget.iconButtons!
                                          .map(
                                            (iconButton) => IconButton(
                                              icon: Icon(
                                                iconButton["button"],
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                iconButton["function"]!(
                                                    rowIndex);
                                                setState(() {
                                                  activeRowIndex = null;
                                                });
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
