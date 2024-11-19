import 'package:flutter/material.dart';

class ReplyJobForm extends StatefulWidget {
  @override
  _ReplyJobFormState createState() => _ReplyJobFormState();
}

class _ReplyJobFormState extends State<ReplyJobForm> {
  // Create a GlobalKey to manage form state
  final _formKey = GlobalKey<FormState>();

  // Controllers for the fields
  final TextEditingController _classificationController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _replyDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attach the GlobalKey to the Form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Follow-Up Jobs',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16.0),

              // Field: Classification
              _buildSingleRowField('Classification', _classificationController),
              const SizedBox(height: 16.0),

              // Field: Priority
              _buildSingleRowField('Priority', _priorityController),
              const SizedBox(height: 16.0),

              // Field: Reply Date
              _buildSingleRowField('Reply Date', _replyDateController),
              const SizedBox(height: 16.0),

              // Save Button at the bottom
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle save action here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Form Saved!')),
                      );
                    }
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build a single field row with validation
  Widget _buildSingleRowField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }
}
