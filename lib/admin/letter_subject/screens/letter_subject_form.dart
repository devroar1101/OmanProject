import 'package:flutter/material.dart';

class LetterSubjectSearchForm extends StatefulWidget {
  const LetterSubjectSearchForm({super.key, required this.onSearch});

  final Function(String, String) onSearch;

  @override
  _LetterSubjectSearchFormState createState() =>
      _LetterSubjectSearchFormState();
}

class _LetterSubjectSearchFormState extends State<LetterSubjectSearchForm> {
  final TextEditingController _tenderNumberController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  void _resetFields() {
    _tenderNumberController.clear();
    _subjectController.clear();
    widget.onSearch('','');
  }

  void _handleSearch() {
    String tenderNumber = _tenderNumberController.text;
    String subject = _subjectController.text;
    widget.onSearch(tenderNumber,subject);

    // Perform search logic here
    debugPrint("Tender Number: $tenderNumber, Subject: $subject");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),

      child: Padding(
         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Row(
          children: [
            // Tender Number Text Field
            Expanded(
              child: TextField(
                controller: _tenderNumberController,
                decoration: InputDecoration(
                  labelText: 'Tender Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0), // Spacing between fields

            // Subject Text Field
            Expanded(
              child: TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0), // Spacing between fields and icons

            // Search Icon Button
            Card(
              color: const Color.fromARGB(255, 238, 240, 241),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _handleSearch,
                tooltip: 'Search',
              ),
            ),

            // Reset Icon Button
            Card(
              color: const Color.fromARGB(255, 240, 234, 235),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _resetFields,
                tooltip: 'Reset',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
