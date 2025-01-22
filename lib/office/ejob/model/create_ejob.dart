class Ejob {
  final int? id;
  final String? objectId;
  final int? classificationId;
  final int? priorityId;
  final String? subject;
  final int? createdBy;
  final int? cabinetId;
  final int? fileId;
  final String? expectedResponseDate;

  Ejob({
    this.id,
    this.objectId,
    this.classificationId,
    this.priorityId,
    this.subject,
    this.createdBy,
    this.cabinetId,
    this.fileId,
    this.expectedResponseDate,
  });

  // Convert a Map to an Ejob instance (fromMap)
  factory Ejob.fromMap(Map<String, dynamic> map) {
    return Ejob(
      id: map['id'] as int?,
      objectId: map['objectId'] as String?,
      classificationId: map['classificationId'] as int?,
      priorityId: map['priorityId'] as int?,
      subject: map['subject'] as String?,
      createdBy: map['createdBy'] as int?,
      cabinetId: map['cabinetId'] as int?,
      fileId: map['fileId'] as int?,
      expectedResponseDate: map['expectedResponseDate'] as String?,
    );
  }

  // Convert an Ejob instance to a Map (toMap)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'objectId': objectId,
      'classificationId': classificationId,
      'priorityId': priorityId,
      'subject': subject,
      'createdBy': createdBy,
      'cabinetId': cabinetId,
      'fileId': fileId,
      'expectedResponseDate': expectedResponseDate,
    };
  }
}
