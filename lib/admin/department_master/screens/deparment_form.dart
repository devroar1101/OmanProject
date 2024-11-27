import 'package:flutter/material.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/widgets/select_field.dart';

class DepartmentSearchForm extends StatefulWidget {
  const DepartmentSearchForm({super.key});

  @override
  _DepartmentSearchFormState createState() => _DepartmentSearchFormState();
}

class _DepartmentSearchFormState extends State<DepartmentSearchForm> {
  final TextEditingController _nameEnglishController = TextEditingController();
  final TextEditingController _nameArabicController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? _selectedDropdownValue;

  // Example dropdown options
  final List<SelectOption<String>> dropdownOptions = [
    SelectOption(displayName: 'Department 1', key: 'dept1', value: 'Department 1'),
    SelectOption(displayName: 'Department 2', key: 'dept2', value: 'Department 2'),
    SelectOption(displayName: 'إدارة 3', key: 'dept3', value: 'إدارة 3'),
    SelectOption(displayName: 'Department 4', key: 'dept4', value: 'Department 4'),
  ];

  void _resetFields() {
    _nameEnglishController.clear();
    _nameArabicController.clear();
    _codeController.clear();
    setState(() {
      _selectedDropdownValue = null;
    });
  }

  void _handleSearch() {
    String nameEnglish = _nameEnglishController.text;
    String nameArabic = _nameArabicController.text;
    String code = _codeController.text;
    String? dropdownValue = _selectedDropdownValue;

    // Perform search logic
    print('Search triggered with:');
    print('Name English: $nameEnglish');
    print('Name Arabic: $nameArabic');
    print('Code: $code');
    print('Selected Department: $dropdownValue');
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
              child: SearchableDropdown<String>(
                options: dropdownOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedDropdownValue = value;
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
