import 'package:flutter/material.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/widgets/select_field.dart';

class SectionMasterSearchForm extends StatefulWidget {
  const SectionMasterSearchForm({super.key});

  @override
  _SectionMasterSearchFormState createState() =>
      _SectionMasterSearchFormState();
}

class _SectionMasterSearchFormState extends State<SectionMasterSearchForm> {
  final TextEditingController _nameEnglishController = TextEditingController();
  final TextEditingController _nameArabicController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? _selectedDGValue;
  String? _selectedDepartmentValue;

  // Example dropdown options
  final List<SelectOption<String>> dgOptions = [
    SelectOption(displayName: 'Section 1', key: 'sect1', value: 'Section 1'),
    SelectOption(displayName: 'Section 2', key: 'sect2', value: 'Section 2'),
    SelectOption(displayName: 'إدارة 3', key: 'sect3', value: 'إدارة 3'),
    SelectOption(displayName: 'Section 4', key: 'sect4', value: 'Section 4'),
  ];

  // Example department options
  final List<SelectOption<String>> departmentOptions = [
    SelectOption(
        displayName: 'Department A', key: 'deptA', value: 'Department A'),
    SelectOption(
        displayName: 'Department B', key: 'deptB', value: 'Department B'),
    SelectOption(displayName: 'قسم C', key: 'deptC', value: 'قسم C'),
    SelectOption(
        displayName: 'Department D', key: 'deptD', value: 'Department D'),
  ];

  void _resetFields() {
    _nameEnglishController.clear();
    _nameArabicController.clear();
    _codeController.clear();
    setState(() {
      _selectedDGValue = null;
      _selectedDepartmentValue = null;
    });
  }

  void _handleSearch() {
    String nameEnglish = _nameEnglishController.text;
    String nameArabic = _nameArabicController.text;
    String code = _codeController.text;
    String? dropdownValue = _selectedDGValue;
    String? departmentValue = _selectedDepartmentValue;

    // Perform search logic
    print('Search triggered with:');
    print('Name English: $nameEnglish');
    print('Name Arabic: $nameArabic');
    print('Code: $code');
    print('Selected Section: $dropdownValue');
    print('Selected Department: $departmentValue');
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
            // Code Text Field
            Expanded(
              child: TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),

            // Name English Text Field
            Expanded(
              child: TextField(
                controller: _nameEnglishController,
                decoration: InputDecoration(
                  labelText: 'Name English',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),

            // Name Arabic Text Field
            Expanded(
              child: TextField(
                controller: _nameArabicController,
                decoration: InputDecoration(
                  labelText: 'Name Arabic',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),

            // Custom Dropdown Field
            Expanded(
              child: SelectField<String>(
                options: dgOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedDGValue = value;
                  });
                },
                hint: 'Select Section',
              ),
            ),
            const SizedBox(width: 8.0),

            // New Department Dropdown Field
            Expanded(
              child: SelectField<String>(
                options: departmentOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedDepartmentValue = value;
                  });
                },
                hint: 'Select Department',
              ),
            ),
            const SizedBox(width: 8.0),

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
