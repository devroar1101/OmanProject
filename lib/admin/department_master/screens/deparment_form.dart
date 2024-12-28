import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/common/utilities/color_picker.dart';
import 'package:tenderboard/common/widgets/select_field.dart';

class DepartmentSearchForm extends ConsumerStatefulWidget {
  const DepartmentSearchForm({super.key, required this.onSearch});

  final Function(String, String, String, String?) onSearch;

  @override
  _DepartmentSearchFormState createState() => _DepartmentSearchFormState();
}

class _DepartmentSearchFormState extends ConsumerState<DepartmentSearchForm> {
  final TextEditingController _nameEnglishController = TextEditingController();
  final TextEditingController _nameArabicController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? _selectedDropdownValue = '';

  void _resetFields() {
    _nameEnglishController.clear();
    _nameArabicController.clear();
    _codeController.clear();
    widget.onSearch('', '', '', '');
    setState(() {
      _selectedDropdownValue = '';
    });
  }

  void _handleSearch() {
    String nameEnglish = _nameEnglishController.text;
    String nameArabic = _nameArabicController.text;
    String code = _codeController.text;
    String? dGdropdownValue = _selectedDropdownValue;

    widget.onSearch(nameArabic, nameEnglish, code, dGdropdownValue!);
  }

  @override
  Widget build(BuildContext context) {
    final dgOptionAsyncvalue = ref.watch(dgOptionsProvider(false));
    final dgOptions = dgOptionAsyncvalue.asData?.value;
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      // margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Row(
          children: [
            // Code Text Field
            Expanded(
              child: TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),

            // Name English Text Field
            Expanded(
              child: TextField(
                controller: _nameEnglishController,
                decoration: InputDecoration(
                  labelText: 'Name English',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),

            // Name Arabic Text Field
            Expanded(
              child: TextField(
                controller: _nameArabicController,
                decoration: InputDecoration(
                  labelText: 'Name Arabic',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),

            // Custom Dropdown Field
            Expanded(
              child: SelectField<DgMaster>(
                options: dgOptions!,
                onChanged: (dg, selectedOption) {
                  setState(() {
                    _selectedDropdownValue = dg.id.toString();
                  });
                },
                hint: 'Select DG',
              ),
            ),
            const SizedBox(width: 8.0),

            // Search Icon Button
            Card(
              color: const Color.fromARGB(255, 238, 240, 241),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: ColorPicker.formIconColor,
                ),
                onPressed: _handleSearch,
                tooltip: 'Search',
              ),
            ),

            // Reset Icon Button
            Card(
              color: const Color.fromARGB(255, 240, 234, 235),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: ColorPicker.formIconColor,
                ),
                onPressed: _resetFields,
                tooltip: 'Reset',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
