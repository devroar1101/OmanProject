import 'package:flutter/material.dart';

class EjobForm extends StatefulWidget {
  const EjobForm({super.key});

  @override
  _EjobFormState createState() => _EjobFormState();
}

class _EjobFormState extends State<EjobForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _referenceNumberController =
      TextEditingController();
  final TextEditingController _cabinetFolderController =
      TextEditingController();

  // Dropdown and date variables
  String _selectedPriority = "High";
  String _selectedClassification = "Confidential";
  DateTime? _expectedResponseDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reference Number
                _buildTextField(
                  "Reference Number : ",
                  controller: _referenceNumberController,
                ),
                const SizedBox(height: 5),

                // Cabinet/Folder
                _buildTextField(
                  "Cabinet/Folder : ",
                  controller: _cabinetFolderController,
                ),
                const SizedBox(height: 5),

                // Priority and Classification (Dropdowns)
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        "Priority ",
                        ["High", "Medium", "Low"],
                        value: _selectedPriority,
                        onChanged: (value) =>
                            setState(() => _selectedPriority = value!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdownField(
                        "Classification ",
                        ["Confidential", "Internal", "Public"],
                        value: _selectedClassification,
                        onChanged: (value) =>
                            setState(() => _selectedClassification = value!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Expected Response Date
                _buildDateField(
                  "Expected Response Date",
                  _expectedResponseDate,
                  (date) => setState(() => _expectedResponseDate = date),
                ),
                const SizedBox(height: 5),

                // Subject (Rich Text Field)
                _buildRichTextField(),
                const SizedBox(height: 30),

                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Task saved successfully!")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $label";
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String label, List<String> options,
      {required String value, required Function(String?) onChanged}) {
    return Wrap(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
            ),
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select $label";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
      String label, DateTime? date, Function(DateTime?) onDateChanged) {
    return GestureDetector(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        onDateChanged(selectedDate);
      },
      child: Wrap(
        children: [
          // Label text
          Text(
            label,
            style: const TextStyle( fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 10), // Space between label and date field

          // Date field display
          Expanded(
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 10.0),
              ),
              child: Text(
                date != null
                    ? "${date.day}/${date.month}/${date.year}"
                    : "Select a date",
                style: TextStyle(
                  color: date != null ? Colors.black : Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Subject",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Container(
          height: 150,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey),
          ),
          child: const TextField(
            maxLines: null,
            expands: true,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: "Enter subject...",
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
