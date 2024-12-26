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
import 'package:tenderboard/admin/user_master/model/user_master.dart';
import 'package:tenderboard/admin/user_master/model/user_master_repo.dart';
import 'package:tenderboard/common/model/global_enum.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';
import 'package:tenderboard/common/widgets/select_field.dart';
import 'package:tenderboard/office/letter_summary/model/letter_summary_repo.dart';
import 'package:tenderboard/office/letter/screens/letter_index_methods.dart';

// ignore: must_be_immutable
class LetterForm extends ConsumerStatefulWidget {
  LetterForm({super.key, this.scanDocumnets, this.letterObjectId});

  List<String>? scanDocumnets;
  String? letterObjectId;

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

  DateTime _createdDate = DateTime.now();
  DateTime? _dateOnTheLetter;
  DateTime? _receviedDate;
  final int currentUserId = 164;
  int selectedYear = 2024;
  int? _selectedCabinet;
  String _selectedCabinetName = '';
  int? _selectedFolder;
  String _selectedFolderName = '';
  int? _selectedDG;
  String _selectedDGName = '';
  int? _selectedDepartment;
  String _selectedDepartmentName = '';
  int? _selectedUser;
  String _selectedUserName = '';
  int? _selectedLocation;
  String _selectedLocationName = '';
  int selectedPriority = 1;
  int selectedClassification = 1;
  String _selectedDirection = 'Incoming';
  String _selectedDirectionType = 'Internal';
  String _selectedLocationType = 'Government';
  bool _isNewLocation = true;
  int letterNo = 1101;

  late List<SelectOption<Cabinet>> cabinetOptions = [];
  late List<SelectOption<Folder>> folderOptions = [];
  late List<SelectOption<DgMaster>> dgOptions = [];
  late List<SelectOption<Department>> departmentOptions = [];
  late List<SelectOption<ExternalLocation>> locationOptions = [];
  late List<SelectOption<UserMaster>> usersOptions = [];
  late List<SelectOption<UserMaster>> filteredUserOption = [];

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

  @override
  void initState() {
    super.initState();
    initialise();
  }

  void initialise() async {
    // Check if widget.letterObjectId is null
    if (widget.letterObjectId == null) {
      // Fetch options for cabinet, location, and dg when letterObjectId is null
      final cabinetAsyncValue = ref.read(cabinetOptionsProvider(true));
      cabinetOptions = cabinetAsyncValue.asData?.value ?? [];

      final locationAsyncValue = ref.read(locationOptionsProvider);
      locationOptions = locationAsyncValue.asData?.value ?? [];

      final dgAsyncValue = ref.read(dgOptionsProvider(true));
      dgOptions = dgAsyncValue.asData?.value ?? [];
    } else {
      // When letterObjectId is not null, fetch the letter summary
      final letterSummaryFuture = ref
          .read(letterSummaryRepositoryProvider)
          .fetchLetterSummary(widget.letterObjectId!);

      letterSummaryFuture.then((letter) {
        // After fetching the letter summary, initialize your variables
        setState(() {
          // Assign values to the controllers and other variables
          _referenceController.text = letter.referenceNumber ?? '';
          _sendToController.text = letter.referenceNumber ?? ''; //missing
          _summaryController.text = letter.summary ?? '';
          _subjectController.text = letter.subject ?? '';
          _actionToBeController.text = letter.actionToBeTaken ?? '';
          _tenderNumberBeController.text = letter.tenderNumber ?? '';

          //  _createdDate = letter.createdDate ?? DateTime.now(); date type
          // _dateOnTheLetter = letter.dateOnTheLetter;
          // _receviedDate = letter.receivedDate;

          //selectedYear = letter.year!;

          _selectedCabinetName = letter.cabinetName ?? '';

          _selectedFolderName = letter.folderName ?? '';

          _selectedDGName = letter.dgName ?? '';

          _selectedDepartmentName = letter.departmentName ?? '';

          _selectedUserName = letter.systemName ?? '';

          _selectedLocationName = letter.locationName ?? '';
          // selectedPriority = letter.priority!;
          //selectedClassification = letter.classificationId!;
          _selectedDirection = letter.direction ?? 'Incoming';
          _selectedDirectionType = letter.directionType ?? 'Internal';
          cabinetOptions = [];
          folderOptions = [];
          dgOptions = [];
          departmentOptions = [];
          locationOptions = [];
          usersOptions = [];
          filteredUserOption = [];
        });
      }).catchError((error) {
        // Handle any errors during the fetch
        print("Error fetching letter summary: $error");
      });
    }
    setState(() {});
  }

