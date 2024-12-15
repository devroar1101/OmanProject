import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class EditImageScreenTest extends StatefulWidget {
  final Uint8List imageData;

  const EditImageScreenTest({super.key, required this.imageData});

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreenTest> {
  late img.Image _image;

  @override
  void initState() {
    super.initState();
    _image = img.decodeImage(Uint8List.fromList(widget.imageData))!;
  }

  // Function to rotate image
  void _rotateImage() {
    setState(() {
      _image = img.copyRotate(_image, angle: 90); // Rotate by 90 degrees
    });
  }

  // Function to resize image
  void _resizeImage() {
    setState(() {
      _image = img.copyResize(_image, width: 400); // Resize width to 400px
    });
  }

  // Function to crop image
  void _cropImage() {
    setState(() {
      _image = img.copyCrop(_image,
          x: 0,
          y: 0,
          width: _image.width ~/ 2,
          height: _image.height ~/ 2); // Crop half of the image
    });
  }

  // Function to apply grayscale filter
  void _applyGrayscale() {
    setState(() {
      _image = img.grayscale(_image); // Convert to grayscale
    });
  }

  // Function to apply sepia filter
  void _applySepia() {
    setState(() {
      _image = img.sepia(_image); // Apply sepia tone
    });
  }

  void _applyWatermark() {
    setState(() {
      // Apply watermark with proper named parameters
      _image = img.drawString(
        _image,
        'Watermark', // Text to be displayed
        font: img.arial24, // Use a built-in font (e.g., arial_24)
        x: 10, // x-coordinate for position
        y: 10, // y-coordinate for position
        // Color for watermark (hex format)
      );
    });
  }

  // Function to draw shapes (e.g., rectangle)
  void _drawShapes() {
    setState(() {
      // Draw a red rectangle with required parameters
      _image = img.drawRect(_image,
          x1: 50, y1: 50, x2: 200, y2: 100, color: img.ColorFloat16(1)
          // Red color for the rectangle
          );
    });
  }

  // Function to draw text on image
  void _drawText() {
    setState(() {
      // Draw text on image using the font
      _image = img.drawString(
        _image,
        font: img.arial24, // Font (black)
        x: 100, y: 100, // Position
        'Hello Flutter!', // Text
        // Red color for text
      );
    });
  }

  // Function to save the edited image
  void _saveImage() {
    final editedImage =
        Uint8List.fromList(img.encodeJpg(_image)); // Encode image to JPG
    Navigator.pop(context, editedImage); // Return the edited image
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Image")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.memory(Uint8List.fromList(img.encodeJpg(_image))),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rotate button
              IconButton(
                icon: const Icon(Icons.rotate_right),
                onPressed: _rotateImage,
              ),
              // Resize button
              IconButton(
                icon: const Icon(Icons.crop),
                onPressed: _resizeImage,
              ),
              // Crop button
              IconButton(
                icon: const Icon(Icons.crop_square),
                onPressed: _cropImage,
              ),
              // Grayscale filter button
              IconButton(
                icon: const Icon(Icons.photo_filter),
                onPressed: _applyGrayscale,
              ),
              // Sepia filter button
              IconButton(
                icon: const Icon(Icons.style),
                onPressed: _applySepia,
              ),
              // Watermark button
              IconButton(
                icon: const Icon(Icons.water_drop),
                onPressed: _applyWatermark,
              ),
              // Draw shapes button
              IconButton(
                icon: const Icon(Icons.draw),
                onPressed: _drawShapes,
              ),
              // Draw text button
              IconButton(
                icon: const Icon(Icons.text_fields),
                onPressed: _drawText,
              ),
              // Save button
              ElevatedButton(
                onPressed: _saveImage,
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
