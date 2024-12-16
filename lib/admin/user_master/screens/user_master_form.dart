import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/section_master/model/section_master.dart';
import 'package:tenderboard/admin/section_master/model/section_master_repo.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/widgets/select_field.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/admin/department_master/model/department_repo.dart';

class UsersSearchForm extends ConsumerStatefulWidget {
  const UsersSearchForm({super.key});

  @override
  _UsersSearchFormState createState() => _UsersSearchFormState();
}

class _UsersSearchFormState extends ConsumerState<UsersSearchForm> {
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String? _selectedDGValue = '';
  String? _selectedDepartmentValue = '';
  String? _selectedSectionValue = '';

  void _resetFields() {
    _loginIdController.clear();
    _nameController.clear();
    setState(() {
      _selectedDGValue = '';
      _selectedDepartmentValue = '';
      _selectedSectionValue = '';
    });
  }

  void _handleSearch() {
    String loginId = _loginIdController.text;
    String name = _nameController.text;

    print('Search triggered with:');
    print('Login ID: $loginId');
    print('Name: $name');
    print('DG: $_selectedDGValue');
    print('Department: $_selectedDepartmentValue');
    print('Section: $_selectedSectionValue');
  }

  @override
  Widget build(BuildContext context) {
    final dgOptionAsyncValue = ref.watch(dgOptionsProvider);
    final dgOptions = dgOptionAsyncValue.asData?.value ?? [];

    final departmentOptionsAsyncValue = _selectedDGValue!.isNotEmpty
        ? ref.watch(departmentOptionsProvider(_selectedDGValue))
        : const AsyncValue<List<SelectOption<Department>>>.data([]);

    final departmentOptions = departmentOptionsAsyncValue.asData?.value ?? [];
    final sectionOptionsAsyncValue = _selectedDepartmentValue != null
        ? ref.watch(sectionOptionsProvider(_selectedDepartmentValue!))
        : const AsyncValue<List<SelectOption<SectionMaster>>>.data([]);

    final sectionOptions = sectionOptionsAsyncValue.asData?.value ?? [];

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
                    onChanged: (dg) {
                      setState(() {
                        _selectedDGValue = dg.id.toString();
                        print('11dg: $_selectedDGValue');
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
                    onChanged: (department) {
                      setState(() {
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
                    onChanged: (section) {
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
                    icon: const Icon(Icons.search),
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
                    icon: const Icon(Icons.refresh),
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
