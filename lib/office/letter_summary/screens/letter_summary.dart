import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/load_letter_document.dart';
import 'package:tenderboard/common/widgets/scanner.dart';
import 'package:tenderboard/office/letter/model/letter.dart';
import 'package:tenderboard/office/letter/model/letter_action.dart';
import 'package:tenderboard/office/letter/model/letter_attachment.dart';
import 'package:tenderboard/office/letter/screens/letter_form.dart';
import 'package:tenderboard/office/letter_summary/screens/letter_routing.dart';
import 'package:tenderboard/office/letter_summary/screens/widgets/summary_assign.dart';
import 'package:tenderboard/office/letter_summary/screens/widgets/summary_close.dart';
import 'package:tenderboard/office/letter_summary/screens/widgets/summary_followUp.dart';
import 'package:tenderboard/office/letter_summary/screens/widgets/summary_reply.dart';
import 'package:tenderboard/office/letter_summary/screens/widgets/summary_suspent.dart';

class LetterSummary extends StatefulWidget {
  final String letterObjectId;
  const LetterSummary(this.letterObjectId, {super.key});

  @override
  _LetterSummaryState createState() => _LetterSummaryState();
}

class _LetterSummaryState extends State<LetterSummary> {
  String _selectedTab = "Details";

  late Letter letter;
  late LetterAction letterAction;
  late LetterAttachment letterAttachment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Details";
                    }),
                    child: const Text("Details"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Routing";
                    }),
                    child: const Text("Routing"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Attachment";
                    }),
                    child: const Text("Attachment"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Assign Job";
                    }),
                    child: const Text("Assign Job"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Follo_UP Job";
                    }),
                    child: const Text("Follo_UP Job"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Reply Job";
                    }),
                    child: const Text("Reply Job"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Suspent Job";
                    }),
                    child: const Text("Suspent Job"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Close Job";
                    }),
                    child: const Text("Close Job"),
                  ),
                ],
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Row(
        children: [
          // Left Side - Conditional Content
          Expanded(
            flex: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Card(elevation: 2, child: _buildContent()),
            ),
          ),

          // Right Side - Empty Space
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200], // Optional background color
              child: LoadLetterDocument(
                  objectId: widget.letterObjectId), // Your scanner widget here
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTab) {
      case "Details":
        return LetterForm(
          letterObjectId: widget.letterObjectId,
        );
      case "Routing":
        return const RoutingHistory();
      case "Attachment":
        return const Center(child: Text("Attachment Content Placeholder"));
      case "Assign Job":
        return const JobAssignForm();
      case "Follo_UP Job":
        return FollowUpJobsForm(); // Display JobAssignForm widget here
      case "Reply Job":
        return const ReplyJobForm(); // Display JobAssignForm widget here
      case "Suspent Job":
        return const SuspendJobForm(); // Display JobAssignForm widget here
      case "Close Job":
        return const CloseJobForm(); // Display JobAssignForm widget here
      default:
        return const Center(child: Text("Invalid Tab"));
    }
  }
}
