import 'dart:html' as html; // For file download on web
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:tenderboard/common/model/global_enum.dart';
import 'package:tenderboard/office/letter/model/letter_action.dart';

class RoutingHistory extends StatelessWidget {
  const RoutingHistory({super.key});

  // Method to convert data to CSV and trigger download for web
  Future<void> downloadDataAsCsv(BuildContext context) async {
    try {
      // Prepare the data to be exported
      List<List<dynamic>> rows = [
        [
          "LetterActionId",
          "FromUserId",
          "ActionId",
          "ToUserId",
          "ClassificationId",
          "PriorityId",
          "Timestamp",
          "Comments"
        ],
        [
          1,
          101,
          1,
          102,
          1,
          1,
          DateTime.now().toIso8601String(),
          "Assigned to User 102"
        ],
        [
          2,
          103,
          2,
          104,
          2,
          2,
          DateTime.now().add(Duration(hours: 1)).toIso8601String(),
          "Replied to User 104"
        ],
        [
          3,
          105,
          3,
          106,
          3,
          3,
          DateTime.now().add(Duration(hours: 2)).toIso8601String(),
          "Forwarded to User 106"
        ],
      ];

      // Convert data to CSV
      String csvData = const ListToCsvConverter().convert(rows);

      // Create a Blob from the CSV data (web-specific)
      final blob = html.Blob([csvData], 'text/csv');

      // Create a URL for the Blob
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create an anchor element and trigger the download
      html.AnchorElement(href: url)
        ..setAttribute('download', 'letter_actions.csv')
        ..click();
      // Clean up the URL after the download is triggered
      html.Url.revokeObjectUrl(url);

      // Optionally, show a snackbar or a message that the file is being downloaded
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CSV file is being downloaded')));
    } catch (e) {
      print("Error saving CSV file: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to generate CSV file')));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<LetterAction> letterActions = [
      LetterAction(
        letterActionId: 1,
        fromUserId: 101,
        actionId: 1,
        toUserId: 102,
        classificationId: 1,
        priorityId: 1,
        timeStamp: DateTime.now(),
        comments: "Assigned to User 102",
      ),
      LetterAction(
        letterActionId: 2,
        fromUserId: 103,
        actionId: 2,
        toUserId: 104,
        classificationId: 2,
        priorityId: 2,
        timeStamp: DateTime.now().add(Duration(hours: 1)),
        comments: "Replied to User 104",
      ),
      LetterAction(
        letterActionId: 3,
        fromUserId: 105,
        actionId: 3,
        toUserId: 106,
        classificationId: 3,
        priorityId: 3,
        timeStamp: DateTime.now().add(Duration(hours: 2)),
        comments:
            "Effective performance management forms the backbone of a successful organization. A critical element of this process is the provision of feedback during performance reviews, which directly influences an employee's productivity, job satisfaction, and professional growth Specific and personal feedback plays a pivotal role in this scenario. It assists in clearly displaying what an employee is doing well and where they can improve, fostering a culture of continuous learning and development.",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Routing History"),
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              downloadDataAsCsv(context); // Trigger CSV download when clicked
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: letterActions.length,
        itemBuilder: (context, index) {
          final action = letterActions[index];
          final actionType = LetterAction().getActionTypeById(action.actionId!);

          if (actionType == null) return SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      actionType.icon,
                      color: actionType.color,
                      size: 32,
                    ),
                    Text(
                      actionType.getLabel(context),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: actionType.color,
                          fontSize: 15),
                    ),
                    Text(
                        action.timeStamp != null
                            ? DateFormat('MM/dd/yyyy')
                                .format(action.timeStamp!.toLocal())
                            : "No Date",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                const SizedBox(width: 8),
                // Action Details in a Card
                Expanded(
                  child: ActionCard(
                    action: action,
                    actionType: actionType,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final LetterAction action;
  final ActionType actionType;

  const ActionCard({super.key, required this.action, required this.actionType});

  @override
  Widget build(BuildContext context) {
    // Fetch priority and classification using their IDs
    final Priority? priority = Priority.byId(action.priorityId!);
    final Classification? classification =
        Classification.byId(action.classificationId!);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          if (priority != null)
            Positioned(
                top: 0,
                left: 0,
                right: null,
                child: Container(
                  padding: const EdgeInsets.all(
                      12), // Adjust padding for a balanced look
                  decoration: BoxDecoration(
                    color: priority.color,
                    shape: BoxShape.circle, // Make the container circular
                  ),
                  child: Icon(
                    priority.icon,
                    color: Colors.white,
                    size: 18,
                  ),
                )), // Classification label
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    buildLabelValueColumn("From User", 'أمت السلام أمت السلام'),
                    buildLabelValueColumn("To User",
                        "أمت السلام أمت السلام أمت السلام أمت السلام"),
                    if (classification != null)
                      buildLabelValueColumn(
                          "Classification", classification.getLabel(context)),
                    if (action.comments != null && action.comments!.isNotEmpty)
                      buildLabelValueColumn("Comments", action.comments!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLabelValueColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(value,
            style: const TextStyle(color: Colors.black87, fontSize: 14)),
      ],
    );
  }
}
