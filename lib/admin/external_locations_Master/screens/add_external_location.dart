import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State Providers for radio and switch
final typeProvider = StateProvider<String?>((ref) => null);
final newLocationProvider = StateProvider<bool>((ref) => false);

class AddExternalLocation extends ConsumerWidget {
  AddExternalLocation({super.key});

  final _formKey = GlobalKey<FormState>();

  String? _nameArabic;
  String? _nameEnglish;

  Future<void> _saveForm(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state of radio and switch
    final selectedType = ref.watch(typeProvider);
    final isNewLocation = ref.watch(newLocationProvider);

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
                const Text(
                  'Add External Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),

                // Name Arabic field
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name Arabic',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _nameArabic = value;
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

                // Name English field
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name English',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _nameEnglish = value;
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

                // Type field (Radio buttons)
                const Text('Type'),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Government'),
                        value: 'Government',
                        groupValue: selectedType,
                        onChanged: (value) {
                          ref.read(typeProvider.notifier).state = value;
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Others'),
                        value: 'Others',
                        groupValue: selectedType,
                        onChanged: (value) {
                          ref.read(typeProvider.notifier).state = value;
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
                      value: isNewLocation,
                      onChanged: (value) {
                        ref.read(newLocationProvider.notifier).state = value;
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
                      onPressed: () {
                        Navigator.pop(context); // Close the modal on cancel
                      },
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
