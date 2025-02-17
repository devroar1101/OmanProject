import 'package:flutter/material.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/themes/app_theme.dart';

// ignore: must_be_immutable
class SelectField<T> extends StatefulWidget {
  List<SelectOption<T>>? options;
  final Function(T, SelectOption) onChanged;
  final String? hint;
  final String label;
  String? selectedOption;
  String? initialValue;
  bool requiredValidation;
  List<SelectOption<T>> Function(String searchText)? filterOptions;

  SelectField(
      {super.key,
      this.options,
      required this.onChanged,
      required this.label,
      this.hint,
      this.requiredValidation = false,
      this.initialValue,
      this.selectedOption,
      this.filterOptions});

  @override
  _SelectFieldState<T> createState() => _SelectFieldState<T>();
}

class _SelectFieldState<T> extends State<SelectField<T>> {
  late List<SelectOption<T>> filteredOptions;
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  bool isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    filteredOptions = widget.options ?? [];

    if (widget.initialValue != null && widget.initialValue != '') {
      _searchController.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (widget.options != []) {
      setState(() {
        String searchText = _searchController.text.toLowerCase();
        filteredOptions = widget.options!.where((option) {
          return option.displayName.toLowerCase().contains(searchText);
        }).toList();
      });
    } else {
      filteredOptions = widget.filterOptions!(value);
    }

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
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _removeOverlay();
          },
          child: Stack(
            children: [
              Positioned(
                width: size.width,
                left: offset.dx,
                top: offset.dy + size.height,
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: filteredOptions.isEmpty ? 100 : 250,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: filteredOptions.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('No options available',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          )
                        : SizedBox(
                            height: 100,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: filteredOptions.length,
                              itemBuilder: (context, index) {
                                final option = filteredOptions[index];

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _searchController.text =
                                          option.displayName;
                                      widget.selectedOption = option.key;
                                    });
                                    widget.onChanged(option.value, option);
                                    _removeOverlay();
                                  },
                                  child: ListTile(
                                    tileColor: AppTheme.dialogColor,
                                    textColor: AppTheme.textColor,
                                    selected:
                                        option.key == widget.selectedOption,
                                    title: Text(option.displayName),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ),
            ],
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
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (isDropdownOpen) {
              _removeOverlay();
            }
          },
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              floatingLabelAlignment: FloatingLabelAlignment.center,
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
                    color: Colors.black), // Optional: Black border when active
              ),
              hintText: widget.hint,
              suffixIcon: Icon(
                isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.black,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onTap: _createOrUpdateOverlay,
            onChanged: (value) {
              _onSearchChanged(value);
              (context as Element).markNeedsBuild();
            },
            validator: (value) {
              if (widget.requiredValidation &&
                  widget.selectedOption != null &&
                  (value == null || value.isEmpty)) {
                return widget.hint;
              }
              return null;
            },
          ),
        ));
  }
}
