import 'package:flutter/material.dart';

class EjobSummaryForm extends StatelessWidget {


  // Accept data through the constructor
   EjobSummaryForm({super.key});
    final data = [
          {'label': 'Reference Number', 'value': 'TB/7-3-4-2024'},
          {'label': 'CC', 'value': 'User1, User2, User3'},
          {'label': 'Cabinet/Folder', 'value': 'Some Folder Name'},
        ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.map((item) {
            // Dynamically build widgets from the data
            final label = item['label'] ?? 'Label';
            final value = item['value'] ?? 'Value';
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$label: $value',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
