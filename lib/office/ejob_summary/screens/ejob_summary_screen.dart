import 'package:flutter/material.dart';
import 'package:tenderboard/office/ejob_summary/screens/ejob_summary_form.dart';

class EjobSummaryScreen extends StatefulWidget {
  const EjobSummaryScreen({super.key});

  @override
  _EjobSummaryScreenState createState() => _EjobSummaryScreenState();
}

class _EjobSummaryScreenState extends State<EjobSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side with card-style widget
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Adds spacing around the card
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0), // Inner padding
                  //color: Colors.white,
                  child:  EjobSummaryForm(),
                ),
              ),
            ),
          ),
          // Right side empty panel
          Expanded(
            flex: 2,
            child: Container(
              //color: const Color.fromARGB(255, 167, 164, 164),
            ),
          ),
        ],
      ),
    );
  }
}
