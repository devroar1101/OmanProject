import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/office/letter/model/letter.dart';
import 'package:tenderboard/office/letter/model/letter_action.dart';
import 'package:tenderboard/office/letter/model/letter_action_repo.dart';
import 'package:tenderboard/office/letter/model/letter_repo.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

/// Utility class for saving form data
class LetterUtils {
  final String? actionToBeTaken;
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
  final String? reference;
  final String? sendTo;
  final String? subject;
  final String? tenderNumber;
  final int? toUser;

  final int? priority;
  final int? year;

  static const Uuid _uuid = Uuid();

  /// Constructor to initialize all fields
  LetterUtils({
    this.actionToBeTaken,
    this.cabinet,
    this.classification,
    this.comments,
    this.createdBy,
    this.dateOnTheLetter,
    this.direction,
    this.externalLocation,
    this.folder,
    this.fromUser,
    this.locationId,
    this.receivedDate,
    this.reference,
    this.sendTo,
    this.subject,
    this.tenderNumber,
    this.toUser,
    this.priority,
    this.year,
  });

  /// Method to save form data and return success/failure.
  Future<String> onSave() async {
    try {
      final objectId = _uuid.v4();

      // Build Letter object
      final letter = Letter(
        year: year ?? 0,
        templateId: 0,
        actionToBeTaken: actionToBeTaken,
        cabinetId: cabinet ?? 0,
        classificationId: classification ?? 0,
        createdBy: createdBy ?? 0,
        dateOnLetter: dateOnTheLetter,
        direction: direction ?? 'incoming',
        fileId: folder ?? 0,
        flagStatus: 0,
        jobOwnerId: toUser ?? 0,
        letterNumber: tenderNumber,
        objectId: objectId,
        priorityId: priority ?? 0,
        referenecNumber: reference ?? '',
        sendTo: sendTo ?? '',
        statusId: 1,
        receivedDate: receivedDate,
        subject: subject ?? '',
        tenderStatusId: 1,
      );

      // Build LetterAction object
      final letterAction = LetterAction(
        actionId: 1,
        comments: comments,
        classificationId: classification ?? 0,
        fromUserId: fromUser ?? 0,
        locationId: locationId ?? 1,
        pageSelected: 'All',
        sequenceNo: 1,
        toUserId: toUser ?? 0,
      );

      // Initialize repository container
      final repo = ProviderContainer();

      // Save Letter and LetterAction objects in parallel
      await Future.wait([
        repo.read(letterRepositoryProvider).createLetter(letter.toMap()),
        repo
            .read(letterActionRepositoryProvider)
            .createLetterAction(letterAction.toMap()),
      ]);

      return 'success';
    } catch (e) {
      print('Error saving data: $e');
      return 'failure';
    }
  }
}
