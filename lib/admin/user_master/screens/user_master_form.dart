import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/section_master/model/section_master.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/utilities/color_picker.dart';
import 'package:tenderboard/common/widgets/select_field.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';

class UsersSearchForm extends ConsumerStatefulWidget {
  const UsersSearchForm({super.key, required this.onSearch});

  final Function(String,String,String,String,String)onSearch;

  @override
  _UsersSearchFormState createState() => _UsersSearchFormState();
}

class _UsersSearchFormState extends ConsumerState<UsersSearchForm> {
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  List<SelectOption<DgMaster>> dgOptions = [];
  List<SelectOption<Department>> departmentOptions = [];
  List<SelectOption<SectionMaster>> sectionOptions = [];

  String? _selectedDGValue = '';
  String? _selectedDepartmentValue = '';
  String? _selectedSectionValue = '';

  void _resetFields() {
    _loginIdController.clear();
    _nameController.clear();
    widget.onSearch('','','','','',);
    setState(() {
      _selectedDGValue = '';
      _selectedDepartmentValue = '';
      _selectedSectionValue = '';
    });
  }

  void _handleSearch() {
    String loginId = _loginIdController.text;
    String name = _nameController.text;
    String dg = _selectedDGValue!;
    String department = _selectedDepartmentValue!;
    String section = _selectedSectionValue!;
    widget.onSearch(loginId,name,dg,department,section);

    print('Search triggered with:');
    print('Login ID: $loginId');
    print('Name: $name');
    print('DG: $_selectedDGValue');
    print('Department: $_selectedDepartmentValue');
    print('Section: $_selectedSectionValue');
  }

  @override
  Widget build(BuildContext context) {
    final dgOptionAsyncValue = ref.watch(dgOptionsProvider(true));
    final dgOptions = dgOptionAsyncValue.asData?.value ?? [];

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row: Login ID and Name
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _loginIdController,
                    decoration: InputDecoration(
                      labelText: 'Login ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Second Row: DG, Department, Section
            Row(
              children: [
                // DG Select Field
                Expanded(
                  child: SelectField<DgMaster>(
                    options: dgOptions,
                    onChanged: (dg, selectedOption) {
                      setState(() {
                       departmentOptions = selectedOption.childOptions
                          ?.cast<SelectOption<Department>>()?? [];
                        _selectedDGValue = dg.id.toString();
                        _selectedDepartmentValue = '';
                        _selectedSectionValue = '';
                      });
                    },
                    hint: 'Select DG',
                    initialValue: _selectedDGValue,
                  ),
                ),
                const SizedBox(width: 16.0),

                // Department Select Field
                Expanded(
                  child: SelectField<Department>(
                    options: departmentOptions,
                    key: ValueKey(departmentOptions),
                    onChanged: (department, selectedOption) {
                      setState(() {
                        sectionOptions = selectedOption.childOptions
                          ?.cast<SelectOption<SectionMaster>>()?? [];
                        _selectedDepartmentValue = department.id.toString();
                        _selectedSectionValue = '';
                      });
                    },
                    hint: 'Select Department',
                    initialValue: _selectedDepartmentValue,
                  ),
                ),
                const SizedBox(width: 16.0),

                // Section Select Field
                Expanded(
                  child: SelectField<SectionMaster>(
                    options: sectionOptions,
                    key: ValueKey(sectionOptions),
                    onChanged: (section, selectedOption) {
                      setState(() {
                        _selectedSectionValue = section.sectionId.toString();
                      });
                    },
                    hint: 'Select Section',
                    initialValue: _selectedSectionValue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Search and Reset Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Search Button
                Card(
                  color: const Color.fromARGB(255, 238, 240, 241),
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: const Icon(Icons.search,color: ColorPicker.formIconColor,),
                    onPressed: _handleSearch,
                    tooltip: 'Search',
                  ),
                ),
                const SizedBox(width: 8.0),

                // Reset Button
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
          ],
        ),
      ),
    );
  }
}
