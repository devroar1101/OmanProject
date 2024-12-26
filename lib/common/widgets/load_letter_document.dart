import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/office/letter/model/letter_attachment_repo.dart';
import 'package:tenderboard/office/letter/model/letter_content_repo.dart';
import 'package:tenderboard/common/widgets/document_viewer.dart';

class LoadLetterDocument extends ConsumerStatefulWidget {
  final String objectId;

  const LoadLetterDocument({super.key, required this.objectId});

  @override
  _LoadLetterDocumentState createState() => _LoadLetterDocumentState();
}

class _LoadLetterDocumentState extends ConsumerState<LoadLetterDocument> {
  List<Uint8List> images = [];
  bool isFirstImageLoaded = false;
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    _fetchAttachmentsAndLoadImages();
  }

  Future<void> _fetchAttachmentsAndLoadImages() async {
    final attachmentRepo = ref.read(letterAttachmentRepositoryProvider);
    final contentRepo = ref.read(letterContentRepositoryProvider);

    try {
      // Fetch attachment to get total pages
      final attachment = await attachmentRepo.getAttachmentByObjectId(
        objectId: widget.objectId,
      );

      if (attachment == null || attachment.totalPage == null) {
        throw Exception("No attachment or pages found for objectId.");
      }

      // Start fetching images asynchronously
      for (int page = 1; page <= attachment.totalPage!; page++) {
        _fetchImage(contentRepo, page, attachment.totalPage!);
      }
    } catch (e) {
      print("Error fetching attachment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _fetchImage(
    LetterContentRepository contentRepo,
    int page,
    int totalPages,
  ) async {
    try {
      final content = await contentRepo.getContentByObjectId(
        objectId: widget.objectId,
        pageNumber: page,
      );

      if (content != null && content.content != null) {
        final decodedImage = base64Decode(content.content!);
        setState(() {
          images.add(decodedImage);

          // Mark the first image as loaded
          if (!isFirstImageLoaded) {
            isFirstImageLoaded = true;
          }
        });
      }
    } catch (e) {
      print("Error fetching image for page $page: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isFirstImageLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return DocumentViewer(
      imagePaths: images,
      initialPage: 0,
    );
  }
}
