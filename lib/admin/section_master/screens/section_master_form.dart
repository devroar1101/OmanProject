import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/department_master/model/department_repo.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/widgets/select_field.dart';

class SectionMasterSearchForm extends ConsumerStatefulWidget {
  const SectionMasterSearchForm({super.key, required this.onSearch});

  final Function(String,String,String, String,String) onSearch;

  @override
  _SectionMasterSearchFormState createState() =>
      _SectionMasterSearchFormState();
}

class _SectionMasterSearchFormState
    extends ConsumerState<SectionMasterSearchForm> {
  final TextEditingController _nameEnglishController = TextEditingController();
  final TextEditingController _nameArabicController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? _selectedDGValue = '';
  String? _selectedDepartmentValue = '';

  void _resetFields() {
    _nameEnglishController.clear();
    _nameArabicController.clear();
    _codeController.clear();
    widget.onSearch('', '', '','','');
    setState(() {
      _selectedDGValue = '';
      _selectedDepartmentValue = '';
    });
  }

  void _handleSearch() {
    String nameEnglish = _nameEnglishController.text;
    String nameArabic = _nameArabicController.text;
    String code = _codeController.text;
    String? dropdownValue = _selectedDGValue;
    String? departmentValue = _selectedDepartmentValue;

    widget.onSearch(nameArabic,nameEnglish,code,departmentValue!,dropdownValue!);
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
    final dgOptionAsyncValue = ref.watch(dgOptionsProvider);
    final dgOptions = dgOptionAsyncValue.asData?.value ?? [];

    final departmentOptionsAsyncValue = _selectedDGValue != null
        ? ref.watch(departmentOptionsProvider(_selectedDGValue!))
        : const AsyncValue<List<SelectOption<Department>>>.data([]);

    final departmentOptions = departmentOptionsAsyncValue.asData?.value ?? [];

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

            // DG Dropdown Field
            Expanded(
              child: SelectField<DgMaster>(
                options: dgOptions,
                onChanged: (dg) {
                  setState(() {
                    _selectedDGValue = dg.id.toString();
                    _selectedDepartmentValue =
                        null; // Reset department when DG changes
                  });
                },
                hint: 'Select Section',
                initialValue: _selectedDGValue,
              ),
            ),
            const SizedBox(width: 8.0),

            // Department Dropdown Field
            Expanded(
              child: SelectField<Department>(
                options: departmentOptions,
                onChanged: (department) {
                  setState(() {
                    _selectedDepartmentValue = department.id.toString();
                  });
                },
                hint: 'Select Department',
                initialValue: _selectedDepartmentValue,
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
