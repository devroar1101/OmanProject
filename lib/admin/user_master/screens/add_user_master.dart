import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/admin/section_master/model/section_master.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';
import 'package:tenderboard/admin/user_master/model/user_master_repo.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/widgets/select_field.dart';
import 'dart:io';

class AddUserMasterScreen extends ConsumerStatefulWidget {
  const AddUserMasterScreen({super.key, this.currentUser});

  final UserMaster? currentUser;

  @override
  _AddUserMasterScreenState createState() => _AddUserMasterScreenState();
}

class _AddUserMasterScreenState extends ConsumerState<AddUserMasterScreen> {
  final _formKey = GlobalKey<FormState>();

  File? _profileImage;

  final _loginIdController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _ldapIdentifierController = TextEditingController();
  final _emailController = TextEditingController();
  final _officeNumberController = TextEditingController();
  final _nameController = TextEditingController();

  List<SelectOption<DgMaster>> dgOptions = [];
  List<SelectOption<Department>> departmentOptions = [];
  List<SelectOption<SectionMaster>> sectionOptions = [];

  String? _selectedDesignation;
  String? _selectedAuthMode;
  String? _selectedRole;
  int? _selectedDG;
  int? _selectedDepartment;
  int? _selectedSection;

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

  Future<void> _saveForm(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(UserMasterRepositoryProvider.notifier).addUserMaster(
              name: _nameController.text,
              displayName: _displayNameController.text,
              dgId: _selectedDG!,
              departmentId: _selectedDepartment!,
              sectionId: _selectedSection!,
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
    final dgOptionAsyncValue = ref.watch(dgOptionsProvider(true));
    dgOptions = dgOptionAsyncValue.asData?.value ?? [];
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: SizedBox(
        width: 800,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                                onChanged: (value, selectedOption) {
                                  setState(() => _selectedAuthMode = value);
                                },
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
                                onChanged: (value, selectedOption) =>
                                    setState(() => _selectedRole = value),
                                hint: 'Select Role',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SelectField<DgMaster>(
                                options: dgOptions,
                                onChanged: (dg, selectedOption) {
                                  setState(() {
                                    departmentOptions = selectedOption.childOptions
                                            ?.cast<SelectOption<Department>>() ??
                                        [];
                                    _selectedDG = dg.id;
                                    _selectedDepartment = null;
                                  });
                                },
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
                                key: ValueKey(departmentOptions),
                                onChanged: (dept, selectedOption) {
                                  setState(() {
                                    sectionOptions = selectedOption.childOptions
                                            ?.cast<SelectOption<SectionMaster>>() ??
                                        [];
                                    _selectedSection = null;
                                    _selectedDepartment = dept.id;
                                  });
                                },
                                hint: 'Select Department',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SelectField<SectionMaster>(
                                options: sectionOptions,
                                key: ValueKey(sectionOptions),
                                onChanged: (section, selectedOption) {
                                  setState(() {
                                    _selectedSection = section.sectionId;
                                  });
                                },
                                hint: 'Select Section',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
