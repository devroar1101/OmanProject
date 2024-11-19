class ScanDocumentSummary {
  String year;
  String jobOwner;
  String dateOntheLetter;
  String fileNameEnglish;
  String typeNameEnglish;
  String toDepartmentNameEnglish;
  String toDgNameEnglish;
  String fromExternalLocationNameEnglish;
  String directionNameEnglish;
  String fromDepartmentNameEnglish;
  String fromDgNameEnglish;
  String referenceNumber;
  String scanDocumentObjectId;
  String letterSubjectName;
  String scanType;
  String tenderNumber;
  String userName;
  String actionToBetaken;
  String priority;
  String classification;
  String tenderStatusNameEnglish;
  String createdBy;
  String fromLocationUser;
  String classificationObjectId;
  String departmentObjectId;
  String userNameObjectId;
  String fromExternalLocationObjectId;
  String sendTo;
  String comment;
  String scanDocumentLetterSubject;
  String fromLocationTypeNameEnglish;
  String flagStatus;

  ScanDocumentSummary({
    required this.year,
    required this.jobOwner,
    required this.dateOntheLetter,
    required this.fileNameEnglish,
    required this.typeNameEnglish,
    required this.toDepartmentNameEnglish,
    required this.toDgNameEnglish,
    required this.fromExternalLocationNameEnglish,
    required this.directionNameEnglish,
    required this.fromDepartmentNameEnglish,
    required this.fromDgNameEnglish,
    required this.referenceNumber,
    required this.scanDocumentObjectId,
    required this.letterSubjectName,
    required this.scanType,
    required this.tenderNumber,
    required this.userName,
    required this.actionToBetaken,
    required this.priority,
    required this.classification,
    required this.tenderStatusNameEnglish,
    required this.createdBy,
    required this.fromLocationUser,
    required this.classificationObjectId,
    required this.departmentObjectId,
    required this.userNameObjectId,
    required this.fromExternalLocationObjectId,
    required this.sendTo,
    required this.comment,
    required this.scanDocumentLetterSubject,
    required this.fromLocationTypeNameEnglish,
    required this.flagStatus,
  });

  // fromMap constructor
  factory ScanDocumentSummary.fromMap(Map<String, dynamic> map) {
    return ScanDocumentSummary(
      year: map['year'] ?? '',
      jobOwner: map['jobOwner'] ?? '',
      dateOntheLetter: map['dateOntheLetter'] ?? '',
      fileNameEnglish: map['fileNameEnglish'] ?? '',
      typeNameEnglish: map['typeNameEnglish'] ?? '',
      toDepartmentNameEnglish: map['toDepartmentNameEnglish'] ?? '',
      toDgNameEnglish: map['toDgNameEnglish'] ?? '',
      fromExternalLocationNameEnglish: map['fromExternalLocationNameEnglish'] ?? '',
      directionNameEnglish: map['directionNameEnglish'] ?? '',
      fromDepartmentNameEnglish: map['fromDepartmentNameEnglish'] ?? '',
      fromDgNameEnglish: map['fromDgNameEnglish'] ?? '',
      referenceNumber: map['referenceNumber'] ?? '',
      scanDocumentObjectId: map['scanDocumentObjectId'] ?? '',
      letterSubjectName: map['letterSubjectName'] ?? '',
      scanType: map['scanType'] ?? '',
      tenderNumber: map['tenderNumber'] ?? '',
      userName: map['userName'] ?? '',
      actionToBetaken: map['actionToBetaken'] ?? '',
      priority: map['priority'] ?? '',
      classification: map['classification'] ?? '',
      tenderStatusNameEnglish: map['tenderStatusNameEnglish'] ?? '',
      createdBy: map['createdBy'] ?? '',
      fromLocationUser: map['fromLocationUser'] ?? '',
      classificationObjectId: map['classificationObjectId'] ?? '',
      departmentObjectId: map['departmentObjectId'] ?? '',
      userNameObjectId: map['userNameObjectId'] ?? '',
      fromExternalLocationObjectId: map['fromExternalLocationObjectId'] ?? '',
      sendTo: map['sendTo'] ?? '',
      comment: map['comment'] ?? '',
      scanDocumentLetterSubject: map['scanDocumentLetterSubject'] ?? '',
      fromLocationTypeNameEnglish: map['fromLocationTypeNameEnglish'] ?? '',
      flagStatus: map['flagStatus'] ?? '',
    );
  }
}
