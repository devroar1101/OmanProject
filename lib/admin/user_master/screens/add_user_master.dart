import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/department_master/model/department_repo.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/admin/section_master/model/section_master.dart';
import 'package:tenderboard/admin/section_master/model/section_master_repo.dart';
import 'package:tenderboard/admin/user_master/model/user_master_repo.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/widgets/select_field.dart';
import 'dart:io';

class AddUserMasterScreen extends ConsumerStatefulWidget {
  const AddUserMasterScreen({Key? key}) : super(key: key);

  @override
  _AddUserMasterScreenState createState() => _AddUserMasterScreenState();
}

class _AddUserMasterScreenState extends ConsumerState<AddUserMasterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  File? _profileImage;

  final List<List<Map<String, dynamic>>> allPermissions = [
    [
      {'name': 'View Reports', 'value': false},
      {'name': 'Edit Reports', 'value': false},
      {'name': 'Delete Reports', 'value': false},
      {'name': 'Export Data', 'value': false},
    ],
    [
      {'name': 'Create Assignment', 'value': false},
      {'name': 'Edit Assignment', 'value': false},
      {'name': 'Delete Assignment', 'value': false},
      {'name': 'Review Assignment', 'value': false},
    ],
    [
      {'name': 'Search Documents', 'value': false},
      {'name': 'Edit Documents', 'value': false},
      {'name': 'Delete Documents', 'value': false},
      {'name': 'Export Documents', 'value': false},
    ],
  ];

  final List<String> titles = [
    'Privileges',
    'Assignment Permissions',
    'Document Search Permissions',
  ];

  final _loginIdController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _ldapIdentifierController = TextEditingController();
  final _emailController = TextEditingController();
  final _officeNumberController = TextEditingController();
  final _nameController = TextEditingController();

  String? _selectedDesignation;
  String? _selectedAuthMode;
  String? _selectedRole;
  String? _selectedDG;
  String? _selectedDepartment;
  String? _selectedSection;

  final List<SelectOption<String>> designationOptions = [
    SelectOption(displayName: 'Manager', key: 'manager', value: 'Manager'),
    SelectOption(
        displayName: 'Developer', key: 'developer', value: 'Developer'),
  ];

  final List<SelectOption<String>> authModeOptions = [
    SelectOption(displayName: 'Password', key: 'password', value: 'Password'),
    SelectOption(
        displayName: 'Biometric', key: 'biometric', value: 'Biometric'),
  ];

  final List<SelectOption<String>> roleOptions = [
    SelectOption(displayName: 'Admin', key: 'admin', value: 'Admin'),
    SelectOption(displayName: 'User', key: 'user', value: 'User'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _saveForm(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
        try {
        await ref.read(UserMasterRepositoryProvider.notifier).addUserMaster(
              name: _nameController.text,
              displayName: _displayNameController.text,
              dgId: 11,
              departmentId: 13,
              sectionId: 163,
              email: _emailController.text,
            );
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User added successfully!')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    }
  }

  void _pickProfileImage() {
    // Add image picking functionality here
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: SizedBox(
        width: 800,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Details'),
                //Tab(text: 'Permissions'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDetailsTab(),
                  _buildPermissionsTab(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _saveForm(context, ref),
                    child: const Text('Save'),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    
    final dgOptionAsyncValue = ref.watch(dgOptionsProvider);
    final dgOptions = dgOptionAsyncValue.asData?.value ?? [];

    final departmentOptionsAsyncValue = _selectedDG != null
        ? ref.watch(departmentOptionsProvider('11'))
        : const AsyncValue<List<SelectOption<Department>>>.data([]);

    final departmentOptions = departmentOptionsAsyncValue.asData?.value ?? [];

    final sectionOptionsAsyncValue = _selectedDepartment != null
        ? ref.watch(sectionOptionsProvider('13'))
        : const AsyncValue<List<SelectOption<SectionMaster>>>.data([]);

    final sectionOptions = sectionOptionsAsyncValue.asData?.value ?? [];


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Image + Name and Display Name Fields in One Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(
                              Icons.add_a_photo,
                              size: 30,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Name',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _displayNameController,
                          label: 'Display Name',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Other Fields in Two-Column Layout
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _loginIdController,
                      label: 'Login ID',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SelectField<String>(
                      options: authModeOptions,
                      onChanged: (value) =>
                          setState(() => _selectedAuthMode = value),
                      hint: 'Select Auth Mode',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _officeNumberController,
                      label: 'Office Number',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SelectField<String>(
                      options: roleOptions,
                      onChanged: (value) =>
                          setState(() => _selectedRole = value),
                      hint: 'Select Role',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SelectField<DgMaster>(
                      options: dgOptions,
                      onChanged: (dg) =>
                          setState(() => _selectedDG = dg.id.toString()),
                      hint: 'Select DG',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SelectField<Department>(
                      options: departmentOptions,
                      onChanged: (dept) =>
                          setState(() => _selectedDepartment = dept.id.toString()),
                      hint: 'Select Department',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SelectField<SectionMaster>(
                      options: sectionOptions,
                      onChanged: (section) =>
                          setState(() => _selectedSection = section.sectionId.toString()),
                      hint: 'Select Section',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildPermissionsTab() {
    return ListView.builder(
      itemCount: allPermissions.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titles[index],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              children: allPermissions[index].map((permission) {
                return CheckboxListTile(
                  title: Text(permission['name']),
                  value: permission['value'],
                  onChanged: (value) {
                    setState(() {
                      permission['value'] = value;
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
