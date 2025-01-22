import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/widgets/custom_snackbar.dart';
import 'package:tenderboard/office/ejob/model/create_ejob.dart';
import 'package:tenderboard/office/ejob/model/ejob_create_repo.dart';
import 'package:tenderboard/office/letter/model/letter_action.dart';
import 'package:uuid/uuid.dart';

class EjobForm extends StatefulWidget {
  const EjobForm({Key? key}) : super(key: key);

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
  final TextEditingController _subjectController = TextEditingController();

  static const Uuid _uuid = Uuid();

  // Dropdown and date variables
  int selectedPriority = 1;
  int selectedClassification = 1;
  DateTime? _expectedResponseDate;

  Future<void> onSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final objectId = _uuid.v4();
    final ejob = Ejob(
      classificationId: selectedClassification,
      priorityId: selectedPriority,
      subject: _subjectController.text,
      expectedResponseDate: _expectedResponseDate.toString(),
      objectId: objectId
    );
    final letterAction = LetterAction(
        actionId: 1,
        comments: '',
        classificationId: selectedClassification ?? 0,
        priorityId: selectedPriority ?? 0,
        fromUserId: 0,
        locationId:  0,
        pageSelected: 'All',
        sequenceNo: 1,
        toUserId: 0,
        objectId: objectId,
      );
    final repo = ProviderContainer();
    try {
      await Future.wait([
        repo.read(ejobRepositoryProvider).createEjob(ejob.toMap()),
      ]);
      CustomSnackbar.show(
        context: context,
        durationInSeconds: 3,
        message: 'Letter saved successfully',
        title: 'Successful',
        typeId: 1,
        asset: 'assets/saving.gif',
      );
    } catch (e) {
      CustomSnackbar.show(
        context: context,
        durationInSeconds: 3,
        message: 'Failed to save the letter',
        title: 'Error',
        typeId: 2,
        asset: 'assets/error.gif',
      );
    }
  }

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
                const SizedBox(height: 10),

                // Cabinet/Folder
                _buildTextField(
                  "Cabinet/Folder : ",
                  controller: _cabinetFolderController,
                ),
                const SizedBox(height: 10),

                // Priority and Classification (Dropdowns)
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField<int>(
                        "Priority",
                        value: selectedPriority,
                        items: List.generate(3, (index) => index + 1),
                        onChanged: (value) {
                          setState(() => selectedPriority = value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdownField<int>(
                        "Classification",
                        value: selectedClassification,
                        items: List.generate(3, (index) => index + 1),
                        onChanged: (value) {
                          setState(() => selectedClassification = value!);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Expected Response Date
                _buildDateField(
                  "Expected Response Date",
                  _expectedResponseDate,
                  (date) => setState(() => _expectedResponseDate = date),
                ),
                const SizedBox(height: 10),

                // Subject (Rich Text Field)
                _buildRichTextField(),
                const SizedBox(height: 30),

                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: () => onSave(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 20.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
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
        labelText: label,
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

  Widget _buildDropdownField<T>(
    String label, {
    required T value,
    required List<T> items,
    required Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return "Please select $label";
        }
        return null;
      },
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
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
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
          child: TextField(
            controller: _subjectController,
            maxLines: null,
            expands: true,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: "Enter subject...",
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
