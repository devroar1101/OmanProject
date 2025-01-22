import 'package:flutter/material.dart';

import 'package:tenderboard/office/search_screens/screens/list_page.dart';

class ListScreen extends StatefulWidget {
  final String screenName;
  const ListScreen({required this.screenName, super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String _selectedTab = "Letter";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (widget.screenName == 'Inbox' || widget.screenName == 'Outbox')
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildTab("Letter"),
                  const SizedBox(width: 5),
                  _buildTab("eJob"),
                  const SizedBox(width: 5),
                  _buildTab("CC"),
                  const SizedBox(width: 5),
                  _buildTab("Task"),
                ],
              ),
            // Content Area
            Expanded(
              child: _buildContent(widget.screenName),
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
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(String screenName) {
    switch (_selectedTab) {
      case "Letter":
        return ListPage(
          screenName: screenName,
        );
      case "eJob":
        return Center(child: Text("eJob Content for "));
      case "CC":
        return Center(child: Text("CC Content for "));
      case "Task":
        return Center(child: Text("Task Content for "));
      default:
        return ListPage(
          screenName: screenName,
          key: ValueKey(screenName),
        );
    }
  }
}
