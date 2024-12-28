import 'package:flutter/material.dart';

class FollowUpJobsForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  FollowUpJobsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Follow-Up Jobs',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16.0),
              _buildSingleField('Classification'),
              const SizedBox(height: 8.0),
              _buildSingleField('Priority'),
              const SizedBox(height: 8.0),
              _buildSingleField('Reply Date'),
              const SizedBox(height: 8.0),
              _buildSingleField('Personal Group'),
              const SizedBox(height: 8.0),
              _buildSingleField('DG'),
              const SizedBox(height: 8.0),
              _buildSingleField('Department'),
              const SizedBox(height: 8.0),
              _buildSingleField('Section'),
              const SizedBox(height: 8.0),
              _buildSingleField('Comment Type'),
              const SizedBox(height: 8.0),
              _buildSingleField('Comment'),
              const SizedBox(height: 8.0),
              _buildSingleField('Modify Comment'),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Perform save logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Data Saved Successfully!')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleField(String label) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 12.0,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
    );
  }
}
