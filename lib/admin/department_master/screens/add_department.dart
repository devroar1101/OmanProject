import 'package:flutter/material.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/widgets/select_field.dart';

class AddDepartmentMaster extends StatefulWidget {
  const AddDepartmentMaster({super.key});

  @override
  _AddDepartmentMasterState createState() => _AddDepartmentMasterState();
}

class _AddDepartmentMasterState extends State<AddDepartmentMaster> {
  final _formKey = GlobalKey<FormState>();

  String? _DepartmentNameArabic;
  String? _DepartmentNameEnglish;
  String? _selectedDG;

  final List<SelectOption<String>> _DGOptions = [
    SelectOption(displayName: 'Finance', key: 'finance', value: 'Finance'),
    SelectOption(displayName: 'HR', key: 'hr', value: 'HR'),
    SelectOption(displayName: 'IT', key: 'it', value: 'IT'),
    SelectOption(displayName: 'Operations', key: 'operations', value: 'Operations'),
  ];

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform save actions
      print('Arabic Name: $_DepartmentNameArabic');
      print('English Name: $_DepartmentNameEnglish');
      print('Selected Department: $_selectedDG');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Department master added successfully!')),
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
                  'Add Department Master',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450.0,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name (Arabic)',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _DepartmentNameArabic = value;
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
                  width: 450.0,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name (English)',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _DepartmentNameEnglish = value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the English name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450.0,
                  child: SearchableDropdown<String>(
                    options: _DGOptions,
                    onChanged: (value) {
                      setState(() {
                        _selectedDG = value;
                      });
                    },
                    hint: 'Select a Department',
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
