import 'package:flutter/material.dart';
import 'package:tenderboard/common/model/select_option.dart';

// ignore: must_be_immutable
class SelectField<T> extends StatefulWidget {
  final List<SelectOption<T>> options;
  final Function(T) onChanged;
  final String hint;
  String? selectedOption;
  String? initialValue;

  SelectField(
      {super.key,
      required this.options,
      required this.onChanged,
      this.hint = 'Search...',
      this.initialValue,
      this.selectedOption});

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
    filteredOptions = widget.options;
    if (widget.initialValue != null && widget.initialValue != '') {
      _searchController.text = widget.initialValue!;
    }
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
                    constraints: const BoxConstraints(
                      maxHeight: 100,
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
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: filteredOptions.length,
                            itemBuilder: (context, index) {
                              final option = filteredOptions[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _searchController.text = option.displayName;
                                    widget.selectedOption = option.key;
                                    filteredOptions = widget.options;
                                  });
                                  widget.onChanged(option.value);
                                  _removeOverlay();
                                },
                                child: ListTile(
                                  selected: option.key == widget.selectedOption,
                                  title: Text(option.displayName),
                                ),
                              );
                            },
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
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: widget.hint,
              border: const OutlineInputBorder(),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                      },
                      child: Icon(Icons.close),
                    ),
                  Icon(
                    isDropdownOpen
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
            onTap: _createOrUpdateOverlay,
            onChanged: (value) {
              // Trigger UI update when text changes
              (context as Element).markNeedsBuild();
            },
          ),
        ));
  }
}
