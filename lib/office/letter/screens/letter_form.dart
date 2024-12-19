import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet.dart';
import 'package:tenderboard/admin/cabinets_folders/model/cabinet_repo.dart';
import 'package:tenderboard/admin/cabinets_folders/model/folder.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master_repo.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';
import 'package:tenderboard/common/widgets/select_field.dart';
import 'package:tenderboard/office/letter/screens/letter_index_methods.dart';

class LetterForm extends ConsumerStatefulWidget {
  LetterForm({super.key, this.scanDocumnets});

  List<String>? scanDocumnets;

  @override
  _LetterFormState createState() => _LetterFormState();
}

class _LetterFormState extends ConsumerState<LetterForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _sendToController = TextEditingController();
  final TextEditingController _receivedFromController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _actionToBeController = TextEditingController();
  final TextEditingController _tenderNumberBeController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _referenceController.dispose();
    _sendToController.dispose();
    _receivedFromController.dispose();
    _summaryController.dispose();
    _subjectController.dispose();
    _actionToBeController.dispose();
    _tenderNumberBeController.dispose();
  }

  DateTime _createdDate = DateTime.now();
  DateTime? _dateOnTheLetter;
  DateTime? _receviedDate;
  final int currentUserId = 164;

  int _selectedYear = 2024;
  int? _selectedCabinet;
  final String _selectedCabinetName = '';
  int? _selectedFolder;
  int? _selectedDG;
  int? _selectedDepartment;
  int? _selectedUser;
  int? _selectedLocation;
  String _selectedPriority = 'High';
  String _selectedClassification = 'Confidential';
  String _selectedDirection = 'Incoming';
  String _selectedDirectionType = 'Internal';
  String _selectedLocationType = 'Government';
  bool _isNewLocation = true;
  int letterNo = 1101;

  List<SelectOption<Cabinet>> cabinetOptions = [];
  List<SelectOption<Folder>> folderOptions = [];
  List<SelectOption<DgMaster>> dgOptions = [];
  List<SelectOption<Department>> departmentOptions = [];
  List<SelectOption<ExternalLocation>> locationOptions = [];

  void save() {
    if (_formKey.currentState?.validate() ?? false) {
      final response = LetterUtils(
              actionToBeTaken: _actionToBeController.text,
              cabinet: _selectedCabinet,
              classification: 1, //replace
              comments: _summaryController.text,
              createdBy: currentUserId,
              dateOnTheLetter: _dateOnTheLetter,
              direction: _selectedDirection,
              externalLocation: _selectedLocation,
              folder: _selectedFolder,
              fromUser: currentUserId,
              locationId: _selectedLocation,
              priority: 0, //replace
              receivedDate: _receviedDate,
              reference: _referenceController.text,
              sendTo: _sendToController.text,
              subject: _subjectController.text,
              tenderNumber: _tenderNumberBeController.text,
              toUser: _selectedUser,
              year: _selectedYear,
              scanDocuments: widget.scanDocumnets)
          .onSave();
      print(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    _referenceController.text =
        'TB/$currentUserId/${_selectedDirection == 'Incoming' ? 1 : 2}-${_selectedDirectionType == 'Internal' ? 1 : 2}-$letterNo/$_selectedYear';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _letterForm1(ref),
              if (_selectedDirection == 'Outgoing' &&
                  _selectedDirectionType == 'External')
                _letterForm2(ref),
              _letterForm3(ref),
              ElevatedButton(
                onPressed: save,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Save form data logic

  Widget _letterForm1(
    WidgetRef ref,
  ) {
    final cabinetAsyncValue = ref.watch(cabinetOptionsProvider(true));
    cabinetOptions = cabinetAsyncValue.asData?.value ?? [];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              _referenceController.text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _selectedYear,
                decoration: InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: List.generate(
                  61, // Total range: 30 years before + current year + 30 years after
                  (index) {
                    int year = DateTime.now().year - 30 + index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year.toString()),
                    );
                  },
                ),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedYear = newValue;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value == null) {
                    return 'Please select Year';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(width: 5),
            // Created Date TextFormField with Calendar Icon
            Expanded(
              child: TextFormField(
                readOnly: true, // Disable manual input
                decoration: InputDecoration(
                  labelText: 'Created Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => selectDate(
                      context,
                      _createdDate,
                      (picked) => setState(() => _createdDate = picked),
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: DateFormat('yyyy-MM-dd').format(_createdDate),
                ),
              ),
            ),
            const SizedBox(width: 5),
            // Date on the Letter TextFormField with Calendar Icon
            Expanded(
              child: TextFormField(
                readOnly: true, // Disable manual input
                decoration: InputDecoration(
                  labelText: 'Date on the Letter',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => selectDate(
                      context,
                      _dateOnTheLetter ?? DateTime.now(),
                      (picked) => setState(() => _dateOnTheLetter = picked),
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: _dateOnTheLetter != null
                      ? DateFormat('yyyy-MM-dd').format(_dateOnTheLetter!)
                      : '', // Display empty string if null
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        // Row for Year, Cabinet, Folder
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => setState(() {
                _selectedDirection =
                    _selectedDirection == 'Incoming' ? 'Outgoing' : 'Incoming';
              }),
              icon: _selectedDirection == 'Incoming'
                  ? const Icon(Icons.arrow_circle_down_outlined)
                  : const Icon(Icons.arrow_circle_up_outlined),
              label: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(_selectedDirection),
              ),
            ),
            const SizedBox(width: 5),
            ElevatedButton.icon(
              onPressed: () => setState(() {
                _selectedDirectionType = _selectedDirectionType == 'Internal'
                    ? 'External'
                    : 'Internal';
              }),
              icon: _selectedDirectionType == 'Internal'
                  ? const Icon(Icons.arrow_circle_left_outlined)
                  : const Icon(Icons.arrow_circle_right_outlined),
              label: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(_selectedDirectionType),
              ),
            ),
            const SizedBox(width: 5),
            // Cabinet Selection
            Expanded(
              child: SelectField<Cabinet>(
                options: cabinetOptions,
                initialValue: _selectedCabinetName,
                onChanged: (cabinet, selectedOption) {
                  setState(() {
                    folderOptions = selectedOption.childOptions
                            ?.cast<SelectOption<Folder>>() ??
                        [];
                    _selectedFolder =
                        null; // Clear the selected folder when cabinet changes
                    _selectedCabinet = cabinet.id;
                  });
                },
                hint: 'Select Cabinet',
              ),
            ),
            const SizedBox(width: 5),

            Expanded(
              child: SelectField<Folder>(
                options: folderOptions,
                key: ValueKey(folderOptions),
                onChanged: (folder, selectedOption) {
                  setState(() {
                    _selectedFolder = folder.id;
                  });
                },
                hint: folderOptions.isNotEmpty
                    ? 'Select Folder'
                    : 'No Folders Available',
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _letterForm2(WidgetRef ref) {
    final locationAsyncValue = ref.watch(locationOptionsProvider);

    locationOptions = locationAsyncValue.asData?.value ?? [];
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () => setState(() {
                _selectedLocationType = _selectedLocationType == 'Government'
                    ? 'Others'
                    : _selectedLocationType == 'Others'
                        ? 'Add'
                        : 'Government';
              }),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(_selectedLocationType),
              ),
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                _isNewLocation = !_isNewLocation;
              }),
              child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(_isNewLocation ? 'New' : 'Old')),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: SelectField<ExternalLocation>(
                options: locationOptions.where((option) {
                  return option.filter == _selectedLocationType &&
                      option.filter1!.toString() == _isNewLocation.toString();
                }).toList(),
                onChanged: (location, selectedOption) {
                  setState(() {
                    // Clear the selected folder when cabinet changes
                    _selectedLocation = location.id;
                  });
                },
                hint: 'Select Location',
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        _buildTextField('Send To:', controller: _sendToController),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _letterForm3(WidgetRef ref) {
    final dgAsyncValue = ref.watch(dgOptionsProvider(true));
    dgOptions = dgAsyncValue.asData?.value ?? [];

    return Column(
      children: [
        _buildRow([
          _buildDropdownField('Classification', ['Confidential', 'Public'],
              value: _selectedClassification,
              onChanged: (value) =>
                  setState(() => _selectedClassification = value!)),
          _buildDropdownField('Priority', ['High', 'Normal', 'Low'],
              value: _selectedPriority,
              onChanged: (value) => setState(() => _selectedPriority = value!))
        ]),
        const SizedBox(height: 5),
        _buildRow([
          _buildTextField('Received From:',
              controller: _tenderNumberBeController),
          _buildTextField('Tender Number:'),
        ]),
        const SizedBox(height: 5),
        _buildRow([
          Expanded(
            child: SelectField<DgMaster>(
              options: dgOptions,
              onChanged: (dg, selectedOption) {
                setState(() {
                  departmentOptions = selectedOption.childOptions
                          ?.cast<SelectOption<Department>>() ??
                      [];
                  _selectedDepartment = null;
                  _selectedDG = dg.id;
                });
              },
              hint: 'Select DG',
            ),
          ),
          Expanded(
            child: SelectField<Department>(
              options: departmentOptions,
              key: ValueKey(departmentOptions),
              onChanged: (department, selectedOption) {
                setState(() {
                  _selectedDepartment = department.id;
                });
              },
              hint: departmentOptions.isNotEmpty
                  ? 'Select Department'
                  : 'No Department Available',
            ),
          ),
        ]),
        const SizedBox(height: 5),
        _buildTextField('User:'),
        const SizedBox(height: 5),

        // Summary and Action to be Taken
        _buildRow([
          _buildTextField('Summary:', controller: _summaryController),
          _buildTextField('Action to be Taken:',
              controller: _actionToBeController)
        ]),
        const SizedBox(height: 5),

        // Letter Subject
        _buildTextField('Letter Subject:', controller: _subjectController),

        // Save button
        const SizedBox(height: 10),
      ],
    );
  }

  // Helper to create rows of fields
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

  // Text Field widget
  Widget _buildTextField(String label, {TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  // Dropdown Field widget
  Widget _buildDropdownField(String label, List<String> options,
      {required String value, required Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
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
          return 'Please select $label';
        }
        return null;
      },
    );
  }
}
