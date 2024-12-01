import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tenderboard/common/model/select_option.dart'; // Ensure this import path matches your structure
import 'package:tenderboard/common/widgets/select_field.dart';
import 'dart:io';

class AddUserMasterScreen extends StatefulWidget {
  const AddUserMasterScreen({super.key});

  @override
  _AddUserMasterScreenState createState() => _AddUserMasterScreenState();
}

// Add a variable to store the profile image
File? _profileImage;

class _AddUserMasterScreenState extends State<AddUserMasterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Tab controller for switching between Details and Permissions
  late TabController _tabController;

  /// Define your 3 lists of permissions with mutable state
  List<Map<String, dynamic>> list1 = [
    {'name': 'View Reports', 'value': false},
    {'name': 'Edit Reports', 'value': false},
    {'name': 'Delete Reports', 'value': false},
    {'name': 'Export Data', 'value': false},
  ];

  List<Map<String, dynamic>> list2 = [
    {'name': 'View Reports', 'value': false},
    {'name': 'Edit Reports', 'value': false},
    {'name': 'Delete Reports', 'value': false},
    {'name': 'Export Data', 'value': false},
  ];

  List<Map<String, dynamic>> list3 = [
    {'name': 'View Reports', 'value': false},
    {'name': 'Edit Reports', 'value': false},
    {'name': 'Delete Reports', 'value': false},
    {'name': 'Export Data', 'value': false},
  ];

  // Titles for each section
  final List<String> titles = [
    'Privileges',
    'Assignment Permissions',
    'Document Search Permissions',
  ];

  // Initialize the TabController
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // Dispose the TabController when done
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Text controllers for text fields
  final _loginIdController = TextEditingController();
  final _eofficeIdController = TextEditingController();
  final _ldapIdentifierController = TextEditingController();
  final _emailController = TextEditingController();
  final _officeNumberController = TextEditingController();
  final _nameController = TextEditingController();

  // Dropdown selected values
  String? _selectedDesignation;
  String? _selectedAuthMode;
  String? _selectedRole;
  String? _selectedDG;
  String? _selectedDepartment;
  String? _selectedSection;

  // Dropdown options
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
  final List<SelectOption<String>> dgOptions = [
    SelectOption(displayName: 'DG1', key: 'dg1', value: 'DG1'),
    SelectOption(displayName: 'DG2', key: 'dg2', value: 'DG2'),
  ];
  final List<SelectOption<String>> departmentOptions = [
    SelectOption(displayName: 'HR', key: 'hr', value: 'HR'),
    SelectOption(displayName: 'IT', key: 'it', value: 'IT'),
  ];
  final List<SelectOption<String>> sectionOptions = [
    SelectOption(
        displayName: 'Section A', key: 'section_a', value: 'Section A'),
    SelectOption(
        displayName: 'Section B', key: 'section_b', value: 'Section B'),
  ];

  // Method to pick image from gallery or camera
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Save form logic
  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Perform save actions here
      print('Login ID: ${_loginIdController.text}');
      print('Eoffice ID: ${_eofficeIdController.text}');
      print('LDAP Identifier: ${_ldapIdentifierController.text}');
      print('Email: ${_emailController.text}');
      print('Office Number: ${_officeNumberController.text}');
      print('Name: ${_nameController.text}');
      print('Designation: $_selectedDesignation');
      print('Auth Mode: $_selectedAuthMode');
      print('Role: $_selectedRole');
      print('DG: $_selectedDG');
      print('Department: $_selectedDepartment');
      print('Section: $_selectedSection');
      if (_profileImage != null) {
        print('Profile Image: ${_profileImage!.path}');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User master added successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SizedBox(
        width: 800.0, // Adjust width as needed
        child: Column(
          children: [
            // TabBar
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Details'),
                Tab(text: 'Permissions'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Details tab content
                  _buildDetailsTab(),
                  // Permissions tab content
                  _buildPermissionsTab(),
                ],
              ),
            ),
            // Fixed Save and Cancel Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveForm,
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

  // Widget for the Details tab
  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Align text on left and avatar on right
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Add User Master',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: _pickImage, // Open image picker when tapped
                    child: CircleAvatar(
                      radius: 30, // Adjust size for the circle
                      backgroundColor:
                          Colors.grey[200], // Circle background color
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
                ],
              ),
              const SizedBox(height: 16.0),
              ..._buildFormFields(),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build form fields
  List<Widget> _buildFormFields() {
    return [
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
            child: _buildTextField(
              controller: _eofficeIdController,
              label: 'Eoffice ID',
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: SearchableDropdown<String>(
              options: designationOptions,
              onChanged: (value) =>
                  setState(() => _selectedDesignation = value),
              hint: 'Select Designation',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SearchableDropdown<String>(
              options: authModeOptions,
              onChanged: (value) => setState(() => _selectedAuthMode = value),
              hint: 'Select Auth Mode',
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: SearchableDropdown<String>(
              options: roleOptions,
              onChanged: (value) => setState(() => _selectedRole = value),
              hint: 'Select Role',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SearchableDropdown<String>(
              options: dgOptions,
              onChanged: (value) => setState(() => _selectedDG = value),
              hint: 'Select DG',
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: SearchableDropdown<String>(
              options: departmentOptions,
              onChanged: (value) => setState(() => _selectedDepartment = value),
              hint: 'Select Department',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SearchableDropdown<String>(
              options: sectionOptions,
              onChanged: (value) => setState(() => _selectedSection = value),
              hint: 'Select Section',
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _ldapIdentifierController,
              label: 'LDAP Identifier',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextField(
              controller: _emailController,
              label: 'Email',
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _officeNumberController,
              label: 'Office Number',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextField(
              controller: _nameController,
              label: 'Name',
            ),
          ),
        ],
      ),
    ];
  }

  // Helper to build text fields
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
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildPermissionsTab() {
    List<List<Map<String, dynamic>>> allLists = [list1, list2, list3];

    return ListView.builder(
      itemCount: allLists.length,
      itemBuilder: (context, index) {
        var currentList = allLists[index];

        // Split the current list into pairs
        var permissionPairs = List.generate(
          (currentList.length / 2).ceil(),
          (pairIndex) => currentList.sublist(
              pairIndex * 2,
              (pairIndex + 1) * 2 > currentList.length
                  ? currentList.length
                  : (pairIndex + 1) * 2),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the title for the current list
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  titles[index],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              // Build the list of pairs
              ...permissionPairs.map((pair) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: pair.map((permission) {
                      return Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(3.0), // Adjust the padding
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(45, 128, 126, 126),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CheckboxListTile(
                              title: Text(
                                permission['name'],
                                style:
                                    TextStyle(fontSize: 14), // Reduce text size
                              ),
                              value: permission['value'],
                              visualDensity: VisualDensity.compact,
                              contentPadding: EdgeInsets
                                  .zero, // Reduce padding around the checkbox
                              controlAffinity: ListTileControlAffinity
                                  .leading, // Place the checkbox on the left
                              onChanged: (bool? value) {
                                setState(() {
                                  permission['value'] = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
