import 'package:flutter/material.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/widgets/select_field.dart';

class UsersSearchForm extends StatefulWidget {
  const UsersSearchForm({super.key});

  @override
  _UsersSearchFormState createState() => _UsersSearchFormState();
}

class _UsersSearchFormState extends State<UsersSearchForm> {
  final TextEditingController _eofficeIdController = TextEditingController();
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ldapIdentifierController =
      TextEditingController();

  String? _selectedDesignationValue;
  String? _selectedRoleValue;
  String? _selectedDGValue;
  String? _selectedDepartmentValue;
  String? _selectedSectionValue;

  // Example options for dropdown fields
  final List<SelectOption<String>> designationOptions = [
    SelectOption(displayName: 'Manager', key: 'manager', value: 'Manager'),
    SelectOption(
        displayName: 'Supervisor', key: 'supervisor', value: 'Supervisor'),
    SelectOption(displayName: 'Staff', key: 'staff', value: 'Staff'),
  ];

  final List<SelectOption<String>> roleOptions = [
    SelectOption(displayName: 'Admin', key: 'admin', value: 'Admin'),
    SelectOption(displayName: 'User', key: 'user', value: 'User'),
    SelectOption(displayName: 'Viewer', key: 'viewer', value: 'Viewer'),
  ];

  final List<SelectOption<String>> dgOptions = [
    SelectOption(displayName: 'DG 1', key: 'dg1', value: 'DG 1'),
    SelectOption(displayName: 'DG 2', key: 'dg2', value: 'DG 2'),
    SelectOption(displayName: 'DG 3', key: 'dg3', value: 'DG 3'),
  ];

  final List<SelectOption<String>> departmentOptions = [
    SelectOption(
        displayName: 'Department A', key: 'deptA', value: 'Department A'),
    SelectOption(
        displayName: 'Department B', key: 'deptB', value: 'Department B'),
  ];

  final List<SelectOption<String>> sectionOptions = [
    SelectOption(displayName: 'Section X', key: 'sectX', value: 'Section X'),
    SelectOption(displayName: 'Section Y', key: 'sectY', value: 'Section Y'),
  ];

  void _resetFields() {
    _eofficeIdController.clear();
    _loginIdController.clear();
    _nameController.clear();
    _ldapIdentifierController.clear();
    setState(() {
      _selectedDesignationValue = null;
      _selectedRoleValue = null;
      _selectedDGValue = null;
      _selectedDepartmentValue = null;
      _selectedSectionValue = null;
    });
  }

  void _handleSearch() {
    String eofficeId = _eofficeIdController.text;
    String loginId = _loginIdController.text;
    String name = _nameController.text;
    String ldapIdentifier = _ldapIdentifierController.text;

    print('Search triggered with:');
    print('Eoffice ID: $eofficeId');
    print('Login ID: $loginId');
    print('Name: $name');
    print('LDAP Identifier: $ldapIdentifier');
    print('Designation: $_selectedDesignationValue');
    print('Role: $_selectedRoleValue');
    print('DG: $_selectedDGValue');
    print('Department: $_selectedDepartmentValue');
    print('Section: $_selectedSectionValue');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row with 3 fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _eofficeIdController,
                    decoration: InputDecoration(
                      labelText: 'Eoffice ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
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

            // Second Row with 3 fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ldapIdentifierController,
                    decoration: InputDecoration(
                      labelText: 'LDAP Identifier',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: SelectField<String>(
                    options: designationOptions,
                    onChanged: (value) {
                      setState(() {
                        _selectedDesignationValue = value;
                      });
                    },
                    hint: 'Select Designation',
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: SelectField<String>(
                    options: roleOptions,
                    onChanged: (value) {
                      setState(() {
                        _selectedRoleValue = value;
                      });
                    },
                    hint: 'Select Role',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Third Row with 3 fields
            Row(
              children: [
                Expanded(
                  child: SelectField<String>(
                    options: dgOptions,
                    onChanged: (value) {
                      setState(() {
                        _selectedDGValue = value;
                      });
                    },
                    hint: 'Select DG',
                  ),
                ),
                const SizedBox(width: 16.0),
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
                const SizedBox(width: 16.0),
                Expanded(
                  child: SelectField<String>(
                    options: sectionOptions,
                    onChanged: (value) {
                      setState(() {
                        _selectedSectionValue = value;
                      });
                    },
                    hint: 'Select Section',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                const SizedBox(width: 8.0),
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
          ],
        ),
      ),
    );
  }
}
