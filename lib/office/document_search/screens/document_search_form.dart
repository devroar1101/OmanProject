import 'package:flutter/material.dart';

class DocumentSearchForm extends StatefulWidget {
  DocumentSearchForm({super.key});

  @override
  _DocumentSearchFormState createState() => _DocumentSearchFormState();
}

class _DocumentSearchFormState extends State<DocumentSearchForm> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _tenderNumberController = TextEditingController();
  final TextEditingController _letterDateFromController =
      TextEditingController();
  final TextEditingController _letterDateToController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _receivedFromController = TextEditingController();
  final TextEditingController _receivedToController = TextEditingController();
  String _scanType = 'Type 1';
  String _direction = 'All';

  void _resetFields() {
    _subjectController.clear();
    _tenderNumberController.clear();
    _letterDateFromController.clear();
    _letterDateToController.clear();
    _locationController.clear();
    _referenceController.clear();
    _receivedFromController.clear();
    _receivedToController.clear();
    setState(() {
      _scanType = 'Type 1';
      _direction = 'All';
    });
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
          children: [
            Row(
              children: [
                _buildDropdownField(
                    'Scan Type', _scanType, ['Type 1', 'Type 2']),
                const SizedBox(width: 8.0),
                _buildTextField('Subject', _subjectController),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                _buildTextField('Tender Number', _tenderNumberController),
                const SizedBox(width: 8.0),
                _buildDateField('Letter Date From', _letterDateFromController),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                _buildDateField('Letter Date To', _letterDateToController),
                const SizedBox(width: 8.0),
                _buildTextField('Location', _locationController),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  flex: 1, // Adjust if you want to control the width ratio
                  child: _buildTextField('Reference#', _referenceController),
                ),
                const SizedBox(width: 8.0), // Spacing between the fields
                _buildRadioField('Direction', ['Incoming', 'Outgoing', 'All']),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                _buildDateField('Received From', _receivedFromController),
                const SizedBox(width: 8.0),
                _buildDateField('Received To', _receivedToController),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                _buildIconButton(Icons.search, 'Search', () {}),
                _buildIconButton(Icons.refresh, 'Reset', _resetFields),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> options) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _scanType = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildRadioField(String label, List<String> options) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options.map((String option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: _direction,
            onChanged: (newValue) {
              setState(() {
                _direction = newValue!;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            controller.text = date.toString().substring(0, 10);
          }
        },
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon, String tooltip, VoidCallback onPressed) {
    return Card(
      color: const Color.fromARGB(255, 238, 240, 241),
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}
