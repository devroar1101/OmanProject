class Letter {
  final int? letterId;
  final int? cabinetId;
  final int? fileId;
  final String? subject;
  final int year;
  final DateTime? dateOnLetter;
  final int templateId;
  final DateTime? receivedDate;
  final int? classificationId;
  final int? priorityId;
  final String? sendTo;
  final int? flagStatus;
  final String? direction;
  final String? referenecNumber;
  final String? letterNumber;
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
    this.fileId,
    this.subject,
    required this.year,
    this.dateOnLetter,
    required this.templateId,
    this.receivedDate,
    this.classificationId,
    this.priorityId,
    this.sendTo,
    this.flagStatus,
    this.direction,
    this.referenecNumber,
    this.letterNumber,
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
      fileId: map['fileId'],
      subject: map['subject'],
      year: map['year'] ?? 0,
      dateOnLetter: map['dateOnLetter'] != null
          ? DateTime.parse(map['dateOnLetter'])
          : null,
      templateId: map['templateId'] ?? 0,
      receivedDate: map['receivedDate'] != null
          ? DateTime.parse(map['receivedDate'])
          : null,
      classificationId: map['classificationId'],
      priorityId: map['priorityId'],
      sendTo: map['sendTo'],
      flagStatus: map['flagStatus'],
      direction: map['direction'],
      referenecNumber: map['referenecNumber'],
      letterNumber: map['letterNumber'],
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
      'letterId': letterId,
      'cabinetId': cabinetId,
      'fileId': fileId,
      'subject': subject,
      'year': year,
      'dateOnLetter': dateOnLetter?.toIso8601String(),
      'templateId': templateId,
      'receivedDate': receivedDate?.toIso8601String(),
      'classificationId': classificationId,
      'priorityId': priorityId,
      'sendTo': sendTo,
      'flagStatus': flagStatus,
      'direction': direction,
      'referenecNumber': referenecNumber,
      'letterNumber': letterNumber,
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
