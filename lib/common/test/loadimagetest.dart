import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/document_viewer.dart';

class ImageService {
  final Dio _dio = Dio();

  // Fetch a list of images from Lorem Picsum API
  Future<List<Uint8List>> fetchImages({int page = 1, int perPage = 10}) async {
    final url = "https://picsum.photos/v2/list?page=$page&limit=$perPage";

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        List<Uint8List> images = [];

        for (var item in data) {
          final imageUrl = item['download_url']; // Get the image URL
          final imageResponse = await _dio.get(
            imageUrl,
            options: Options(responseType: ResponseType.bytes),
          );
          if (imageResponse.statusCode == 200) {
            images.add(imageResponse.data); // Add image as bytes
          }
        }

        return images;
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      throw Exception('Failed to load images: $e');
    }
  }
}

class TestImageViewerScreen extends StatefulWidget {
  const TestImageViewerScreen({super.key});

  @override
  _TestImageViewerScreenState createState() => _TestImageViewerScreenState();
}

class _TestImageViewerScreenState extends State<TestImageViewerScreen> {
  final ImageService _imageService = ImageService();
  final List<Uint8List> _images = [];
  bool _isLoading = true;
  final int _currentPage = 1;
  final int _totalPages = 5;

  @override
  void initState() {
    super.initState();
    _loadInitialImages();
  }

  Future<void> _loadInitialImages() async {
    try {
      final initialImages =
          await _imageService.fetchImages(page: 1, perPage: 1);
      setState(() {
        _images.addAll(initialImages);
        _isLoading = false;
      });
      _loadRemainingImages(); // Load remaining images in the background
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Error loading initial images: $e");
    }
  }

  Future<void> _loadRemainingImages() async {
    for (int page = 2; page <= _totalPages; page++) {
      try {
        final moreImages =
            await _imageService.fetchImages(page: page, perPage: 15);
        setState(() {
          _images.addAll(moreImages);
        });
      } catch (e) {
        debugPrint("Error loading images for page $page: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : DocumentViewer(
              imagePaths: _images,
              initialPage: 0,
            ),
    );
  }
}
