import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:tenderboard/common/utilities/color_picker.dart';
import 'package:tenderboard/common/widgets/image_editor.dart';

// ignore: must_be_immutable
class DocumentViewer extends StatefulWidget {
  final List<Uint8List> imagePaths;
  final int totalPage;
  final Future<void> Function()? startScan;
  final Function(BuildContext)? showScannerDialog;
  bool? scanning;

  DocumentViewer(
      {super.key,
      required this.imagePaths,
      this.startScan,
      this.totalPage = 0,
      this.showScannerDialog,
      this.scanning});

  @override
  _DocumentViewerState createState() => _DocumentViewerState();
}

class _DocumentViewerState extends State<DocumentViewer> {
  int currentPage = 0;
  late bool isFullScreen;
  late bool isThumbnailsVisible;
  final TextEditingController _pageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    isFullScreen = false;
    isThumbnailsVisible = false;
  }

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });
  }

  void _toggleThumbnails() {
    setState(() {
      isThumbnailsVisible = !isThumbnailsVisible;
    });
  }

  void _changePage(int newPage) {
    setState(() {
      currentPage = newPage.clamp(0, widget.imagePaths.length - 1);
    });
  }

  void _goToPage() {
    final int? targetPage = int.tryParse(_pageController.text);
    if (targetPage != null) {
      _changePage(targetPage - 1);
    }
  }

  Future<void> _saveImage(Uint8List imageData, BuildContext context) async {
    const String apiUrl =
        "http://192.168.1.12:8080/api/FileData/CreateFileData";

    try {
      final dio = Dio();

      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);

      String base64Image = base64Encode(imageData);

      final payload = {
        'content': base64Image,
      };

      final response = await dio.post(
        apiUrl,
        data: payload,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.data['statusCode'] == '200' ||
          response.data["IsSuccess"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image saved successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save image: ${response.data['Message']}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving image: $e")),
      );
      print("Error saving image: $e");
    }
  }

  void _editImage() async {
    final selectedImage = widget.imagePaths[currentPage];
    final editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditImageScreen(imageData: selectedImage),
      ),
    );

    if (editedImage != null && editedImage is Uint8List) {
      setState(() {
        widget.imagePaths[currentPage] = editedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    int validCurrentPage = 0;
    if (widget.imagePaths.isNotEmpty) {
      validCurrentPage = currentPage.clamp(0, widget.imagePaths.length - 1);
      _pageController.text = (validCurrentPage + 1).toString();
    }

    return Scaffold(
      body: Row(
        children: [
          Card(
            elevation: 8, // Increase elevation for clickable feel
            color: Colors.grey[200],
            child: SizedBox(
              width: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 28, // Bigger icon size
                        icon: Icon(
                          isThumbnailsVisible
                              ? Icons.view_compact
                              : Icons.view_sidebar,
                          color: ColorPicker.formIconColor,
                        ),
                        onPressed: _toggleThumbnails,
                      ),
                      const SizedBox(height: 2),
                      if (widget.showScannerDialog != null)
                        IconButton(
                          iconSize: 28, // Bigger icon size
                          icon: const Icon(
                            Icons.settings,
                            color: ColorPicker.formIconColor,
                          ),
                          onPressed: () => widget.showScannerDialog!(context),
                        ),
                      const SizedBox(height: 2),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: TextField(
                          controller: _pageController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _goToPage();
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 4),
                            border: OutlineInputBorder(),
                            hintText: '0',
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '/ ${widget.totalPage != 0 ? widget.totalPage : widget.imagePaths.length}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      IconButton(
                        iconSize: 28, // Bigger icon size
                        icon: const Icon(
                          Icons.edit,
                          color: ColorPicker.formIconColor,
                        ),
                        onPressed: _editImage,
                      ),
                      const SizedBox(height: 2),
                      IconButton(
                        iconSize: 28, // Bigger icon size
                        icon: const Icon(
                          Icons.delete,
                          color: ColorPicker.formIconColor,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.imagePaths.removeAt(currentPage);
                            if (widget.imagePaths.isEmpty) {
                              currentPage = 0;
                            } else {
                              currentPage = currentPage.clamp(
                                  0, widget.imagePaths.length - 1);
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 2),
                      IconButton(
                        iconSize: 28, // Bigger icon size
                        icon: const Icon(
                          Icons.delete_forever,
                          color: ColorPicker.formIconColor,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.imagePaths.clear();
                            currentPage = 0;
                          });
                        },
                      ),
                      const SizedBox(height: 2),
                      IconButton(
                        iconSize: 28, // Bigger icon size
                        icon: Icon(
                          isFullScreen
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                          color: ColorPicker.formIconColor,
                        ),
                        onPressed: _toggleFullScreen,
                      ),
                      const SizedBox(height: 2),
                      IconButton(
                        color: ColorPicker.formIconColor,
                        iconSize: 28, // Bigger icon size
                        icon: const Icon(Icons.arrow_back),
                        onPressed: validCurrentPage > 0
                            ? () => _changePage(validCurrentPage - 1)
                            : null,
                      ),
                      const SizedBox(height: 2),
                      IconButton(
                        color: ColorPicker.formIconColor,
                        iconSize: 28, // Bigger icon size
                        icon: const Icon(Icons.arrow_forward),
                        onPressed:
                            validCurrentPage < widget.imagePaths.length - 1
                                ? () => _changePage(validCurrentPage + 1)
                                : null,
                      ),
                      const SizedBox(height: 2),
                      if (widget.startScan != null)
                        IconButton(
                          iconSize: 28, // Bigger icon size
                          icon: const Icon(
                            Icons.scanner,
                            color: ColorPicker.formIconColor,
                          ),
                          onPressed: widget.startScan,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Main Viewer Area
          Expanded(
            child: Stack(
              children: [
                // Main Page Image (Zoomable)
                GestureDetector(
                  onTap: _toggleFullScreen,
                  child: widget.scanning != null && widget.scanning!
                      ? Center(
                          child: Image.asset(
                            'assets/document_scanning.gif',
                            width: 500, // Adjust dimensions as needed
                            height: 500,
                            fit: BoxFit.contain,
                          ),
                        )
                      : widget.imagePaths.isNotEmpty
                          ? InteractiveViewer(
                              minScale: 1,
                              maxScale: 4.0,
                              child: SizedBox.expand(
                                child: Image.memory(
                                  widget.imagePaths[validCurrentPage],
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.document_scanner_outlined,
                                    size: 100,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No Document Available',
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ),
                // Thumbnails (Vertical Stack)
                if (isThumbnailsVisible)
                  Positioned(
                    left: isRtl ? null : 0,
                    right: isRtl ? 0 : null,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 120,
                      color: Colors.black.withOpacity(0.6),
                      child: ListView.builder(
                        itemCount: widget.imagePaths.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _changePage(index),
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: index == validCurrentPage
                                      ? Colors.blue
                                      : Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.memory(
                                widget.imagePaths[index],
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
