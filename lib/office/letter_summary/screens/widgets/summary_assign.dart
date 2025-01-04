import 'package:flutter/material.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';
import 'package:tenderboard/common/widgets/select_user.dart';

class JobAssignForm extends StatefulWidget {
  const JobAssignForm({super.key});

  @override
  _JobAssignFormState createState() => _JobAssignFormState();
}

class _JobAssignFormState extends State<JobAssignForm> {
  // Create a GlobalKey to manage form state
  final _formKey = GlobalKey<FormState>();

  // Controllers for each TextFormField
  final TextEditingController _classificationController =
      TextEditingController();
  final TextEditingController _followUpDateController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _replyDateController = TextEditingController();
  final TextEditingController _personalGroupController =
      TextEditingController();
  final TextEditingController _dgController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _commentTypeController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _modifyCommentController =
      TextEditingController();

  // User selection data
  List<User> userList = [];

  List<User> selectedUsers = [];

  void _onSelectionChanged(List<User> selectedUsers) {
    setState(() {
      this.selectedUsers = selectedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attach the GlobalKey to the Form
          child: Column(
            children: [
              Text(
                'Job Assign',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16.0),
              _buildRow([
                _buildField('Classification', _classificationController),
                _buildField('Follow-Up Date', _followUpDateController),
              ]),
              const SizedBox(height: 8.0),
              _buildRow([
                _buildField('Priority', _priorityController),
                _buildField('Reply Date', _replyDateController),
              ]),
              const SizedBox(height: 8.0),
              _buildSingleField('Personal Group', _personalGroupController),
              const SizedBox(height: 8.0),
              _buildSingleField('DG', _dgController),
              const SizedBox(height: 8.0),
              _buildSingleField('Department', _departmentController),
              const SizedBox(height: 8.0),
              _buildSingleField('Section', _sectionController),
              const SizedBox(height: 8.0),
              _buildSingleField('Comment Type', _commentTypeController),
              const SizedBox(height: 8.0),
              _buildSingleField('Comment', _commentController),
              const SizedBox(height: 8.0),
              _buildSingleField('Modify Comment', _modifyCommentController),
              const SizedBox(height: 16.0),

              // Add the SelectUserWidget
              const Text(
                'Assign Users',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              SelectUserWidget(
                userList: userList,
                selectedUsers: selectedUsers,
                onSelectionChanged: _onSelectionChanged,
              ),
              const SizedBox(height: 16.0),

              ElevatedButton(
                onPressed: () {
                  // Validate the form
                  if (_formKey.currentState!.validate()) {
                    // Perform save action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form Saved!')),
                    );
                    print(
                        'Selected Users: ${selectedUsers.map((u) => u.systemName).toList()}');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill all fields correctly.')),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build a row with two fields
  Widget _buildRow(List<Widget> children) {
    return Row(
      children: children
          .map(
            (field) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: field,
              ),
            ),
          )
          .toList(),
    );
  }

  // Build a single text field with validation
  Widget _buildField(String label, TextEditingController controller) {
    return SizedBox(
      height: 40, // Smaller height for compact design
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 14), // Smaller font size
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 12), // Smaller label font size
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 10.0,
          ), // Reduced padding for compact size
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  // Build a single field without a row
  Widget _buildSingleField(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40, // Smaller height for compact design
            child: TextFormField(
              controller: controller,
              style: const TextStyle(fontSize: 14), // Smaller font size
              decoration: InputDecoration(
                labelText: label,
                labelStyle:
                    const TextStyle(fontSize: 12), // Smaller label font size
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 10.0,
                ), // Reduced padding for compact size
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '$label is required';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
