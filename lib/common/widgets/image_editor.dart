/*import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class EditImageScreen extends StatefulWidget {
  final Uint8List imageData;

  const EditImageScreen({super.key, required this.imageData});

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  late img.Image _image;
  Offset _overlayPosition =
      const Offset(100, 100); // Default position for the PNG overlay
  Uint8List? _overlayImage;

  @override
  void initState() {
    super.initState();
    _image = img.decodeImage(Uint8List.fromList(widget.imageData))!;
    _loadOverlayImage();
  }

  // Load PNG image from assets
  Future<void> _loadOverlayImage() async {
    final overlayData =
        await DefaultAssetBundle.of(context).load("assets/signature.png");
    setState(() {
      _overlayImage = overlayData.buffer.asUint8List();
    });
  }

  // Apply PNG overlay to the main image during save
  void _applyOverlayOnSave() {
    if (_overlayImage != null) {
      final overlay = img.decodeImage(_overlayImage!)!;
      _image = img.compositeImage(
        _image,
        overlay,
        dstX: _overlayPosition.dx.toInt(),
        dstY: _overlayPosition.dy.toInt(),
        // Enable blending for transparency
      );
    }
  }

  // Function to save the edited image
  void _saveImage() {
    _applyOverlayOnSave(); // Apply overlay before saving
    final editedImage =
        Uint8List.fromList(img.encodeJpg(_image)); // Encode image to JPG
    Navigator.pop(context, editedImage); // Return the edited image
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Image")),
      body: Stack(
        children: [
          Center(
            child: Image.memory(Uint8List.fromList(img.encodeJpg(_image))),
          ),
          if (_overlayImage != null)
            Positioned(
              left: _overlayPosition.dx,
              top: _overlayPosition.dy,
              child: Draggable(
                feedback: Material(
                  color: Colors.transparent,
                  child: Image.memory(
                    _overlayImage!,
                    width: 100, // Adjust overlay size if needed
                  ),
                ),
                childWhenDragging:
                    Container(), // Hide the original widget while dragging
                onDragEnd: (details) {
                  setState(() {
                    // Update position after dragging
                    _overlayPosition = details.offset;
                  });
                },
                child: Image.memory(
                  _overlayImage!,
                  width: 100, // Adjust overlay size if needed
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: _saveImage,
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
*/
