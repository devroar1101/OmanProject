import 'package:flutter/material.dart';
import 'package:tenderboard/office/scan_document_summary/model/scan_document_summary.dart';

class ScanDocumentSummaryForm extends StatelessWidget {
  final ScanDocumentSummary ScanSummaryItem;
  const ScanDocumentSummaryForm(this.ScanSummaryItem, {super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Column 1 - Reference #
            _buildTextField("Reference #",
                value: ScanSummaryItem.referenceNumber),
            const SizedBox(height: 5), // Reduced space between fields

            // Column 2 - Year, Cabinet, Folder (3 fields in a row)
            Row(
              children: [
                Expanded(
                    child: _buildDropdownField("Year", ["2024", "2025"],
                        value: ScanSummaryItem.year)),
                const SizedBox(width: 3), // Reduced space between fields
                Expanded(
                    child: _buildDropdownField(
                        "Cabinet", ["Cabinet 1", "Cabinet 2"])),
                const SizedBox(width: 3), // Reduced space between fields
                Expanded(
                    child: _buildDropdownField(
                        "Folder", ["Folder A", "Folder B"])),
              ],
            ),
            const SizedBox(height: 5), // Reduced space between rows

            // Column 3 - Direction, Direction Type, Location Type (3 fields in a row)
            Row(
              children: [
                Expanded(
                    child: _buildRadioField(
                        ["Incoming", "Outgoing"], "direction")),
                const SizedBox(
                  width: 3,
                  height: 3,
                ), // Reduced space between fields
                Expanded(
                    child: _buildRadioField(
                        ["Internal", "External"], "directionType")),
                const SizedBox(
                  width: 3,
                  height: 3,
                ), // Reduced space between fields
                Expanded(
                    child: _buildRadioField(
                        ["Government", "Others"], "locationType")),
              ],
            ),
            const SizedBox(height: 5), // Reduced space between rows

            // Column 4 - External Location (single field)
            _buildTextField("External Location",
                value: ScanSummaryItem.fromExternalLocationNameEnglish),
            const SizedBox(height: 5), // Reduced space between fields

            // Column 5 - Send To (single field)
            _buildTextField("Send To", value: ScanSummaryItem.sendTo),
            const SizedBox(height: 5), // Reduced space between fields

            // Column 6 - Received From, Priority, Classification, Created By, Tender Number, Letter Date, Letter Number, Tender Status (2 fields in a row)
            _buildRow([
              _buildTextField("Received From"),
              _buildDropdownField("Priority", ["High", "Normal", "Low"])
            ]),
            _buildRow([
              _buildDropdownField("Classification", ["Confidential", "Public"]),
              _buildTextField("Created By")
            ]),
            _buildRow([
              _buildTextField("Tender Number"),
              _buildTextField("Letter Date")
            ]),
            _buildRow([
              _buildTextField("Letter Number"),
              _buildDropdownField("Tender Status", ["Open", "Closed"])
            ]),
            const SizedBox(height: 5), // Reduced space between rows

            // Column 7 - DG (single field)
            _buildTextField("DG", value: ScanSummaryItem.toDgNameEnglish),
            const SizedBox(height: 5), // Reduced space between fields

            // Column 8 - Department (single field)
            _buildTextField("Department",
                value: ScanSummaryItem.toDepartmentNameEnglish),
            const SizedBox(height: 5), // Reduced space between fields

            // Column 9 - User (single field)
            _buildTextField("User", value: ScanSummaryItem.userName),
            const SizedBox(height: 5), // Reduced space between fields

            // Column 10 - Summary, Action to be Taken (2 fields in a row)
            _buildRow([
              _buildTextField("Summary", value: ScanSummaryItem.comment),
              _buildTextField("Action to be Taken",
                  value: ScanSummaryItem.actionToBetaken)
            ]),
            const SizedBox(height: 5), // Reduced space between fields

            // Column 11 - Letter Subject (single field)
            _buildTextField("Letter Subject",
                value: ScanSummaryItem.letterSubjectName),
          ],
        ),
      ),
    );
  }

  // Helper method to create a row with two fields
  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: children
            .map((child) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 2.0), // Reduced horizontal margin
                    child: child,
                  ),
                ))
            .toList(),
      ),
    );
  }

  // Helper method to create a text field with a label
  Widget _buildTextField(String label, {String? value}) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 12.0), // Smaller padding
        isDense: true, // Makes the field smaller
      ),
    );
  }

  // Helper method to create a dropdown field with options
  Widget _buildDropdownField(String label, List<String> options,
      {String? value, ValueChanged<String?>? onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 12.0), // Smaller padding
        isDense: true, // Makes the field smaller
      ),
      items: options.map((option) {
        return DropdownMenuItem(value: option, child: Text(option));
      }).toList(),
      onChanged: onChanged ?? (value) {},
    );
  }

  // Helper method to create a radio field group without label
  Widget _buildRadioField(List<String> options, String groupValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((option) {
        return RadioListTile(
          title: Text(option),
          value: option,
          groupValue: groupValue,
          onChanged: (value) {},
          contentPadding:
              const EdgeInsets.all(0), // Reduce padding for a smaller field
        );
      }).toList(),
    );
  }
}
