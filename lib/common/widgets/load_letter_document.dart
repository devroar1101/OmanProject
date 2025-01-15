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
  final List<Uint8List> images = [];
  bool isFirstImageLoaded = false;
  bool isFetching = false;
  int totalPage = 0;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    _fetchAttachmentsAndLoadImages();
  }

  Future<void> _fetchAttachmentsAndLoadImages() async {
    if (isFetching) return;
    isFetching = true;

    final attachmentRepo = ref.read(letterAttachmentRepositoryProvider);
    final contentRepo = ref.read(letterContentRepositoryProvider);

    try {
      // Fetch attachment to get total pages
      final attachment = await attachmentRepo.getAttachmentByObjectId(
        objectId: widget.objectId,
      );

      if (attachment == null || attachment.totalPage == null) {
        throw Exception("No attachment or pages found for objectId.");
      } else {
        totalPage = attachment.totalPage!;
      }

      // Fetch the first 10 pages immediately
      final firstBatchPages = List.generate(
        (totalPage < 10) ? totalPage : 10,
        (page) => _fetchImage(contentRepo, page + 1),
      );

      final firstBatchImages = await Future.wait(firstBatchPages);

      if (!isDisposed) {
        setState(() {
          images.addAll(firstBatchImages.whereType<Uint8List>());
          isFirstImageLoaded = true; // First batch is loaded
        });
      }

      // Fetch remaining pages in a microtask
      if (totalPage > 10) {
        _fetchRemainingPagesInMicrotask(contentRepo, totalPage);
      }
    } catch (e) {
      if (!isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      isFetching = false;
    }
  }

  void _fetchRemainingPagesInMicrotask(
    LetterContentRepository contentRepo,
    int totalPages,
  ) {
    Future.microtask(() async {
      final List<Uint8List> remainingImages = [];

      try {
        for (int page = 11; page <= totalPages; page++) {
          if (isDisposed) return; // Stop fetching if the widget is disposed

          try {
            final content = await contentRepo.getContentByObjectId(
              objectId: widget.objectId,
              pageNumber: page,
            );

            if (content != null && content.content != null) {
              final decodedImage = base64Decode(content.content!);
              remainingImages.add(decodedImage);
            }
          } catch (e) {
            print("Error fetching image for page $page: $e");
          }
        }

        // Update the state with all remaining images at once
        if (!isDisposed && remainingImages.isNotEmpty) {
          setState(() {
            images.addAll(remainingImages);
          });
        }
      } catch (e) {
        print("Error fetching remaining pages in microtask: $e");
      }
    });
  }

  Future<Uint8List?> _fetchImage(
    LetterContentRepository contentRepo,
    int page,
  ) async {
    try {
      final content = await contentRepo.getContentByObjectId(
        objectId: widget.objectId,
        pageNumber: page,
      );

      if (content != null && content.content != null) {
        return base64Decode(content.content!);
      }
    } catch (e) {
      print("Error fetching image for page $page: $e");
    }
    return null;
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isFirstImageLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return DocumentViewer(
      imagePaths: images,
      totalPage: images.length,
    );
  }
}
