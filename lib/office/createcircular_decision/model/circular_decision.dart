class CircularDecision {
  final int? id;
  final int? circularNo;
  final String? documentType;
  final String? subject;
  final int typeId;
  final String? comment;
  final int? classificationId;
  final String? meetingNumber;
  final String? documentDate;
  final int? priorityId;
  final String? objectId;

  CircularDecision({
    this.id,
    this.circularNo,
    this.documentType,
    this.subject,
    required this.typeId,
    this.comment,
    this.classificationId,
    this.meetingNumber,
    this.documentDate,
    this.priorityId,
    this.objectId,
  });

  // Factory constructor to create an instance from a map
  factory CircularDecision.fromMap(Map<String, dynamic> map) {
    return CircularDecision(
      id: map['id'] as int?,
      circularNo: map['documentNumber'] as int?,
      documentType: map['documentType'] as String?,
      meetingNumber: map['meetingNumber'] as String?,
      priorityId: map['priorityId'] as int?,
      subject: map['subject'] as String?,
      typeId: map['typeId'] as int, // Required field
      comment: map['comment'] as String?,
      documentDate: map['documentDate'] as String?,
      classificationId: map['classificationId'] as int?,
      objectId: map['objectId'] as String?,
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'documentNumber': circularNo,
      'documentType': documentType,
      'subject': subject,
      'typeId': typeId,
      'comment': comment,
      'documentDate': documentDate,
      'classificationId': classificationId,
      'meetingNumber': meetingNumber,
      'priorityId': priorityId,
      'objectId': objectId,
    };
  }
}
