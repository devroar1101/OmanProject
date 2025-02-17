import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/admin/department_master/model/department_repo.dart'; // Add department repo
import 'package:tenderboard/admin/section_master/model/section_master.dart';
import 'package:tenderboard/admin/section_master/model/section_master_repo.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/widgets/select_field.dart';

class AddSectionMaster extends ConsumerStatefulWidget {
  const AddSectionMaster({
    super.key,
    this.currentSection,
  });

  final Section? currentSection;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddSectionState();
  }
}

class _AddSectionState extends ConsumerState<AddSectionMaster> {
  final _formKey = GlobalKey<FormState>();

  String? _sectionNameArabic;
  String? _sectionNameEnglish;
  String? _selectedDG;
  String? _selectedDepartment;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final dgOptions = ref.watch(dgOptionsProvider(true));
        print('Selected DG - > $_selectedDG');
        final departmentOptions = ref.watch(departmentOptionsProvider(_selectedDG));

        return dgOptions.when(
          data: (dgList) {
            return departmentOptions.when(
              data: (departments) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SizedBox(
                    width: 500.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.currentSection != null
                                  ? 'Edit Section Master'
                                  : 'Add Section Master',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16.0),
                            // Name fields
                            _buildTextField(
                              label: 'Name (Arabic)',
                              initialValue: widget.currentSection?.nameArabic,
                              onSaved: (value) => _sectionNameArabic = value,
                            ),
                            _buildTextField(
                              label: 'Name (English)',
                              initialValue: widget.currentSection?.nameEnglish,
                              onSaved: (value) => _sectionNameEnglish = value,
                            ),
                            const SizedBox(height: 16.0),
                            // DG Selection
                            _buildSearchableDropdown<Dg>(
                              label: 'Select DG',
                              options: dgList,
                              selectOption: _selectedDG,
                              initialValue: widget.currentSection != null
                                  ? dgList
                                      .firstWhere((dg) =>
                                          widget.currentSection!.dgId
                                              .toString() ==
                                          dg.key)
                                      .displayName
                                  : null,
                              onChanged: (dg, selectedOption) {
                                setState(() {
                                  _selectedDG = dg.id.toString();
                                  _selectedDepartment = null;

                                  ref.refresh(
                                      departmentOptionsProvider(_selectedDG!));
                                });
                              },
                            ),
                            const SizedBox(height: 16.0),
                            // Department Selection
                            _buildSearchableDropdown<Department>(
                              label: 'Select Department',
                              options: departments,
                              initialValue: _selectedDepartment == null
                                  ? null
                                  : widget.currentSection != null
                                      ? departments
                                          .firstWhere((option) =>
                                              option.key ==
                                              widget
                                                  .currentSection!.departmentId
                                                  .toString())
                                          .displayName
                                      : null,
                              onChanged: (dept, selectedOption) =>
                                  _selectedDepartment = dept.id.toString(),
                            ),
                            const SizedBox(height: 24.0),
                            _buildSaveCancelButtons(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        );
      },
    );
  }

  Widget _buildTextField(
      {required String label,
      String? initialValue,
      FormFieldSetter<String>? onSaved}) {
    return SizedBox(
      width: 450.0,
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onSaved: onSaved,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter the $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSearchableDropdown<T>({
    required String label,
    required List<SelectOption<T>> options,
    String? initialValue,
    String? selectOption,
    required Function(T, SelectOption) onChanged,
  }) {
    return SizedBox(
      width: 450.0,
      child: SelectField<T>(
        options: options,
        initialValue: initialValue,
        selectedOption: selectOption,
        onChanged: onChanged,
        label: label,
      ),
    );
  }

  Widget _buildSaveCancelButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              _saveForm(context, ref);
            }
          },
          child: const Text('Save'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> _saveForm(BuildContext context, WidgetRef ref) async {
    try {
      if (widget.currentSection == null) {
        await ref.read(sectionRepositoryProvider.notifier).addSection(
              nameArabic: _sectionNameArabic!,
              nameEnglish: _sectionNameEnglish!,
              dgId: int.parse(_selectedDG!),
              departmentId: int.parse(_selectedDepartment!),
            );
      } else {
        await ref.read(sectionRepositoryProvider.notifier).editSeactionMaster(
              currentid: widget.currentSection!.id,
              nameArabic: _sectionNameArabic!,
              nameEnglish: _sectionNameEnglish!,
              currentDgId: int.parse(_selectedDG!),
              currentDepartmentId: int.parse(_selectedDepartment!),
            );
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(widget.currentSection != null
            ? 'Section edited successfully!'
            : 'Section added successfully!'),
      ));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save: $e')));
    }
  }
}
