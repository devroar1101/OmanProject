import 'package:flutter/material.dart';
//import 'package:html/html.dart' as html;

class CloseJobForm extends StatefulWidget {
  const CloseJobForm({super.key});

  @override
  _CloseJobFormState createState() => _CloseJobFormState();
}

class _CloseJobFormState extends State<CloseJobForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _suspendTillController = TextEditingController();
  final TextEditingController _richTextController = TextEditingController();

  String? _attachmentFileName;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSingleRowField('Suspend Till', _suspendTillController),
          const SizedBox(height: 16.0),
          _buildRichTextField('Job Description'),
          const SizedBox(height: 16.0),
          _buildAttachmentField(),
          const SizedBox(height: 16.0),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Form Saved!')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single row field for basic input.
  Widget _buildSingleRowField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  /// Builds a rich text field for multi-line input.
  Widget _buildRichTextField(String label) {
    return TextFormField(
      controller: _richTextController,
      maxLines: 6, // Adjust height for multi-line input
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true, // Align label for multi-line
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  /// Builds the file attachment field with a button.
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
          icon: const Icon(Icons.attach_file),
          onPressed: () {
            // final html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
            //   ..accept = '*/*'; // Accept all file types
            // uploadInput.click();

            // uploadInput.onChange.listen((e) {
            //   final files = uploadInput.files;
            //   if (files?.isEmpty ?? true) return;

            //   final file = files!.first;
            //   setState(() {
            //     _attachmentFileName = file.name;
            //   });
            // });
          },
        ),
      ],
    );
  }
}
