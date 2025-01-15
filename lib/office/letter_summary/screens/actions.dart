import 'package:flutter/material.dart';
import 'package:tenderboard/office/letter_summary/screens/widgets/summary_assign.dart';
import 'package:tenderboard/office/letter_summary/screens/widgets/summary_close.dart';
import 'package:tenderboard/office/letter_summary/screens/widgets/summary_followUp.dart';
import 'package:tenderboard/office/letter_summary/screens/widgets/summary_reply.dart';
import 'package:tenderboard/office/letter_summary/screens/widgets/summary_suspent.dart';

class ActionScreen extends StatefulWidget {
  const ActionScreen(
      {super.key,
      required this.objectId,
      required this.currentuser,
      required this.type});

  final String objectId;
  final int currentuser;
  final String type;

  @override
  _ActionScreenState createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {
  String _selectedTab = "Assign";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
            child: Wrap(
              alignment: WrapAlignment.end,
              children: [
                _buildCardButton("Assign"),
                _buildCardButton("Replay"),
                _buildCardButton("Follow Up"),
                _buildCardButton("Close"),
                _buildCardButton("Suspend"),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Expanded(child: _buildTabContent())),
          ),
        ],
      ),
    );
  }

  Widget _buildCardButton(String label) {
    final bool isSelected = _selectedTab == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
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
                    blurRadius: 4,
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

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case "Assign":
        return JobAssignForm(letterObjectId: widget.objectId);
      case "Replay":
        return const ReplyJobForm();
      case "Follow Up":
        return FollowUpJobsForm();
      case "Close":
        return const CloseJobForm();
      case "Suspend":
        return const SuspendJobForm();
      default:
        return JobAssignForm(letterObjectId: widget.objectId);
    }
  }
}
