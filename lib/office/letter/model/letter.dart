import 'package:tenderboard/common/utilities/global_helper.dart';

class Letter {
  final int? letterId;
  final int? cabinetId;
  final int? folderId;
  final int? locationId;
  final String? subject;
  final int year;
  final DateTime? dateOnLetter;
  final int templateId;
  final DateTime? receivedDate;
  final DateTime? createdDate;
  final int? classificationId;
  final int? priorityId;
  final String? sendTo;
  final int? flagStatus;
  final String? direction;
  final String? directionType;
  final String? referenecNumber;
  final String? letterNumber;
  final String? tenderNumber;
  final int? statusId;
  final String? actionToBeTaken;
  final int? tenderStatusId;
  final int? createdBy;
  final int? jobOwnerId;
  final bool? isDeleted;
  final String? objectId;
  final DateTime? timeStamp;

  Letter({
    this.letterId,
    this.cabinetId,
    this.folderId,
    this.locationId,
    this.subject,
    required this.year,
    this.dateOnLetter,
    required this.templateId,
    this.receivedDate,
    this.createdDate,
    this.classificationId,
    this.priorityId,
    this.sendTo,
    this.flagStatus,
    this.direction,
    this.directionType,
    this.referenecNumber,
    this.letterNumber,
    this.tenderNumber,
    this.statusId,
    this.actionToBeTaken,
    this.tenderStatusId,
    this.createdBy,
    this.jobOwnerId,
    this.isDeleted,
    this.objectId,
    this.timeStamp,
  });

  factory Letter.fromMap(Map<String, dynamic> map) {
    return Letter(
      letterId: map['letterId'] ?? 0,
      cabinetId: map['cabinetId'],
      folderId: map['folderId'],
      locationId: map['locationId'],
      subject: map['subject'],
      year: map['year'] ?? 0,
      dateOnLetter: map['dateOnLetter'] != null
          ? DateTime.parse(map['dateOnLetter'])
          : null,
      templateId: map['templateId'] ?? 0,
      receivedDate: map['receivedDate'] != null
          ? DateTime.parse(map['receivedDate'])
          : null,
      createdDate: map['createdDate'] != null
          ? DateTime.parse(map['createdDate'])
          : null,
      classificationId: map['classificationId'],
      priorityId: map['priorityId'],
      sendTo: map['sendTo'],
      flagStatus: map['flagStatus'],
      direction: map['direction'],
      directionType: map['directionType'],
      referenecNumber: map['referenceNumber'],
      letterNumber: map['letterNumber'],
      tenderNumber: map['tenderNumber'],
      statusId: map['statusId'],
      actionToBeTaken: map['actionToBeTaken'],
      tenderStatusId: map['tenderStatusId'],
      createdBy: map['createdBy'],
      jobOwnerId: map['jobOwnerId'],
      isDeleted: map['isDeleted'],
      objectId: map['objectId'],
      timeStamp:
          map['timeStamp'] != null ? DateTime.parse(map['timeStamp']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cabinetId': cabinetId,
      'folderId': folderId,
      'locationId': locationId,
      'subject': subject,
      'year': year,
      'dateOnLetter': formatDateWithoutTime(dateOnLetter),
      'templateId': templateId,
      'receivedDate': formatDateWithoutTime(receivedDate),
      'createdDate': formatDateWithoutTime(createdDate),
      'classificationId': classificationId,
      'priorityId': priorityId,
      'sendTo': sendTo,
      'flagStatus': flagStatus,
      'direction': direction,
      'directionType': directionType,
      'referenceNumber': referenecNumber,
      'letterNumber': letterNumber,
      'tenderNumber': tenderNumber,
      'statusId': statusId,
      'actionToBeTaken': actionToBeTaken,
      'tenderStatusId': tenderStatusId,
      'createdBy': createdBy,
      'jobOwnerId': jobOwnerId,
      'isDeleted': isDeleted,
      'objectId': objectId,
      'timeStamp': timeStamp?.toIso8601String(),
    };
  }
}
