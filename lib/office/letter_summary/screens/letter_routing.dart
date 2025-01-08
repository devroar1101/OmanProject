import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import 'package:tenderboard/common/model/global_enum.dart';
import 'package:tenderboard/office/letter_summary/model/routing_history_result.dart';
import 'package:tenderboard/office/letter_summary/model/routing_repo.dart';

class RoutingHistory extends ConsumerWidget {
  RoutingHistory({super.key, this.routings, this.objectId});

  final List<RoutingHistoryResult>? routings;
  final String? objectId;

  Future<void> downloadDataAsCsv(
      BuildContext context, List<RoutingHistoryResult> actions) async {
    try {
      // Prepare CSV data from the routing list
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
        ...actions.map((action) => [
              action.actionId ?? '',
              action.fromUser ?? '',
              action.actionId ?? '',
              action.toUser ?? '',
              action.classificationId ?? '',
              action.priorityId ?? '',
              action.timeStamp ?? '',
              action.comments ?? ''
            ]),
      ];

      // Convert data to CSV
      String csvData = const ListToCsvConverter().convert(rows);

      // Create a Blob from the CSV data (web-specific)
      final blob = html.Blob([csvData], 'text/csv');

      // Create a URL for the Blob
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create an anchor element and trigger the download
      html.AnchorElement(href: url)
        ..setAttribute('download', 'routing_history.csv')
        ..click();

      // Clean up the URL after the download is triggered
      html.Url.revokeObjectUrl(url);

      // Notify the user about the download
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV file is being downloaded')));
    } catch (e) {
      print("Error saving CSV file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate CSV file')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<List<RoutingHistoryResult>> routingHistoryFuture = routings != null
        ? Future.value(
            routings!) // Ensure non-null value if routings is provided
        : ref
            .watch(routingHistoryRepositoryProvider)
            .fetchRoutingHistory(objectId!);

    return FutureBuilder<List<RoutingHistoryResult>>(
      future: routingHistoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load routing history'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No routing history found'));
        }

        final actions = snapshot.data!;
        return buildContent(context, actions);
      },
    );
  }

  Widget buildContent(
      BuildContext context, List<RoutingHistoryResult> actions) {
    return Column(
      children: [
        // Toolbar and download button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            buildPriorityIcons(context),
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () => downloadDataAsCsv(context, actions),
            ),
          ],
        ),
        // Actions list
        Expanded(
          child: ListView.builder(
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              final actionType = ActionType.getActionTypeById(action.actionId!);
              if (actionType == null) return const SizedBox.shrink();

              return buildActionRow(action, actionType, context);
            },
          ),
        ),
      ],
    );
  }

  Widget buildPriorityIcons(BuildContext context) {
    return Row(
      children: Priority.values.map((priority) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: priority.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                priority.getLabel(context),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildActionRow(RoutingHistoryResult action, ActionType actionType,
      BuildContext context) {
    final Priority? priority = Priority.byId(action.priorityId!);
    final Classification? classification =
        Classification.byId(action.classificationId!);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            action.timeStamp != null
                ? action.timeStamp ?? DateTime.now().toString()
                : "No Date",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ActionCard(
              action: action,
              actionType: actionType,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final RoutingHistoryResult action;
  final ActionType actionType;

  const ActionCard({
    super.key,
    required this.action,
    required this.actionType,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch priority and classification using their IDs

    final Priority? priority = Priority.byId(action.priorityId!);
    final Classification? classification =
        Classification.byId(action.classificationId!);

    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          if (priority != null)
            Positioned(
              top: 2,
              left: isRtl ? 4 : null,
              right: isRtl ? null : 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center content properly
                children: [
                  // Add a circular background behind the icon
                  Container(
                    padding: EdgeInsets.all(6), // Adds space around the icon
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: priority
                              .color, // Set the border color here (e.g., blue)
                          width:
                              2, // Set the border width here (you can adjust the value)
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(2, 2),
                            blurRadius: 8,
                          )
                        ]),
                    child: Icon(
                      actionType.icon,
                      color: priority.color,
                      size:
                          32, // Adjust icon size to fit inside the circle without overflow
                    ),
                  ),
                  const SizedBox(height: 4), // Space between the icon and text
                  // Text with appropriate font size to fit inside the CircleAvatar
                  Text(
                    actionType.getLabel(context),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: priority.color,
                      fontSize:
                          12, // Reduced font size to fit better in the circle
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    overflow: TextOverflow
                        .ellipsis, // Prevent text from overflowing if it's too long
                    textAlign: TextAlign.center, // Center text
                  ),
                ],
              ),
            ), // Classification label
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
                    buildLabelValueColumn("From User", '${action.fromUser}'),
                    buildLabelValueColumn("To User", '${action.toUser}'),
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
