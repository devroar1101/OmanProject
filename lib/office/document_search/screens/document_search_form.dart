import 'package:flutter/material.dart';

class DocumentSearchForm extends StatefulWidget {
  const DocumentSearchForm({super.key});

  @override
  _DocumentSearchFormState createState() => _DocumentSearchFormState();
}

class _DocumentSearchFormState extends State<DocumentSearchForm> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _tenderNumberController = TextEditingController();
  final TextEditingController _letterDateFromController =
      TextEditingController();
  final TextEditingController _letterDateToController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _receivedFromController = TextEditingController();
  final TextEditingController _receivedToController = TextEditingController();
  String _scanType = 'Type 1';
  String _direction = 'All';

  void _resetFields() {
    _subjectController.clear();
    _tenderNumberController.clear();
    _letterDateFromController.clear();
    _letterDateToController.clear();
    _locationController.clear();
    _referenceController.clear();
    _receivedFromController.clear();
    _receivedToController.clear();
    setState(() {
      _scanType = 'Type 1';
      _direction = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
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
            const SizedBox(width: 8.0),
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
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _scanType,
                decoration: InputDecoration(
                  labelText: 'Scan Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: ['Type 1', 'Type 2'].map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _scanType = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(width: 8.0),
            Card(
              color: const Color.fromARGB(255, 238, 240, 241),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Add search functionality
                },
                tooltip: 'Search',
              ),
            ),
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
