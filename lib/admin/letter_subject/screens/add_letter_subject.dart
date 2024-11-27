import 'package:flutter/material.dart';

class AddLetterSubject extends StatefulWidget {
  const AddLetterSubject({super.key});

  @override
  _AddLetterSubjectState createState() => _AddLetterSubjectState();
}

class _AddLetterSubjectState extends State<AddLetterSubject> {
  final _formKey = GlobalKey<FormState>();

  String? _tenderNumber;
  String? _subject;

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform necessary actions (e.g., create a model or save data)
      print('Tender Number: $_tenderNumber');
      print('Subject: $_subject');
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('subject added successfully!')),
      );
      Navigator.pop(context); // Close the modal after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SizedBox(
        width: 500.0, // Set a specific width for the dialog modal
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Makes the dialog height dynamic
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Letter Subject',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450.0, // Reduced width for the field
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tender Number',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _tenderNumber = value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the tender number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450.0, // Reduced width for the field
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _subject = value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the subject';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _saveForm,
                      child: const Text('Save'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the modal on cancel
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
