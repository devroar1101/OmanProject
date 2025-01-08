import 'package:flutter/material.dart';

import 'package:tenderboard/common/widgets/load_letter_document.dart';
import 'package:tenderboard/office/letter/screens/letter_form.dart';
import 'package:tenderboard/office/letter_summary/screens/actions.dart';
import 'package:tenderboard/office/letter_summary/screens/letter_routing.dart';

class LetterSummary extends StatefulWidget {
  final String letterObjectId;
  const LetterSummary(this.letterObjectId, {super.key});

  @override
  _LetterSummaryState createState() => _LetterSummaryState();
}

class _LetterSummaryState extends State<LetterSummary> {
  String _selectedTab = "Details";
  bool needHelper = false;
  String _helperTab = "Letter";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              label: const Text(
                'Back',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
        automaticallyImplyLeading: false, // Disable default back button
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 10, 31, 61),
                Color.fromARGB(133, 10, 31, 61)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        'Summary',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side - Navigation Tabs and Content
            Flexible(
              flex: 3,
              child: Container(
                child: Column(
                  children: [
                    // Tabs
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildTab("Details"),
                          const SizedBox(
                            width: 5,
                          ),
                          _buildTab("Routing"),
                          const SizedBox(
                            width: 5,
                          ),
                          _buildTab("Attachment"),
                          const SizedBox(
                            width: 5,
                          ),
                          _buildTab("Link Document"),
                          const SizedBox(
                            width: 5,
                          ),
                          _buildTab("Additional Info"),
                          const SizedBox(
                            width: 5,
                          ),
                          _buildTab("Action"),
                        ],
                      ),
                    ),
                    // Content Area
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 12),
                        child: _buildContent(
                            Directionality.of(context) == TextDirection.rtl),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Right Side - Document Viewer or Additional Content
            Flexible(
              flex: 2,
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  child: Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Container(
                        color: Colors.grey[200], // Optional background color
                        child: _buildHelperContent(
                            Directionality.of(context) == TextDirection.rtl),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label) {
    final isSelected = _selectedTab == label;
    return GestureDetector(
      onTap: () {
        if (!needHelper) {
          _selectedTab = label;
        } else {
          _helperTab = label == 'Action' ? 'Letter' : label;
        }

        setState(() {
          if (label == 'Action') {
            if (needHelper) {
              _helperTab = 'Letter';
              _selectedTab = 'Details';
            }
            needHelper = !needHelper;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected
              ? _selectedTab == 'Action'
                  ? Colors.amberAccent
                  : Colors.blue
              : Colors.grey[300],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          _selectedTab == 'Action' && label == 'Action' ? 'Cancel' : label,
          style: TextStyle(
              color: isSelected
                  ? _selectedTab == 'Action'
                      ? Colors.black
                      : Colors.white
                  : Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildContent(bool isRtl) {
    switch (_selectedTab) {
      case "Details":
        return LetterForm(
          screenName: 'LetterSummary',
          letterObjectId: widget.letterObjectId,
        );
      case "Routing":
        return RoutingHistory(
          objectId: widget.letterObjectId,
        );
      case "Action":
        return ActionScreen(
          currentuser: 1,
          objectId: widget.letterObjectId,
          type: 'Letter',
        );

      default:
        return const Center(child: Text("Invalid Tab"));
    }
  }

  Widget _buildHelperContent(bool isRtl) {
    switch (_helperTab) {
      case "Details":
        return LetterForm(
          screenName: 'LetterSummary',
          letterObjectId: widget.letterObjectId,
        );
      case "Routing":
        return RoutingHistory(
          objectId: widget.letterObjectId,
        );

      case "Letter":
        return LoadLetterDocument(objectId: widget.letterObjectId);
      default:
        return const Center(child: Text("Invalid Tab"));
    }
  }
}
