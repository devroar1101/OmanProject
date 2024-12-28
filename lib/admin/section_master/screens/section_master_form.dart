import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/utilities/color_picker.dart';
import 'package:tenderboard/common/widgets/select_field.dart';

class SectionMasterSearchForm extends ConsumerStatefulWidget {
  const SectionMasterSearchForm({super.key, required this.onSearch});

  final Function(String, String, String, String?, String?) onSearch;

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
  int _resetKey = 0; // Counter to reset keys

  List<SelectOption<DgMaster>> dgOptions = [];
  List<SelectOption<Department>> departmentOptions = [];

  void _resetFields() {
    _nameEnglishController.clear();
    _nameArabicController.clear();
    _codeController.clear();
    widget.onSearch('', '', '', '', '');
    setState(() {
      _selectedDGValue = '';
      _selectedDepartmentValue = '';
      departmentOptions = []; // Reset department options
      _resetKey++; // Increment the reset key to rebuild widgets
    });
  }

  void _handleSearch() {
    String nameEnglish = _nameEnglishController.text;
    String nameArabic = _nameArabicController.text;
    String code = _codeController.text;
    String? dg = _selectedDGValue;
    String? department = _selectedDepartmentValue;

    widget.onSearch(nameArabic, nameEnglish, code, dg, department);
    // Perform search logic
    print('Search triggered with:');
    print('Name English: $nameEnglish');
    print('Name Arabic: $nameArabic');
    print('Code: $code');
    print('Selected dg: $dg');
    print('Selected Department: $department');
  }

  @override
  Widget build(BuildContext context) {
    final dgOptionAsyncValue = ref.watch(dgOptionsProvider(true));
    final dgOptions = dgOptionAsyncValue.asData?.value ?? [];

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      // margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
                label: 'DG',
                key: ValueKey('dgKey_$_resetKey'),
                options: dgOptions,
                onChanged: (dg, selectedOption) {
                  setState(() {
                    _selectedDGValue = dg.id.toString();
                    departmentOptions = selectedOption.childOptions
                            ?.cast<SelectOption<Department>>() ??
                        [];
                    _selectedDepartmentValue =
                        ''; // Reset department when DG changes
                  });
                },
                hint: 'Select DG',
                initialValue: _selectedDGValue,
              ),
            ),

            const SizedBox(width: 8.0),

            // Department Dropdown Field
            Expanded(
              child: SelectField<Department>(
                label: 'Department',
                options: departmentOptions,
                key: ValueKey(departmentOptions),
                onChanged: (department, selectedOption) {
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
                icon: const Icon(Icons.search,color: ColorPicker.formIconColor,),
                onPressed: _handleSearch,
                tooltip: 'Search',
              ),
            ),

            // Reset Icon Button
            Card(
              color: const Color.fromARGB(255, 240, 234, 235),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.refresh,color: ColorPicker.formIconColor,),
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
