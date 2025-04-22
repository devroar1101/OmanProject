import 'package:flutter/material.dart';
import 'list_page.dart';

class ListScreen extends StatefulWidget {
  final String screenName;
  const ListScreen({required this.screenName, Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String _selectedTab = "Letter";

  @override
  void didUpdateWidget(covariant ListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.screenName != widget.screenName) {
      // Reset selected tab and trigger rebuild if the page changes
      setState(() {
        _selectedTab = "Letter";
      });
    }
  }

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
            Expanded(
              child: _buildContent(),
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

  Widget _buildContent() {
    switch (_selectedTab) {
      case "Letter":
        return ListPage(
          key: ValueKey('${widget.screenName}_Letter'),
          screenName: widget.screenName,
        );
      case "eJob":
        return Center(child: Text("eJob Content for ${widget.screenName}"));
      case "CC":
        return Center(child: Text("CC Content for ${widget.screenName}"));
      case "Task":
        return Center(child: Text("Task Content for ${widget.screenName}"));
      default:
        return ListPage(
          key: ValueKey('${widget.screenName}_Default'),
          screenName: widget.screenName,
        );
    }
  }
}
