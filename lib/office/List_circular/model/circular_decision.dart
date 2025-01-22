class CircularDecisionSearch {
  final String? documentNumber;
  final String? documentType;
  final String? meetingNumber;
  final String? priority;
  final String? subject;
  final String? typyId;
  final String? classificationId;
  final String objectId;
  final String? createdDate;

  CircularDecisionSearch({
    this.documentNumber,
    this.documentType,
    this.meetingNumber,
    this.priority,
    this.subject,
    this.typyId,
    this.classificationId,
    required this.objectId,
    this.createdDate,
  });

  // Convert a Map to CircularDecisionSearch object
  factory CircularDecisionSearch.fromMap(Map<String, dynamic> map) {
    return CircularDecisionSearch(
      documentNumber: map['documentNumber'] as String?,
      documentType: map['documentType'] as String?,
      meetingNumber: map['documentType'] as String?,
      priority: map['documentType'] as String?,
      subject: map['subject'] as String?,
      typyId: map['typyId'] as String?,
      classificationId: map['classificationId'] as String?,
      objectId: map['objectId'] as String,
      createdDate: map['createdDate'] as String?,
    );
  }

  // Convert CircularDecisionSearch object to Map
  Map<String, dynamic> toMap() {
    return {
      'documentNumber': documentNumber,
      'documentType': documentType,
      'meetingNumber': meetingNumber,
      'priority': priority,
      'subject': subject,
      'typyId': typyId,
      'classificationId': classificationId,
      'objectId': objectId,
      'createdDate': createdDate,
    };
  }
}
