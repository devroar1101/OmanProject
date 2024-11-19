import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class SuspendJobForm extends StatefulWidget {
  @override
  _SuspendJobFormState createState() => _SuspendJobFormState();
}

class _SuspendJobFormState extends State<SuspendJobForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _suspendTillController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  String? _attachmentFileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Suspend Jobs',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16.0),
              _buildSingleRowField('Suspend Till', _suspendTillController),
              const SizedBox(height: 16.0),
              _buildSingleRowField('Comments', _commentsController),
              const SizedBox(height: 16.0),
              _buildAttachmentField(),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
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

  Widget _buildAttachmentField() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _attachmentFileName ?? 'No file selected',
            style: TextStyle(
              color: _attachmentFileName != null ? Colors.green : Colors.grey,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.attach_file),
          onPressed: () async {
            print('File picker opened');  // Debugging line
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            if (result != null) {
              setState(() {
                _attachmentFileName = result.files.single.name;
              });
              print('File selected: ${_attachmentFileName}'); // Debugging line
            } else {
              print('No file selected'); // Debugging line
              setState(() {
                _attachmentFileName = null;
              });
            }
          },
        ),
      ],
    );
  }
}
