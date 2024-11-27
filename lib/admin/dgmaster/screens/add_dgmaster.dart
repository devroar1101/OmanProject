import 'package:flutter/material.dart';

class AddDGmasterScreen extends StatefulWidget {
  const AddDGmasterScreen({super.key});

  @override
  _AddDGmasterScreenState createState() => _AddDGmasterScreenState();
}

class _AddDGmasterScreenState extends State<AddDGmasterScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _dgNameArabic;
  String? _dgNameEnglish;

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Create a model or perform any necessary action
      print('Arabic Name: $_dgNameArabic');
      print('English Name: $_dgNameEnglish');
      // Navigate or display a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('DG master added successfully!')),
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
                  'Add DGmaster',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450.0, // Reduced width for the field
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name (Arabic)',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _dgNameArabic = value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the Arabic name';
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
                      labelText: 'Name (English)',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _dgNameEnglish = value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the English name';
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
