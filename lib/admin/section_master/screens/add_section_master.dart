import 'package:flutter/material.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/widgets/select_field.dart';

class AddSectionMaster extends StatefulWidget {
  @override
  _AddSectionMasterState createState() => _AddSectionMasterState();
}

class _AddSectionMasterState extends State<AddSectionMaster> {
  final _formKey = GlobalKey<FormState>();

  String? _sectionNameArabic;
  String? _sectionNameEnglish;
  String? _selectedDG;
  String? _selectedDepartment;

  final List<SelectOption<String>> _DGOptions = [
    SelectOption(displayName: 'Finance', key: 'finance', value: 'Finance'),
    SelectOption(displayName: 'HR', key: 'hr', value: 'HR'),
    SelectOption(displayName: 'IT', key: 'it', value: 'IT'),
    SelectOption(displayName: 'Operations', key: 'operations', value: 'Operations'),
  ];

  final List<SelectOption<String>> _departmentOptions = [
    SelectOption(displayName: 'Department A', key: 'deptA', value: 'Department A'),
    SelectOption(displayName: 'Department B', key: 'deptB', value: 'Department B'),
    SelectOption(displayName: 'Department C', key: 'deptC', value: 'Department C'),
    SelectOption(displayName: 'Department D', key: 'deptD', value: 'Department D'),
  ];

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform save actions
      print('Arabic Name: $_sectionNameArabic');
      print('English Name: $_sectionNameEnglish');
      print('Selected DG: $_selectedDG');
      print('Selected Department: $_selectedDepartment');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Section master added successfully!')),
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
                  'Add Section Master',
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
                      _sectionNameArabic = value;
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
                      _sectionNameEnglish = value;
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
                    hint: 'Select a DG',
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 450.0,
                  child: SearchableDropdown<String>(
                    options: _departmentOptions,
                    onChanged: (value) {
                      setState(() {
                        _selectedDepartment = value;
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
