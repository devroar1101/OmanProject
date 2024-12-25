class LetterSummaryResult {
  String? year;
  String? referenceNumber;
  String? createdDate;
  String? dateOnTheLetter;
  String? receivedDate;
  String? direction;
  String? directionType;
  String? cabinetNameArabic;
  String? cabinetNameEnglish;
  String? folderNameArabic;
  String? folderNameEnglish;
  String? priority;
  String? classificationId;
  String? tenderNumber;
  String? tenderStatus;
  String? dgNameArabic;
  String? dgNameEnglish;
  String? departmentNameArabic;
  String? departmentNameEnglish;
  String? sectionNameArabic;
  String? sectionNameEnglish;
  String? systemName;
  String? actionToBeTaken;
  String? summary;
  String? subject;
  String? locationNameArabic;
  String? locationNameEnglish;

  // Computed field based on language
  String? cabinetName;
  String? folderName;
  String? dgName;
  String? departmentName;
  String? sectionName;
  String? locationName;

  // Constructor
  LetterSummaryResult(
      {this.year,
      this.referenceNumber,
      this.createdDate,
      this.dateOnTheLetter,
      this.receivedDate,
      this.direction,
      this.directionType,
      this.cabinetNameArabic,
      this.cabinetNameEnglish,
      this.folderNameArabic,
      this.folderNameEnglish,
      this.priority,
      this.classificationId,
      this.tenderNumber,
      this.tenderStatus,
      this.dgNameArabic,
      this.dgNameEnglish,
      this.departmentNameArabic,
      this.departmentNameEnglish,
      this.sectionNameArabic,
      this.sectionNameEnglish,
      this.systemName,
      this.actionToBeTaken,
      this.summary,
      this.subject,
      this.locationNameArabic,
      this.locationNameEnglish,
      this.cabinetName,
      this.folderName,
      this.departmentName,
      this.dgName,
      this.locationName,
      this.sectionName});

  // Factory constructor to create instance from map
  factory LetterSummaryResult.fromMap(Map<String, dynamic> map, String lang) {
    return LetterSummaryResult(
        year: map['year'],
        referenceNumber: map['referenceNumber'],
        createdDate: map['createdDate'],
        dateOnTheLetter: map['dateOnTheLetter'],
        receivedDate: map['receivedDate'],
        direction: map['direction'],
        directionType: map['directionType'],
        cabinetNameArabic: map['cabinetNameArabic'],
        cabinetNameEnglish: map['cabinetNameEnglish'],
        folderNameArabic: map['folderNameArabic'],
        folderNameEnglish: map['folderNameEnglish'],
        priority: map['priority'],
        classificationId: map['classificationId'],
        tenderNumber: map['tenderNumber'],
        tenderStatus: map['tenderStatus'],
        dgNameArabic: map['dgNameArabic'],
        dgNameEnglish: map['dgNameEnglish'],
        departmentNameArabic: map['departmentNameArabic'],
        departmentNameEnglish: map['departmentNameEnglish'],
        sectionNameArabic: map['sectionNameArabic'],
        sectionNameEnglish: map['sectionNameEnglish'],
        systemName: map['systemName'],
        actionToBeTaken: map['actionToBeTaken'],
        summary: map['summary'],
        subject: map['subject'],
        locationNameArabic: map['locationNameArabic'],
        locationNameEnglish: map['locationNameEnglish'],
        cabinetName:
            lang == 'ar' ? map['cabinetNameArabic'] : map['cabinetNameEnglish'],
        folderName:
            lang == 'ar' ? map['folderNameArabic'] : map['folderNameEnglish'],
        dgName: lang == 'ar' ? map['dgNameArabic'] : map['dgNameEnglish'],
        departmentName: lang == 'ar'
            ? map['departmentNameArabic']
            : map['departmentNameEnglish'],
        sectionName:
            lang == 'ar' ? map['sectionNameArabic'] : map['sectionNameEnglish'],
        locationName: lang == 'ar'
            ? map['locationNameArabic']
            : map['locationNameEnglish']);
  }

  // Method to convert the object to a map (for serialization)
  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'referenceNumber': referenceNumber,
      'createdDate': createdDate,
      'dateOnTheLetter': dateOnTheLetter,
      'receivedDate': receivedDate,
      'direction': direction,
      'directionType': directionType,
      'cabinetNameArabic': cabinetNameArabic,
      'cabinetNameEnglish': cabinetNameEnglish,
      'folderNameArabic': folderNameArabic,
      'folderNameEnglish': folderNameEnglish,
      'priority': priority,
      'classificationId': classificationId,
      'tenderNumber': tenderNumber,
      'tenderStatus': tenderStatus,
      'dgNameArabic': dgNameArabic,
      'dgNameEnglish': dgNameEnglish,
      'departmentNameArabic': departmentNameArabic,
      'departmentNameEnglish': departmentNameEnglish,
      'sectionNameArabic': sectionNameArabic,
      'sectionNameEnglish': sectionNameEnglish,
      'systemName': systemName,
      'actionToBeTaken': actionToBeTaken,
      'summary': summary,
      'subject': subject,
      'locationNameArabic': locationNameArabic,
      'locationNameEnglish': locationNameEnglish,
    };
  }
}
