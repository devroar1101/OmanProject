import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/load_letter_document.dart';
import 'package:tenderboard/office/letter/screens/letter_form.dart';
import 'package:tenderboard/office/letter_summary/screens/letter_routing.dart';

class LetterSummary extends StatefulWidget {
  final String letterObjectId;
  const LetterSummary(this.letterObjectId, {super.key});

  @override
  _LetterSummaryState createState() => _LetterSummaryState();
}

class _LetterSummaryState extends State<LetterSummary> {
  String _selectedTab = "Details";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side - Navigation Tabs and Content
            Flexible(
              flex: 3,
              child: Container(
                color: Colors.grey[200],
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
                        ],
                      ),
                    ),
                    // Content Area
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 12),
                        child: _buildContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Right Side - Document Viewer or Additional Content
            Flexible(
              flex: 2,
              child: Container(
                color: Colors.grey[200],
                child: Center(
                    child: Container(
                  color: Colors.grey[200], // Optional background color
                  child: LoadLetterDocument(objectId: widget.letterObjectId),
                )),
              ),
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
        setState(() {
          _selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
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
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTab) {
      case "Details":
        return LetterForm(
          screenName: 'LetterSummary',
          letterObjectId: widget.letterObjectId,
        );
      case "Routing":
        return const RoutingHistory();
      default:
        return const Center(child: Text("Invalid Tab"));
    }
  }
}
