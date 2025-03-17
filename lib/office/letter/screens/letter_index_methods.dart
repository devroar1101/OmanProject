import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/office/document_search/model/document_search_filter.dart';
import 'package:tenderboard/office/document_search/model/document_search_filter_repo.dart';
import 'package:tenderboard/office/document_search/model/document_search_repo.dart';
import 'package:tenderboard/office/letter/model/letter.dart';
import 'package:tenderboard/office/letter/model/letter_action.dart';
import 'package:tenderboard/office/letter/model/letter_action_repo.dart';
import 'package:tenderboard/office/letter/model/letter_attachment.dart';
import 'package:tenderboard/office/letter/model/letter_attachment_repo.dart';
import 'package:tenderboard/office/letter/model/letter_content.dart';
import 'package:tenderboard/office/letter/model/letter_content_repo.dart';
import 'package:tenderboard/office/letter/model/letter_repo.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

/// Utility class for saving form data
class LetterUtils {
  final String? actionToBeTaken;
  final String? negotiationNumber;

  final int? cabinet;
  final int? classification;
  final String? comments;
  final int? createdBy;
  final DateTime? dateOnTheLetter;
  final String? direction;
  final int? externalLocation;
  final int? folder;
  final int? fromUser;
  final int? locationId;
  final DateTime? receivedDate;
  final DateTime? createdDate;
  final String? reference;
  final String? sendTo;
  final String? subject;
  final String? tenderNumber;
  final String? letterNumber;
  final int? tenderStatus;
  final int? toUser;
  final String? objectId;
  final String? directionType;
  final int? priority;
  final int? year;
  List<String>? scanDocuments;

  /// Constructor to initialize all fields
  LetterUtils(
      {this.actionToBeTaken,
      this.cabinet,
      this.classification,
      this.comments,
      this.createdBy,
      this.dateOnTheLetter,
      this.direction,
      this.directionType,
      this.externalLocation,
      this.folder,
      this.fromUser,
      this.locationId,
      this.receivedDate,
      this.createdDate,
      this.reference,
      this.sendTo,
      this.subject,
      this.tenderNumber,
      this.letterNumber,
      this.tenderStatus,
      this.toUser,
      this.priority,
      this.year,
      this.scanDocuments,
      this.objectId,
      this.negotiationNumber});

  Future<String> onSave() async {
    try {
      final letter = Letter(
          year: year ?? 0,
          templateId: 0,
          actionToBeTaken: actionToBeTaken,
          cabinetId: cabinet ?? 0,
          classificationId: classification ?? 0,
          createdBy: createdBy ?? 0,
          dateOnLetter: dateOnTheLetter,
          direction: direction ?? 'incoming',
          directionType: directionType,
          folderId: folder ?? 0,
          flagStatus: 0,
          jobOwnerId: toUser ?? 0,
          letterNumber: letterNumber,
          tenderNumber: tenderNumber,
          objectId: objectId,
          priorityId: priority ?? 0,
          referenecNumber: reference ?? '',
          sendTo: sendTo ?? '',
          statusId: reference != null ? 1 : 0,
          receivedDate: receivedDate,
          createdDate: createdDate,
          subject: subject ?? '',
          tenderStatusId: tenderStatus,
          locationId: locationId,
          comments: comments,
          negotiationNumber: negotiationNumber);

      // Build LetterAction object
      final letterAction = LetterAction(
        actionId: 1,
        comments: comments,
        classificationId: classification ?? 0,
        priorityId: priority ?? 0,
        fromUserId: fromUser ?? 0,
        // locationId: locationId ?? 0,
        pageSelected: 'All',
        sequenceNo: 1,
        toUserId: toUser ?? 0,
        objectId: objectId,
      );

      final letterAttachment = LetterAttachment(
        attachementType: 'ScanDocument',
        createdBy: fromUser,
        displayName: reference,
        fileExtention: 'png',
        fileName: reference,
        objectId: objectId,
        totalPage: scanDocuments?.length ?? 0,
      );

      // Generate list of LetterContent objects based on scanDocuments
      final letterContents = scanDocuments
              ?.asMap()
              .entries
              .map((entry) => LetterContent(
                    content:
                        entry.value, // Replace with actual content if needed
                    objectId: objectId,
                    pageNumber: entry.key + 1, // Page numbers start from 1
                  ))
              .toList() ??
          [];

      final repo = ProviderContainer();

      // Save Letter and LetterAction objects in parallel with LetterContent list
      final response = await Future.wait([
        repo.read(letterRepositoryProvider).createLetter(letter.toMap()),
        repo
            .read(letterActionRepositoryProvider)
            .createLetterAction(letterAction.toMap()),
        repo
            .read(letterAttachmentRepositoryProvider)
            .createAttachment(letterAttachment.toMap()),
        ...letterContents.map((content) => repo
            .read(letterContentRepositoryProvider)
            .createContent(content.toMap())),
      ]);

      return response[0].data['data'];
    } catch (e) {
      print('Error saving data: $e');
      return 'failure';
    }
  }

  Future<String> onSearch({required WidgetRef ref}) async {
    try {
      final filter = DocumentSearchFilter(
              dateOnLetter: dateOnTheLetter,
              direction: direction == 'All' ? null : direction,
              directionType: null,
              externalLocation: externalLocation?.toString(),
              letterDate: dateOnTheLetter,
              letterNumber: null,
              referenceNumber: reference,
              subject: subject == '' ? null : subject,
              tenderNumber: tenderNumber == '' ? null : tenderNumber,
              year: year)
          .toMap();

      updateFilter(ref, filter);

      ref.read(sliderVisibilityProvider.notifier).toggleVisibility();
      return 'success';
    } catch (e) {
      print('Error searching data: $e');
      return 'failure';
    }
  }
}
