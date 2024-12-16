import 'dart:convert'; // For base64Decode
import 'dart:typed_data'; // For Uint8List
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ImageService {
  final Dio _dio = Dio();

  // Fetch a single image by its ID
  Future<Uint8List> fetchImageById(
      int fileDataId, int fileInformationId) async {
    final url =
        "http://192.168.1.12:8080/api/FileData/GetbyId?FileDataId=$fileDataId&FileInformationId=$fileInformationId";

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: {'accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final base64Content = data['base64Content'];

        if (base64Content == null) {
          throw Exception('No base64Content found in the response');
        }

        return base64Decode(base64Content); // Decode the base64 string
      } else {
        throw Exception(
            'Failed to fetch image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch image: $e');
    }
  }

  // Fetch a list of images by their IDs
  Future<List<Uint8List>> fetchImages(List<Map<String, int>> idPairs) async {
    List<Uint8List> images = [];
    try {
      for (var idPair in idPairs) {
        final fileDataId = idPair['fileDataId'];
        final fileInformationId = idPair['fileInformationId'];

        if (fileDataId != null && fileInformationId != null) {
          final image = await fetchImageById(fileDataId, fileInformationId);
          images.add(image);
        }
      }
      return images;
    } catch (e) {
      throw Exception('Failed to load images: $e');
    }
  }
}

class ImageViewerScreen extends StatefulWidget {
  const ImageViewerScreen({super.key});

  @override
  _ImageViewerScreenState createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  final ImageService _imageService = ImageService();
  final List<Uint8List> _images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final idPairs = [
        {'fileDataId': 2, 'fileInformationId': 1},
        {'fileDataId': 3, 'fileInformationId': 1},

        // Add more ID pairs as needed
      ];

      final fetchedImages = await _imageService.fetchImages(idPairs);
      setState(() {
        _images.addAll(fetchedImages);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Error loading images: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Viewer')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _images.isEmpty
              ? const Center(child: Text("No images available"))
              : ListView.builder(
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.memory(
                        _images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text("Failed to load image"),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
