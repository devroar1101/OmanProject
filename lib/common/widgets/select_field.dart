import 'package:flutter/material.dart';
import 'package:tenderboard/common/model/select_option.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final List<SelectOption<T>> options;
  final Function(T) onChanged;
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
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  bool isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    filteredOptions = widget.options;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      String searchText = _searchController.text.toLowerCase();
      filteredOptions = widget.options.where((option) {
        return option.displayName.toLowerCase().contains(searchText);
      }).toList();
    });

    if (_searchController.text.isNotEmpty) {
      _createOrUpdateOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _createOrUpdateOverlay() {
    if (isDropdownOpen) {
      _overlayEntry?.markNeedsBuild();
    } else {
      _createOverlay();
    }
  }

  void _createOverlay() {
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      isDropdownOpen = true;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      isDropdownOpen = false;
    });
  }

  OverlayEntry _buildOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          left: offset.dx,
          top: offset.dy + size.height,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 200,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = filteredOptions[index];
                  return ListTile(
                    title: Text(option.displayName),
                    onTap: () {
                      widget.onChanged(option.value);
                      setState(() {
                        _searchController.text = option.displayName;
                        filteredOptions = widget.options;
                      });
                      _removeOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (isDropdownOpen) {
            _removeOverlay();
          }
        },
        behavior: HitTestBehavior.translucent,
        child: TextField(
          controller: widget.controller ?? _searchController,
          decoration: InputDecoration(
            hintText: widget.hint,
            border: const OutlineInputBorder(),
            suffixIcon: Icon(
              isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            ),
          ),
          onTap: _createOrUpdateOverlay,
        ),
      ),
    );
  }
}

class SelectFieldApp extends StatelessWidget {
  const SelectFieldApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Searchable Dropdown Example')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: DropdownFormExample(),
        ),
      ),
    );
  }
}

class DropdownFormExample extends StatefulWidget {
  const DropdownFormExample({super.key});

  @override
  _DropdownFormExampleState createState() => _DropdownFormExampleState();
}

class _DropdownFormExampleState extends State<DropdownFormExample> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedValue; // To store the selected value

  @override
  Widget build(BuildContext context) {
    // Example options for the dropdown
    final List<SelectOption<String>> options = [
      SelectOption(displayName: 'Option 1', key: 'option1', value: 'Option 1'),
      SelectOption(displayName: 'Option 2', key: 'option2', value: 'Option 2'),
      SelectOption(
          displayName: 'ثالث خيار',
          key: 'option3',
          value: 'ثالث خيار'), // Arabic text example
      SelectOption(displayName: 'Option 4', key: 'option4', value: 'Option 4'),
    ];

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchableDropdown<String>(
            options: options,
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
            hint: 'Select an option...',
          ),
          const SizedBox(height: 20),
          // Display selected value
          Text(
            _selectedValue != null
                ? 'Selected Value: $_selectedValue'
                : 'No option selected',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          // Submit button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_selectedValue == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an option!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Submitted: $_selectedValue'),
                    ),
                  );
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
