import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

class EditImageScreen extends StatefulWidget {
  final Uint8List imageData;

  const EditImageScreen({super.key, required this.imageData});

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  Uint8List? _signatureImage;

  @override
  void initState() {
    super.initState();
    _loadSignatureImage();
  }

  Future<void> _loadSignatureImage() async {
    final data = await rootBundle.load("assets/signature.png");
    setState(() {
      _signatureImage = data.buffer.asUint8List();
    });
  }

  Future<void> _openEditor() async {
    if (_signatureImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signature image not loaded")),
      );
      return;
    }

    final editedImage = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProImageEditor.memory(
          widget.imageData,
          configs: ProImageEditorConfigs(
            theme: ThemeData.dark(useMaterial3: true),

            // 👇 Inject signature as a sticker
            stickerEditor: StickerEditorConfigs(
              enabled: true,
              buildStickers: (addSticker, scrollController) {
                return ListView(
                  controller: scrollController,
                  children: [
                    GestureDetector(
                      onTap: () {
                        addSticker(Image.memory(_signatureImage!));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.memory(_signatureImage!, width: 100),
                      ),
                    ),
                  ],
                );
              },
            ),

            cropRotateEditor: CropRotateEditorConfigs(
              enabled: true,
              canFlip: true,
              canRotate: true,
              canChangeAspectRatio: true,
              showLayers: true,
            ),
          ),
          callbacks: ProImageEditorCallbacks(
            onImageEditingComplete: (Uint8List editedImageBytes) async {
              Navigator.pop(context, editedImageBytes);
            },
          ),
        ),
      ),
    );

    if (editedImage != null) {
      Navigator.pop(context, editedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Image")),
      body: Center(
        child: ElevatedButton(
          onPressed: _openEditor,
          child: const Text("Open Editor"),
        ),
      ),
    );
  }
}
