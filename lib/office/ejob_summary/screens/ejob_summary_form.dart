import 'package:flutter/material.dart';

class EjobSummaryForm extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reference Number: TB/7-3-4-2024',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Divider(
              thickness: 1, // Adjust thickness as needed
              color: Colors.black, // Divider color
            ),
            SizedBox(height: 10),
            Text(
              'CC: User1, User2, User3',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Cabinet/Folder: Some Folder Name',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
