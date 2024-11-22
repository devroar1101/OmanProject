import 'package:flutter/material.dart';
import 'package:tenderboard/common/model/select_option.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final List<SelectOption<T>> options;
  final Function(T) onChanged; // Callback function to return the selected value
  final String hint;
  final TextEditingController? controller;

  const SearchableDropdown({
    super.key,
    required this.options,
    required this.onChanged,
    this.hint = 'Search...',
    this.controller,
  });

  @override
  _SearchableDropdownState<T> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  late List<SelectOption<T>> filteredOptions;
  final TextEditingController _searchController = TextEditingController();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    filteredOptions = widget.options;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      String searchText = _searchController.text.toLowerCase();
      filteredOptions = widget.options.where((option) {
        return option.displayName.toLowerCase().contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller ?? _searchController,
          decoration: InputDecoration(
            hintText: widget.hint,
            border: const OutlineInputBorder(),
            suffixIcon: Icon(
              isFocused && filteredOptions.isNotEmpty
                  ? Icons.arrow_drop_up // Show up icon when search list is open
                  : Icons.arrow_drop_down, // Show down icon when not focused
            ),
          ),
          onTap: () {
            setState(() {
              isFocused = !isFocused;
            });
          },
          onChanged: (text) {
            _onSearchChanged();
          },
        ),
        if (filteredOptions.isNotEmpty && isFocused)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListView(
              shrinkWrap: true,
              children: filteredOptions.map((SelectOption<T> option) {
                return ListTile(
                  title: Text(option.displayName),
                  onTap: () {
                    widget.onChanged(option.value);
                    setState(() {
                      _searchController.text = option.displayName;
                      filteredOptions = widget.options;
                      isFocused = false; // Reset focus after selection
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}


/*
class MyApp2 extends StatelessWidget {
  MyApp2({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Searchable Dropdown Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SearchableDropdownExample(),
        ),
      ),
    );
  }
}

class SearchableDropdownExample extends StatefulWidget {
  @override
  _SearchableDropdownExampleState createState() =>
      _SearchableDropdownExampleState();
}

class _SearchableDropdownExampleState extends State<SearchableDropdownExample> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    // Example options with String type
    List<SelectOption<String>> options = [
      SelectOption(displayName: 'Option 1', key: 'option1', value: 'Option 1'),
      SelectOption(displayName: 'Option 2', key: 'option2', value: 'Option 2'),
      SelectOption(
          displayName: 'ثالث خيار',
          key: 'option3',
          value: 'ثالث خيار'), // Arabic text example
      SelectOption(displayName: 'Option 4', key: 'option4', value: 'Option 4'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchableDropdown<String>(
          options: options,
          onChanged: (selectedValue) {
            setState(() {
              _selectedValue = selectedValue;
            });
            
          },
        ),
        SizedBox(height: 20),
        Text(
          _selectedValue != null
              ? 'Selected Value: $_selectedValue'
              : 'No option selected',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
*/