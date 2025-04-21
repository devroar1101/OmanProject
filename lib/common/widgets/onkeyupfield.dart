import 'package:flutter/material.dart';
import 'package:tenderboard/common/model/select_option.dart';
import 'package:tenderboard/common/themes/app_theme.dart';

class OnKeyUp<T> extends StatefulWidget {
  final TextEditingController textController;
  final String? hint;
  final String label;
  final bool requiredValidation;
  final Future<List<SelectOption<T>>> Function(String) fetchOptions;
  final Function(SelectOption<T>, T)? onSelected;

  const OnKeyUp({
    super.key,
    required this.textController,
    required this.fetchOptions,
    required this.label,
    this.hint,
    this.requiredValidation = false,
    this.onSelected,
  });

  @override
  _OnKeyUpState<T> createState() => _OnKeyUpState<T>();
}

class _OnKeyUpState<T> extends State<OnKeyUp<T>> {
  List<SelectOption<T>> filteredOptions = [];
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  Future<void> _fetchData(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredOptions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await widget.fetchOptions(query);
      setState(() {
        filteredOptions = results;
      });
      _createOrUpdateOverlay();
    } catch (e) {
      print("Error fetching options: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _createOrUpdateOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    } else {
      _overlayEntry = _buildOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _buildOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _removeOverlay();
        },
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              width: size.width,
              top: offset.dy + size.height,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  constraints: BoxConstraints(
                      maxHeight: filteredOptions.isEmpty ? 100 : 200,
                      maxWidth: 400),
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
                          shrinkWrap: true,
                          itemCount: filteredOptions.length,
                          itemBuilder: (context, index) {
                            final option = filteredOptions[index];

                            return ListTile(
                              title: Text(option.displayName),
                              onTap: () {
                                widget.textController.text = option.displayName;
                                if (widget.onSelected != null) {
                                  widget.onSelected!(option, option.value);
                                }
                                _removeOverlay();
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.textController,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onChanged: (value) => _fetchData(value),
        onTap: () => _createOrUpdateOverlay(),
      ),
    );
  }
}
