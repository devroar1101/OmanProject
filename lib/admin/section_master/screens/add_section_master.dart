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
  AddSectionMaster({
    super.key,
    this.currentSection,
  });

  final SectionMaster? currentSection;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddSectionState();
  }
}

class _AddSectionState extends ConsumerState<AddSectionMaster> {
  final _formKey = GlobalKey<FormState>();

  String? _sectionNameArabic;
  String? _sectionNameEnglish;
  String? _selectedDG = '0';
  String? _selectedDepartment;

  List<SelectOption<Department>> departmentOptions = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        ref.read(dgMasterRepositoryProvider.notifier).getDGOptions(),
        ref
            .read(departmentMasterRepositoryProvider.notifier)
            .getDepartMentOptions(_selectedDG!)
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SizedBox(
              width: 500.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Error loading options',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    Text('${snapshot.error}'),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final dgOptions = snapshot.data![0] as List<SelectOption<DgMaster>>;
        final departmentOptions =
            snapshot.data![1] as List<SelectOption<Department>>;

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
                  mainAxisSize: MainAxisSize.min,
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
                    SizedBox(
                      width: 450.0,
                      child: TextFormField(
                        initialValue: widget.currentSection?.sectionNameArabic,
                        decoration: const InputDecoration(
                          labelText: 'Name (Arabic)',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _sectionNameArabic = value;
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the Arabic name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: 450.0,
                      child: TextFormField(
                        initialValue: widget.currentSection?.sectionNameEnglish,
                        decoration: const InputDecoration(
                          labelText: 'Name (English)',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _sectionNameEnglish = value;
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the English name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: 450.0,
                      child: SearchableDropdown<DgMaster>(
                        options: dgOptions,
                        initialValue: widget.currentSection != null
                            ? dgOptions
                                .firstWhere((options) =>
                                    options.key ==
                                    widget.currentSection!.dgId.toString())
                                .displayName
                            : null,
                        onChanged: (DgMaster dg) {
                          _selectedDG = dg.id.toString();
                        },
                        hint: 'Select a DG',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: 450.0,
                      child: SearchableDropdown<Department>(
                        options: departmentOptions,
                        initialValue: widget.currentSection != null
                            ? departmentOptions
                                .firstWhere((option) =>
                                    option.key ==
                                    widget.currentSection!.departmentId
                                        .toString())
                                .displayName
                            : null,
                        onChanged: (Department dept) {
                          _selectedDepartment = dept.id.toString();
                        },
                        hint: 'Select a Department',
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Row(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveForm(BuildContext context, WidgetRef ref) async {
    try {
      widget.currentSection == null
          ? await ref
              .read(sectionMasterRepositoryProvider.notifier)
              .addSectionMaster(
                nameArabic: _sectionNameArabic!,
                nameEnglish: _sectionNameEnglish!,
                dgId: int.parse(_selectedDG!),
                departmentId:
                    int.parse(_selectedDepartment!), // Save department
              )
          : await ref
              .read(sectionMasterRepositoryProvider.notifier)
              .editSeactionMaster(
                currentsectionId: widget.currentSection!.sectionId,
                nameArabic: _sectionNameArabic!,
                nameEnglish: _sectionNameEnglish!,
                currentDgId: int.parse(_selectedDG!),
                currentDepartmentId:
                    int.parse(_selectedDepartment!), // Save department
              );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(widget.currentSection != null
                ? 'Section edit successfully!'
                : 'Section added successfully!')),
      );
      Navigator.pop(context); // Close the modal after saving
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add Listmaster: $e')),
      );
    }
  }
}