  void save() {
    if (_formKey.currentState?.validate() ?? false) {
      final response = LetterUtils(
              actionToBeTaken: _actionToBeController.text,
              cabinet: _selectedCabinet,
              classification: selectedClassification, //replace
              comments: _summaryController.text,
              createdBy: currentUserId,
              dateOnTheLetter: _dateOnTheLetter,
              direction: _selectedDirection,
              externalLocation: _selectedLocation,
              folder: _selectedFolder,
              fromUser: currentUserId,
              locationId: _selectedLocation,
              priority: selectedPriority, //replace
              receivedDate: _receviedDate,
              reference: _referenceController.text,
              sendTo: _sendToController.text,
              subject: _subjectController.text,
              tenderNumber: _tenderNumberBeController.text,
              toUser: _selectedUser,
              year: selectedYear,
              scanDocuments: widget.scanDocumnets)
          .onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    _referenceController.text =
        'TB/$currentUserId/${_selectedDirection == 'Incoming' ? 1 : 2}-${_selectedDirectionType == 'Internal' ? 1 : 2}-$letterNo/$selectedYear';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRow([
          Row(
            children: [
              SizedBox(
                width: 100, // Provide more space for the dropdown
                child: DropdownButtonFormField<int>(
                  value: selectedYear,
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
                        selectedYear = newValue;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select Year';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                  width: 20), // Add spacing between dropdown and card
              Expanded(
                child: Card(
                  elevation:
                      3, // Increased elevation for a more prominent shadow
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12.0), // Smoother corners
                  ),
                  color: Colors.blue.shade50, // Light blue background
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 8.0), // Generous padding
                    child: Center(
                      // Center-align the text
                      child: Text(
                        _referenceController.text,
                        style: const TextStyle(
                          fontSize: 18, // Larger font size
                          fontWeight: FontWeight.bold, // Bold text
                          // Accent color for the text
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
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
            const SizedBox(width: 5),
            // Date on the Letter TextFormField with Calendar Icon
            Expanded(
              child: TextFormField(
                readOnly: true, // Disable manual input
                decoration: InputDecoration(
                  labelText: 'Recevied Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => selectDate(
                      context,
                      _receviedDate ?? DateTime.now(),
                      (picked) => setState(() => _receviedDate = picked),
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: _receviedDate != null
                      ? DateFormat('yyyy-MM-dd').format(_receviedDate!)
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
                key: ValueKey(cabinetOptions),
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
                initialValue: _selectedFolderName,
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
                key: ValueKey(locationOptions),
                initialValue: _selectedLocationName,
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
    if (_selectedDG != null) {
      final userAsyncValue = ref.read(userOptionsProvider);
      if (usersOptions.isEmpty) {
        usersOptions = userAsyncValue.asData?.value ?? [];
      }

      filteredUserOption = usersOptions.where((option) {
        bool matchesDG =
            (_selectedDG == null || option.filter == _selectedDG.toString());

        bool matchesDepartment = (_selectedDepartment == null ||
            option.filter1 == _selectedDepartment.toString());

        return matchesDG && matchesDepartment;
      }).toList();
    } else {
      filteredUserOption = [];
    }

    return Column(
      children: [
        const SizedBox(height: 5),
        _buildRow([
          Expanded(
            child: DropdownButtonFormField<int>(
              value: selectedPriority,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: Priority.values.map((Priority item) {
                return DropdownMenuItem<int>(
                  value: item.id,
                  child: Text(item.getLabel(context)),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedPriority = newValue;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: DropdownButtonFormField<int>(
              value: selectedClassification,
              decoration: InputDecoration(
                labelText: 'Classification',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: Classification.values.map((Classification item) {
                return DropdownMenuItem<int>(
                  value: item.id,
                  child: Text(item.getLabel(context)),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedClassification = newValue;
                  });
                }
              },
            ),
          ),
        ]),
        const SizedBox(height: 5),
        _buildRow([
          _buildTextField(
            'Tender Status:',
          ),
          _buildTextField('Tender Number:',
              controller: _tenderNumberBeController),
        ]),
        const SizedBox(height: 5),
        _buildRow([
          Expanded(
            child: SelectField<DgMaster>(
              options: dgOptions,
              key: ValueKey(dgOptions),
              initialValue: _selectedDGName,
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
              initialValue: _selectedDepartmentName,
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
        _buildRow([
          Expanded(
            child: SelectField<UserMaster>(
              options: filteredUserOption,
              key: ValueKey(filteredUserOption),
              initialValue: _selectedUserName,
              onChanged: (user, selectedOption) {
                _selectedUser = user.id;
              },
              hint: departmentOptions.isNotEmpty
                  ? 'Select User'
                  : 'No User Available',
            ),
          ),
        ]),
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
}
