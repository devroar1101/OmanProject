import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/admin/section_master/model/section_master.dart';
import 'package:tenderboard/admin/user_master/model/user_master.dart';
import 'package:tenderboard/admin/user_master/model/user_master_repo.dart';
import 'package:tenderboard/common/model/global_enum.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/utilities/current_user.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';
import 'package:tenderboard/common/widgets/select_field.dart';
import 'package:tenderboard/common/widgets/select_user.dart';
import 'package:tenderboard/office/letter/model/letter_action.dart';
import 'package:tenderboard/office/letter/model/letter_action_repo.dart';
import 'package:tenderboard/office/letter_summary/model/routing_history_result.dart';
import 'package:tenderboard/office/letter_summary/screens/letter_routing.dart';

// ignore: must_be_immutable
class JobAssignForm extends ConsumerStatefulWidget {
  const JobAssignForm({
    super.key,
    required this.letterObjectId,
  });

  final String letterObjectId;

  @override
  _JobAssignFormState createState() => _JobAssignFormState();
}

class _JobAssignFormState extends ConsumerState<JobAssignForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _personalGroupController =
      TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _modifyCommentController =
      TextEditingController();

  double fieldHeight = 45;
  DateTime? _replyDate;
  DateTime? _followUpDate;
  int selectedPriority = 1;
  int selectedClassification = 1;
  int? _selectedDG;
  final String _selectedDGName = '';
  int? _selectedDepartment;
  final String _selectedDepartmentName = '';
  int? _selectedSection;
  final String _selectedSectionName = '';

  late List<SelectOption<Dg>> dgOptions = [];
  late List<SelectOption<Department>> departmentOptions = [];
  late List<SelectOption<Section>> sectionOptions = [];

  late List<User> userList = [];
  List<User> selectedUsers = [];
  List<RoutingHistoryResult> previewActions = [];
  bool _commentType = true;
  final _commentTypeScale = ValueNotifier<double>(1.0);

  @override
  void initState() {
    super.initState();
    initialise();
  }

  void initialise() async {
    final dgAsyncValue = ref.read(dgOptionsProvider(true));
    dgOptions = dgAsyncValue.asData?.value ?? [];
    ref.read(UserRepositoryProvider.notifier).fetchUsers();
  }

  void _onSelectionChanged(List<User> selectedUsers) {
    setState(() {
      this.selectedUsers = selectedUsers;
    });
  }

  var isPreview = false;
  @override
  Widget build(BuildContext context) {
    userList = ref.watch(UserRepositoryProvider);

    userList = userList.where((singleUser) {
      final matchesDg = _selectedDG == null || singleUser.dgId == _selectedDG;
      final matchesDepartment = _selectedDepartment == null ||
          singleUser.departmentId == _selectedDepartment;
      final matchesSection =
          _selectedSection == null || singleUser.sectionId == _selectedSection;
      final addedUser = !selectedUsers.any((user) => user.id == singleUser.id);
      return matchesDg && matchesSection && matchesDepartment && addedUser;
    }).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _formKey, // Attach the GlobalKey to the Form
          child: isPreview
              ? SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoutingHistory(routings: previewActions),
                  ))
              : Column(
                  children: [
                    _buildRow([
                      SizedBox(
                        height: fieldHeight,
                        child: TextFormField(
                          readOnly: true, // Disable manual input
                          decoration: InputDecoration(
                            labelText: 'Reply Date',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () => selectDate(
                                context,
                                _replyDate ?? DateTime.now(),
                                (picked) => setState(() => _replyDate = picked),
                              ),
                            ),
                            labelStyle: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            floatingLabelStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.black, // Black color when active
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors
                                      .black), // Optional: Black border when active
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          controller: TextEditingController(
                            text: _replyDate != null
                                ? DateFormat('yyyy-MM-dd').format(_replyDate!)
                                : '',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: fieldHeight,
                        child: TextFormField(
                          readOnly: true, // Disable manual input
                          decoration: InputDecoration(
                            labelText: 'FollowUp Date',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () => selectDate(
                                context,
                                _followUpDate ?? DateTime.now(),
                                (picked) =>
                                    setState(() => _followUpDate = picked),
                              ),
                            ),
                            labelStyle: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            floatingLabelStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.black, // Black color when active
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors
                                      .black), // Optional: Black border when active
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          controller: TextEditingController(
                            text: _followUpDate != null
                                ? DateFormat('yyyy-MM-dd')
                                    .format(_followUpDate!)
                                : '',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: fieldHeight,
                        child: DropdownButtonFormField<int>(
                          value: selectedPriority,
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            labelStyle: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            floatingLabelStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.black, // Black color when active
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors
                                      .black), // Optional: Black border when active
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
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
                      SizedBox(
                        height: fieldHeight,
                        child: DropdownButtonFormField<int>(
                          value: selectedClassification,
                          decoration: InputDecoration(
                            labelText: 'Classification',
                            labelStyle: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            floatingLabelStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.black, // Black color when active
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors
                                      .black), // Optional: Black border when active
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          items:
                              Classification.values.map((Classification item) {
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
                      )
                    ]),
                    const SizedBox(height: 8.0),
                    _buildRow([
                      _buildSingleField(
                          'Personal Group', _personalGroupController),
                      Expanded(
                        child: SizedBox(
                          height: fieldHeight,
                          child: SelectField<Dg>(
                            label: 'DG',
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
                      ),
                      Expanded(
                        child: SizedBox(
                          height: fieldHeight,
                          child: SelectField<Department>(
                            label: 'Department',
                            options: departmentOptions,
                            initialValue: _selectedDepartmentName,
                            key: ValueKey(departmentOptions),
                            onChanged: (department, selectedOption) {
                              setState(() {
                                sectionOptions = selectedOption.childOptions
                                        ?.cast<SelectOption<Section>>() ??
                                    [];
                                _selectedSection = null;
                                _selectedDepartment = department.id;
                              });
                            },
                            hint: departmentOptions.isNotEmpty
                                ? 'Select Department'
                                : 'No Department Available',
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: fieldHeight,
                          child: SelectField<Section>(
                            label: 'Section',
                            options: sectionOptions,
                            initialValue: _selectedSectionName,
                            key: ValueKey(sectionOptions),
                            onChanged: (section, selectedOption) {
                              setState(() {
                                _selectedSection = section.id;
                              });
                            },
                            hint: sectionOptions.isNotEmpty
                                ? 'Select Section'
                                : 'No Section Available',
                          ),
                        ),
                      )
                    ]),
                    const SizedBox(height: 8.0),
                    SelectUserWidget(
                      key: ValueKey(userList),
                      userList: userList,
                      selectedUsers: selectedUsers,
                      onSelectionChanged: _onSelectionChanged,
                    ),
                    const SizedBox(height: 16.0),
                    _buildRow([
                      GestureDetector(
                        onTapDown: (_) =>
                            _commentTypeScale.value = 0.95, // Shrink on tap
                        onTapUp: (_) => _commentTypeScale.value =
                            1.0, // Return to normal size
                        onTapCancel: () => _commentTypeScale.value = 1.0,
                        onTap: () => setState(() {
                          _commentType = !_commentType;
                        }),
                        child: SizedBox(
                          width: 100,
                          child: ValueListenableBuilder<double>(
                            valueListenable: _commentTypeScale,
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  color: Colors.blue.shade50,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 4.0),
                                    child: Center(
                                      child: Text(
                                        _commentType ? 'Open' : 'Secret',
                                        style: const TextStyle(
                                          fontSize: 16, // Slightly smaller font
                                          fontWeight:
                                              FontWeight.w500, // Medium weight
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      _buildSingleField('Comment', _commentController),
                      _buildSingleField('Personal Comment', _commentController),
                    ]),
                    const SizedBox(
                      height: 5,
                    ),
                    _buildSingleField(
                        'Modify Comment', _modifyCommentController),
                  ],
                ),
        ),
        _buildRow([
          ElevatedButton(
            onPressed: () {
              if (!isPreview) {
                // Switching to Preview
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    previewActions = selectedUsers.map((singleUser) {
                      return RoutingHistoryResult(
                        actionId: 1,
                        classificationId: selectedClassification,
                        comments: _commentController.text,
                        followedUpDate:
                            _followUpDate?.toIso8601String().toString(),
                        fromUser:
                            'Alwin', // Replace with actual logged-in user ID
                        //isHidden: _commentType, need to implement while hiddenjob
                        objectId: widget.letterObjectId,
                        priorityId: selectedPriority,
                        replyDate: _replyDate?.toIso8601String().toString(),
                        toUser: singleUser.systemName,
                      );
                    }).toList();
                    isPreview = true;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please fill all fields correctly.')),
                  );
                }
              } else {
                // Switching back to Form
                setState(() {
                  isPreview = false;
                  previewActions = []; // Clear preview actions
                });
              }
            },
            child: Text(!isPreview ? 'Preview' : 'Back'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final repo = ref.read(letterActionRepositoryProvider);

                // Create LetterAction for each selected user
                final actions = selectedUsers.map((singleUser) {
                  return LetterAction(
                    actionId: 1,
                    classificationId: selectedClassification,
                    comments: _commentController.text,
                    follwedUpDate: _followUpDate,
                    fromUserId: CurrentUser().userId,
                    isHidden: _commentType,
                    objectId: widget.letterObjectId,
                    priorityId: selectedPriority,
                    replyDate: _replyDate,
                    toUserId: singleUser.id,
                  );
                }).toList();

                // Execute repository creation calls
                for (final action in actions) {
                  repo.createLetterAction(action.toMap());
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Actions saved successfully!'),
                  ),
                );

                // Reset the form after save
                setState(() {
                  isPreview = false;
                  previewActions = [];
                  _formKey.currentState?.reset();
                  _commentController.clear();
                  _modifyCommentController.clear();
                  _replyDate = null;
                  _followUpDate = null;
                  selectedUsers.clear();
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all fields correctly.'),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ]),
      ],
    );
  }

  // Build a row with two fields
  Widget _buildRow(List<Widget> children) {
    return Row(
      children: children
          .map(
            (field) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: field,
              ),
            ),
          )
          .toList(),
    );
  }

  // Build a single text field with validation
  Widget _buildField(String label, TextEditingController controller) {
    return SizedBox(
      height: 40, // Smaller height for compact design
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 14), // Smaller font size
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 12), // Smaller label font size
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 10.0,
          ), // Reduced padding for compact size
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  // Build a single field without a row
  Widget _buildSingleField(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40, // Smaller height for compact design
            child: TextFormField(
              controller: controller,
              style: const TextStyle(fontSize: 14), // Smaller font size
              decoration: InputDecoration(
                labelText: label,
                labelStyle:
                    const TextStyle(fontSize: 12), // Smaller label font size
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 10.0,
                ), // Reduced padding for compact size
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '$label is required';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
