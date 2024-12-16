import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:tenderboard/common/widgets/image_editor.dart';

class DocumentViewer extends StatefulWidget {
  final List<Uint8List> imagePaths;
  final int initialPage;
  final Future<void> Function()? startScan;
  final Function(BuildContext)? showScannerDialog;

  const DocumentViewer({
    super.key,
    required this.imagePaths,
    required this.initialPage,
    this.startScan,
    this.showScannerDialog,
  });

  @override
  _DocumentViewerState createState() => _DocumentViewerState();
}

class _DocumentViewerState extends State<DocumentViewer> {
  late int currentPage;
  late bool isFullScreen;
  late bool isThumbnailsVisible;
  final TextEditingController _pageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentPage = widget.imagePaths.isEmpty ||
            widget.initialPage < 0 ||
            widget.initialPage >= widget.imagePaths.length
        ? 0
        : widget.initialPage;
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

      // Configure timeouts (especially useful for large files)
      dio.options.connectTimeout =
          const Duration(seconds: 30); // 30 seconds to connect
      dio.options.receiveTimeout =
          const Duration(seconds: 30); // 30 seconds to receive data

      // Convert the image data to a base64 string
      String base64Image = base64Encode(imageData);

      // Create the payload as a proper JSON object
      final payload = {
        'content':
            base64Image, // Replace 'fileData' with the expected key by the API
      };

      print('before post ');
      // Send the POST request with base64 encoded image data
      final response = await dio.post(
        apiUrl,
        data: payload,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print(response);

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
        // Update the current image with the edited image
        widget.imagePaths[currentPage] = editedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int validCurrentPage = 0;
    if (widget.imagePaths.isNotEmpty) {
      validCurrentPage = currentPage.clamp(0, widget.imagePaths.length - 1);
      _pageController.text = (validCurrentPage + 1).toString();
    }

    return Scaffold(
      body: Column(
        children: [
          // Header Row
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (widget.startScan != null)
                      IconButton(
                        icon: const Icon(Icons.scanner),
                        onPressed: widget.startScan,
                      ),
                    if (widget.showScannerDialog != null)
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () => widget.showScannerDialog!(context),
                      ),
                    IconButton(
                      icon: Icon(isThumbnailsVisible
                          ? Icons.view_compact
                          : Icons.view_sidebar),
                      onPressed: _toggleThumbnails,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
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
                    IconButton(
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () {
                        setState(() {
                          widget.imagePaths.clear();
                          currentPage = 0;
                        });
                      },
                    ),
                  ],
                ),
                // Page Indicator and Search
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: TextField(
                        controller: _pageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          border: OutlineInputBorder(),
                          hintText: 'Page',
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'of ${widget.imagePaths.length}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(36, 36),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: _goToPage,
                      child: const Icon(Icons.search, size: 20),
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: widget.imagePaths.isNotEmpty
                          ? () => _saveImage(
                              widget.imagePaths[validCurrentPage], context)
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit), // Change to edit icon
                      onPressed: _editImage, // Open edit image screen
                    ),
                    IconButton(
                      icon: Icon(isFullScreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen),
                      onPressed: _toggleFullScreen,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: validCurrentPage > 0
                          ? () => _changePage(validCurrentPage - 1)
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: validCurrentPage < widget.imagePaths.length - 1
                          ? () => _changePage(validCurrentPage + 1)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Main Viewer Area
          Expanded(
            child: Stack(
              children: [
                // Main Page Image
                Center(
                  child: GestureDetector(
                    onTap: _toggleFullScreen,
                    child: widget.imagePaths.isNotEmpty
                        ? Image.memory(
                            widget.imagePaths[validCurrentPage],
                            width: isFullScreen
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width * 0.9,
                            height: isFullScreen
                                ? MediaQuery.of(context).size.height
                                : MediaQuery.of(context).size.height * 0.8,
                            fit: BoxFit.contain,
                          )
                        : Container(),
                  ),
                ),
                // Thumbnails (Vertical Stack)
                if (isThumbnailsVisible)
                  Positioned(
                    left: 0,
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
