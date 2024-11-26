import 'package:flutter/material.dart';

class AddListmasterScreen extends StatefulWidget {
  const AddListmasterScreen({super.key});

  @override
  _AddListmasterScreenState createState() => _AddListmasterScreenState();
}

class _AddListmasterScreenState extends State<AddListmasterScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _listmasterNameArabic;
  String? _listmasterNameEnglish;

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Create a model or perform any necessary action
      print('Arabic Name: $_listmasterNameArabic');
      print('English Name: $_listmasterNameEnglish');
      // Navigate or display a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listmaster added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Listmaster'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Listmaster Name (Arabic)',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _listmasterNameArabic = value;
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the Arabic name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Listmaster Name (English)',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _listmasterNameEnglish = value;
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the English name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
