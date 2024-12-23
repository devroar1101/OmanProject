// For encoding CSV data
import 'dart:html' as html; // For file download on web
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
      final anchor = html.AnchorElement(href: url)
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
        comments: "Forwarded to User 106",
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
                // Date Column
                Column(
                  children: [
                    Text(
                      action.timeStamp != null
                          ? DateFormat('MM/dd/yyyy')
                              .format(action.timeStamp!.toLocal())
                          : "No Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(width: 16),

                // Vertical Timeline with Icon
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 20,
                      width: 2,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 20,
                      width: 2,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
                SizedBox(width: 16),

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

// ActionCard Widget (unchanged)
class ActionCard extends StatelessWidget {
  final LetterAction action;
  final ActionType actionType;

  const ActionCard({super.key, required this.action, required this.actionType});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 4,
          children: [
            buildLabelValueColumn("From User", "${action.fromUserId ?? 'N/A'}"),
            buildLabelValueColumn("To User", "${action.toUserId ?? 'N/A'}"),
            buildLabelValueColumn(
                "Classification", "${action.classificationId ?? 'N/A'}"),
            buildLabelValueColumn("Priority", "${action.priorityId ?? 'N/A'}"),
            if (action.comments != null && action.comments!.isNotEmpty)
              buildLabelValueColumn("Comments", action.comments!),
          ],
        ),
      ),
    );
  }

  Widget buildLabelValueColumn(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value, style: TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}
