import 'package:flutter/material.dart';

class ScanIndexHomeForm extends StatefulWidget {
  const ScanIndexHomeForm({super.key});

  @override
  _ScanIndexHomeFormState createState() => _ScanIndexHomeFormState();
}

class _ScanIndexHomeFormState extends State<ScanIndexHomeForm> {
  // Form key to manage form state
  final _formKey = GlobalKey<FormState>();

  // Variable to track the selected radio button value

  // Controllers for the text fields (can be used for validation or to access values)
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _externalLocationController =
      TextEditingController();
  final TextEditingController _sendToController = TextEditingController();
  final TextEditingController _receivedFromController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _letterSubjectController =
      TextEditingController();

  // Variables to track selected dropdown values
  String _selectedYear = "2024";
  String _selectedCabinet = "Cabinet 1";
  String _selectedFolder = "Folder A";
  String _selectedPriority = "High";
  String _selectedClassification = "Confidential";

  // Variable to track the selected values for each radio group
  String _selectedDirection = "Incoming";
  String _selectedDirectionType = "Internal";
  String _selectedLocationType = "Government";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey, // Attach the form key to the form widget
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column 1 - Reference #
              _buildTextField("Reference # : ", controller: _referenceController),
              SizedBox(height: 5),

              // Column 2 - Year, Cabinet, Folder (3 fields in a row)
              Row(
                children: [
                  Expanded(
                      child: _buildDropdownField("Year : ", ["2024", "2025"],
                          value: _selectedYear,
                          onChanged: (value) =>
                              setState(() => _selectedYear = value!))),
                  SizedBox(width: 3),
                  Expanded(
                      child: _buildDropdownField(
                          "Cabinet", ["Cabinet 1", "Cabinet 2"],
                          value: _selectedCabinet,
                          onChanged: (value) =>
                              setState(() => _selectedCabinet = value!))),
                  SizedBox(width: 3),
                  Expanded(
                      child: _buildDropdownField(
                          "Folder", ["Folder A", "Folder B"],
                          value: _selectedFolder,
                          onChanged: (value) =>
                              setState(() => _selectedFolder = value!))),
                ],
              ),
              SizedBox(height: 5),

              // Column 3 - Direction, Direction Type, Location Type
              Row(
                children: [
                  Expanded(
                    child: _buildRadioField(
                      label: "Direction",
                      options: ["Incoming", "Outgoing"],
                      groupValue: _selectedDirection,
                      onChanged: (value) =>
                          setState(() => _selectedDirection = value!),
                    ),
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: _buildRadioField(
                      label: "Direction Type",
                      options: ["Internal", "External"],
                      groupValue: _selectedDirectionType,
                      onChanged: (value) =>
                          setState(() => _selectedDirectionType = value!),
                    ),
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: _buildRadioField(
                      label: "Location Type",
                      options: ["Government", "Others"],
                      groupValue: _selectedLocationType,
                      onChanged: (value) =>
                          setState(() => _selectedLocationType = value!),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 5),

              // Column 4 - External Location
              _buildTextField("External Location : ",
                  controller: _externalLocationController),
              SizedBox(height: 5),

              // Column 5 - Send To
              _buildTextField("Send To : ", controller: _sendToController),
              SizedBox(height: 5),

              // Column 6 - Received From, Priority, Classification
              _buildRow([
                _buildTextField("Received From : ",
                    controller: _receivedFromController),
                _buildDropdownField("Priority", ["High", "Normal", "Low"],
                    value: _selectedPriority,
                    onChanged: (value) =>
                        setState(() => _selectedPriority = value!))
              ]),
              _buildRow([
                _buildDropdownField(
                    "Classification", ["Confidential", "Public"],
                    value: _selectedClassification,
                    onChanged: (value) =>
                        setState(() => _selectedClassification = value!)),
                _buildTextField("Created By")
              ]),
              SizedBox(height: 5),

              // Column 7 - DG
              _buildTextField("DG : "),
              SizedBox(height: 5),

              // Column 8 - Department
              _buildTextField("Department : "),
              SizedBox(height: 5),

              // Column 9 - User
              _buildTextField("User : "),
              SizedBox(height: 5),

              // Column 10 - Summary, Action to be Taken
              _buildRow([
                _buildTextField("Summary : ", controller: _summaryController),
                _buildTextField("Action to be Taken : ")
              ]),
              SizedBox(height: 5),

              // Column 11 - Letter Subject
              _buildTextField("Letter Subject :   ",
                  controller: _letterSubjectController),

              // Save button
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Collect all form input values
                    String reference = _referenceController.text;
                    String year = _selectedYear;
                    String cabinet = _selectedCabinet;
                    String folder = _selectedFolder;
                    String externalLocation = _externalLocationController.text;
                    String sendTo = _sendToController.text;
                    String receivedFrom = _receivedFromController.text;
                    String priority = _selectedPriority;
                    String classification = _selectedClassification;
                    String summary = _summaryController.text;
                    String letterSubject = _letterSubjectController.text;
                    // Example of processing the collected values (e.g., saving, sending to an API, etc.)
                    _saveFormData(
                        reference,
                        year,
                        cabinet,
                        folder,
                        externalLocation,
                        sendTo,
                        receivedFrom,
                        priority,
                        classification,
                        summary,
                        letterSubject);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to save form data
  void _saveFormData(
      String reference,
      String year,
      String cabinet,
      String folder,
      String externalLocation,
      String sendTo,
      String receivedFrom,
      String priority,
      String classification,
      String summary,
      String letterSubject) {
    // You can process the values here (e.g., send them to an API, save to local storage, etc.)
    // For now, just display them in a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Saved: $reference, $year, $cabinet, $folder, $externalLocation, $sendTo, $receivedFrom, $priority, $classification, $summary, $letterSubject')));
  }

  // Helper method to create a row with two fields
  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: children
            .map((child) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: child,
                  ),
                ))
            .toList(),
      ),
    );
  }

  // Helper method to create a text field with a label
  Widget _buildTextField(String label, {TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Container(
         
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(label,style: TextStyle(fontSize: 15),),
            
            
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String label, List<String> options,
      {required String value, required Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      items: options.map((option) {
        return DropdownMenuItem(
          child: Text(option, style: TextStyle(fontSize: 14)),
          value: option,
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
    );
  }

  // Helper method to create a radio field group
  Widget _buildRadioField({
    required String label,
    required List<String> options,
    required String groupValue,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        ...options.map((option) {
          return RadioListTile<String>(
            title: Text(
              option,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            value: option,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: Colors.blue,
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
          );
        }).toList(),
      ],
    );
  }
}
