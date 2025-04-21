import 'package:flutter/material.dart';

import 'package:tenderboard/common/widgets/load_letter_document.dart';
import 'package:tenderboard/office/letter/screens/letter_form.dart';
import 'package:tenderboard/office/letter_summary/screens/actions.dart';
import 'package:tenderboard/office/letter_summary/screens/letter_routing.dart';
import 'package:tenderboard/office/letter_summary/screens/widgets/summary_details.dart';

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
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              label: const Text(
                'Back',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
            ),
          )
        ],
        automaticallyImplyLeading: false,
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
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildTab("Details"),
              _buildTab("Attachment"),
              _buildTab("Link Document"),
              _buildTab("Additional Info"),
              _buildTab("Action"),
            ],
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _buildContent(
                      Directionality.of(context) == TextDirection.rtl),
                ),
              ),
            ),
            // Right Side
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 300),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _buildHelperContent(
                      Directionality.of(context) == TextDirection.rtl),
                ),
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
          if (!needHelper) {
            _selectedTab = label;
          } else {
            _helperTab = label == 'Action' ? 'Letter' : label;
          }

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
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected
              ? (_selectedTab == 'Action' ? Colors.amberAccent : Colors.blue)
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  )
                ]
              : [],
        ),
        child: Text(
          (_selectedTab == 'Action' && label == 'Action') ? 'Cancel' : label,
          style: TextStyle(
            color: isSelected
                ? (_selectedTab == 'Action' ? Colors.black : Colors.white)
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isRtl) {
    switch (_selectedTab) {
      case "Details":
        return SummaryDetails(
          letterObjectId: widget.letterObjectId,
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
        return LoadLetterDocument(
          objectId: widget.letterObjectId,
        );
      default:
        return const Center(child: Text("Invalid Tab"));
    }
  }
}
