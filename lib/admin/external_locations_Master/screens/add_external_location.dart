import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master.dart';
import 'package:tenderboard/admin/external_locations_Master/model/external_location_master_repo.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';
import 'package:tenderboard/common/widgets/custom_snackbar.dart';

class AddExternalLocation extends ConsumerStatefulWidget {
  const AddExternalLocation(
      {super.key,
      this.editNameArabic,
      this.editNameEnglish,
      this.currentExternalLocationId,
      this.currentlocation});
  final String? editNameEnglish;
  final String? editNameArabic;
  final int? currentExternalLocationId;
  final ExternalLocation? currentlocation;
  @override
  _AddExternalLocationState createState() => _AddExternalLocationState();
}

class _AddExternalLocationState extends ConsumerState<AddExternalLocation> {
  final _formKey = GlobalKey<FormState>();
  String? _nameArabic;
  String? _nameEnglish;
  String? _type = 'Government';
  bool _isNew = false; // Default value to prevent null issues
 @override
  void initState() {
    super.initState();
    if(widget.currentlocation != null){
    _type = widget.currentlocation!.type == 'Government' ? 'Government' : 'Others'; // Set default or assigned value
    _isNew = widget.currentlocation!.isNew == 'New Location' ? true : false; // Set default or assigned value
    }
  }
  Future<void> _saveForm(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        widget.currentExternalLocationId == null
            ? await ref
                .read(ExternalLocationRepositoryProvider.notifier)
                .addExternalLocation(
                  nameEnglish: _nameEnglish!,
                  nameArabic: _nameArabic!,
                  type: _type!,
                  isNew: _isNew == true ? 'New Location' : 'Old Location',
                )
            : await ref
                .read(ExternalLocationRepositoryProvider.notifier)
                .editExternalLocation(
                  nameEnglish: _nameEnglish!,
                  nameArabic: _nameArabic!,
                  type: _type!,
                  isNew: _isNew == true ? 'New Location' : 'Old Location',
                  currentExternalLocationId: widget.currentExternalLocationId!,
                );

        CustomSnackbar.show(
          context: context,
          title: 'Success',
          message: getTranslation('External Location added successfully!'),
          typeId: 1,
          durationInSeconds: 3,
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.currentExternalLocationId == null? 'Failed to add External Location : $e' :'Failed to Edit External LOcation : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SizedBox(
        width: 600.0, // Adjust width for a cleaner layout
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Makes the dialog height dynamic
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.currentExternalLocationId == null
                      ? 'Add External Location'
                      : 'Edit External Location',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),

                // Name Arabic field
                TextFormField(
                  initialValue: widget.editNameArabic,
                  decoration: const InputDecoration(
                    labelText: 'Name Arabic',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _nameArabic = value,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Please enter the Arabic name'
                      : null,
                ),
                const SizedBox(height: 16.0),

                // Name English field
                TextFormField(
                  initialValue: widget.editNameEnglish,
                  decoration: const InputDecoration(
                    labelText: 'Name English',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _nameEnglish = value,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Please enter the English name'
                      : null,
                ),
                const SizedBox(height: 16.0),

                // Type field (Radio buttons)
                const Text('Type'),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Government'),
                        value: 'Government',
                        groupValue:
                            _type ,//== null ? widget.currentlocation!.type : null,
                        onChanged: (value) {
                          setState(() {
                            _type = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Others'),
                        value: 'Others',
                        groupValue:
                            _type ,//== null ? widget.currentlocation!.type : null,
                        onChanged: (value) {
                          setState(() {
                            _type = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // New Location toggle switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('New Location'),
                    Switch(
                      value: _isNew, //== false
                          //? widget.currentlocation!.isNew == 'New Location'
                            //  ? true
                              //: false
                          //: false,
                      onChanged: (value) {
                        setState(() {
                          _isNew = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // Buttons (Cancel and Add)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context), // Close modal
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _saveForm(context, ref),
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
